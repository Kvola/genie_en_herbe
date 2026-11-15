/// Découpage d'un fichier en PAGES (logique pure Dart, testée ; le PDF est dans `pdf_extract.dart`).
///
/// Une « page » dépend du format :
/// - présentation (pptx, odp) : une diapositive ;
/// - classeur (xlsx) : une feuille ;
/// - traitement de texte (docx, odt) : les sauts de page que Word ou LibreOffice
///   ont enregistrés (`lastRenderedPageBreak`, `soft-page-break`, saut manuel) ;
///   à défaut, les titres de premier niveau ; à défaut, des parties d'environ
///   3 000 caractères coupées entre deux paragraphes ;
/// - texte, HTML, RTF : les sauts de page (`\f`) s'il y en a, sinon des parties ;
/// - livre numérique (epub) : les chapitres (découpés en parties s'ils sont longs).
///
/// Les pages vides sont gardées : la numérotation reste celle du document.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import '../engine/text_tools.dart';
import 'extractors.dart';

/// Une page extraite : son libellé (vide = « Page n » donné par le serveur) et son texte.
class ExtractedPage {
  const ExtractedPage(this.label, this.text);

  final String label;
  final String text;

  Map<String, String> toJson() => {'label': label, 'text': text};
}

/// Le document découpé : unité (`page`, `slide`, `sheet`, `part`) et pages, dans l'ordre.
class ExtractedDocument {
  const ExtractedDocument(this.unit, this.pages);

  final String unit;
  final List<ExtractedPage> pages;

  int get chars => pages.fold(0, (n, p) => n + p.text.length);

  /// Au moins une page avec du vrai texte (sinon : scanné sans OCR, ou vide).
  bool get hasText => pages.any((p) => p.text.trim().length >= 80);
}

/// Taille visée d'une partie quand le document n'a pas de pages.
const partChars = 3000;

/// Découpe un fichier non-PDF en pages. Lève [ExtractException].
ExtractedDocument extractPages(String fileName, Uint8List bytes) {
  if (bytes.length > maxImportBytes) throw ExtractException('too_large');
  final ext = extensionOf(fileName);
  final ExtractedDocument doc;
  try {
    doc = switch (ext) {
      'docx' => _docx(bytes),
      'pptx' => _pptx(bytes),
      'xlsx' => _xlsx(bytes),
      'odt' => _odt(bytes),
      'odp' => _odp(bytes),
      'epub' => _epub(bytes),
      'txt' || 'md' || 'markdown' || 'csv' => _plain(decodeTextBytes(bytes)),
      'html' || 'htm' => _plain(htmlToText(decodeTextBytes(bytes))),
      'rtf' => _rtf(decodeTextBytes(bytes)),
      'doc' || 'ppt' || 'xls' => throw ExtractException('legacy_office'),
      _ => throw ExtractException('unsupported'),
    };
  } on ExtractException {
    rethrow;
  } on FormatException {
    throw ExtractException('corrupt');
  } on XmlException {
    throw ExtractException('corrupt');
  }
  if (!doc.pages.any((p) => p.text.trim().isNotEmpty)) throw ExtractException('empty');
  return doc;
}

/// Texte saisi ou collé : découpé en parties.
ExtractedDocument pagesFromText(String text) => _plain(text);

// ---------------------------------------------------------------------- //
// Parties (documents sans pages)
// ---------------------------------------------------------------------- //

/// Coupe un texte en parties d'environ [target] caractères, entre deux paragraphes
/// (ou deux phrases si un paragraphe est démesuré).
List<String> splitParts(String text, {int target = partChars}) {
  final paragraphs = text.split(RegExp(r'\n\s*\n')).map((p) => p.trim()).where((p) => p.isNotEmpty);
  final parts = <String>[];
  final current = StringBuffer();
  void flush() {
    if (current.isNotEmpty) parts.add(current.toString().trim());
    current.clear();
  }

  for (final p in paragraphs) {
    final pieces = p.length > target * 1.5 ? _bySentences(p, target) : [p];
    for (final piece in pieces) {
      if (current.isNotEmpty && current.length + piece.length > target) flush();
      if (current.isNotEmpty) current.write('\n\n');
      current.write(piece);
    }
  }
  flush();
  return parts;
}

List<String> _bySentences(String p, int target) {
  final out = <String>[];
  final b = StringBuffer();
  for (final s in splitSentences(p)) {
    if (b.isNotEmpty && b.length + s.text.length > target) {
      out.add(b.toString().trim());
      b.clear();
    }
    b
      ..write(b.isEmpty ? '' : ' ')
      ..write(s.text);
  }
  if (b.isNotEmpty) out.add(b.toString().trim());
  return out;
}

ExtractedDocument _plain(String raw) {
  final text = raw.replaceAll('\r\n', '\n');
  if (text.contains('\f')) {
    final pages = text.split('\f').map(cleanText).toList();
    while (pages.isNotEmpty && pages.last.isEmpty) {
      pages.removeLast();
    }
    return ExtractedDocument('page', [for (final p in pages) ExtractedPage('', p)]);
  }
  return ExtractedDocument('part', [for (final p in splitParts(cleanText(text))) ExtractedPage('', p)]);
}

ExtractedDocument _rtf(String rtf) {
  // \page = saut de page manuel : on le garde comme séparateur.
  final marked = rtf.replaceAll(RegExp(r'\\page\b ?'), r'\par \u12\x ');
  final text = rtfToText(marked).replaceAll('\u000c', '\f').replaceAll('\fx', '\f');
  return _plain(text);
}

// ---------------------------------------------------------------------- //
// Archives ZIP de XML
// ---------------------------------------------------------------------- //
Archive _zip(Uint8List bytes) {
  if (bytes.length < 4 || bytes[0] != 0x50 || bytes[1] != 0x4B) {
    if (bytes.length > 8 && bytes[0] == 0xD0 && bytes[1] == 0xCF) throw ExtractException('encrypted');
    throw ExtractException('corrupt');
  }
  return ZipDecoder().decodeBytes(bytes);
}

XmlDocument? _xmlIn(Archive a, String name) {
  final f = a.findFile(name);
  if (f == null) return null;
  return XmlDocument.parse(utf8.decode(f.content, allowMalformed: true));
}

int _num(String name) => int.tryParse(RegExp(r'(\d+)\.xml$').firstMatch(name)?.group(1) ?? '') ?? 0;

/// Une puce sans ponctuation finale reçoit un point (pour le découpage en phrases).
String _terminate(String line) {
  final l = line.trim();
  if (l.isEmpty || RegExp(r'[.!?…:;»"”)]$').hasMatch(l)) return l;
  return '$l.';
}

// ------------------------------------------------------------------ Word
/// Un paragraphe Word : son texte, son style, et s'il commence une nouvelle page.
class _WordPara {
  _WordPara(this.text, this.style, this.breakBefore, this.breakAfter);

  final String text;
  final String style;
  final bool breakBefore;
  final bool breakAfter;
}

ExtractedDocument _docx(Uint8List bytes) {
  final a = _zip(bytes);
  final doc = _xmlIn(a, 'word/document.xml');
  if (doc == null) throw ExtractException('corrupt');
  final body = doc.descendants.whereType<XmlElement>().where((e) => e.name.local == 'body').firstOrNull;
  if (body == null) throw ExtractException('corrupt');
  final paras = <_WordPara>[];
  var rendered = 0;
  for (final p in body.descendants.whereType<XmlElement>().where((e) => e.name.local == 'p')) {
    // Paragraphes imbriqués (zones de texte) : pris une seule fois, au niveau le plus haut.
    if (p.ancestors.whereType<XmlElement>().any((x) => x.name.local == 'p')) continue;
    final line = StringBuffer();
    var before = false, after = false, seenText = false;
    String style = '';
    for (final e in p.descendants.whereType<XmlElement>()) {
      switch (e.name.local) {
        case 't':
          line.write(e.innerText);
          if (e.innerText.trim().isNotEmpty) seenText = true;
        case 'tab':
          line.write('\t');
        case 'br':
          final type = e.getAttribute('w:type') ?? e.getAttribute('type');
          if (type == 'page') {
            if (seenText) {
              after = true;
            } else {
              before = true;
            }
          } else {
            line.write('\n');
          }
        case 'lastRenderedPageBreak':
          rendered++;
          if (!seenText) before = true;
        case 'pageBreakBefore':
          final v = e.getAttribute('w:val') ?? e.getAttribute('val');
          if (v == null || v == 'true' || v == '1' || v == 'on') before = true;
        case 'pStyle':
          style = (e.getAttribute('w:val') ?? e.getAttribute('val') ?? '').toLowerCase();
      }
    }
    paras.add(_WordPara(line.toString().trim(), style, before, after));
  }
  final hasBreaks = rendered > 0 || paras.any((p) => p.breakBefore || p.breakAfter);
  if (hasBreaks) {
    final pages = <List<String>>[[]];
    for (final p in paras) {
      if (p.breakBefore && pages.last.isNotEmpty) pages.add([]);
      if (p.text.isNotEmpty) pages.last.add(p.text);
      if (p.breakAfter) pages.add([]);
    }
    if (pages.length > 1 && pages.last.isEmpty) pages.removeLast();
    return ExtractedDocument('page', [for (final p in pages) ExtractedPage('', p.join('\n\n'))]);
  }
  return _byHeadings(paras.map((p) => (text: p.text, heading: _isHeading1(p.style))).toList());
}

/// Styles de titre de premier niveau (Word en anglais, en français, ou leurs identifiants).
bool _isHeading1(String style) =>
    const {'heading1', 'titre1', 'title', 'titre', 'überschrift1', 'titulo1', 'título1'}.contains(style.replaceAll(' ', ''));

/// Parties d'après les titres de premier niveau (libellé = le titre), découpées si trop longues ;
/// sans titres, des parties de [partChars] caractères.
ExtractedDocument _byHeadings(List<({String text, bool heading})> paras) {
  final headings = paras.where((p) => p.heading && p.text.isNotEmpty).length;
  if (headings < 2) {
    final text = paras.map((p) => p.text).where((t) => t.isNotEmpty).join('\n\n');
    return ExtractedDocument('part', [for (final t in splitParts(text)) ExtractedPage('', t)]);
  }
  final pages = <ExtractedPage>[];
  var title = '';
  final body = <String>[];
  void flush() {
    final text = body.join('\n\n');
    if (text.trim().isEmpty && title.isEmpty) return;
    final parts = text.length > partChars * 2 ? splitParts(text) : [text];
    for (var i = 0; i < parts.length; i++) {
      final label = title.isEmpty ? '' : (parts.length > 1 ? '$title (${i + 1}/${parts.length})' : title);
      pages.add(ExtractedPage(label.length > 80 ? '${label.substring(0, 79)}…' : label, parts[i]));
    }
    body.clear();
  }

  for (final p in paras) {
    if (p.heading && p.text.isNotEmpty) {
      flush();
      title = p.text;
    }
    if (p.text.isNotEmpty) body.add(p.text);
  }
  flush();
  return ExtractedDocument('part', pages);
}

// ------------------------------------------------------------------ PowerPoint
ExtractedDocument _pptx(Uint8List bytes) {
  final a = _zip(bytes);
  final slides = a.files.where((f) => RegExp(r'^ppt/slides/slide\d+\.xml$').hasMatch(f.name)).toList()
    ..sort((x, y) => _num(x.name).compareTo(_num(y.name)));
  final pages = <ExtractedPage>[];
  for (final f in slides) {
    final doc = XmlDocument.parse(utf8.decode(f.content, allowMalformed: true));
    final lines = <String>[];
    for (final p in doc.descendants.whereType<XmlElement>().where((e) => e.name.local == 'p')) {
      final b = StringBuffer();
      for (final e in p.descendants.whereType<XmlElement>()) {
        if (e.name.local == 't') b.write(e.innerText);
        if (e.name.local == 'br') b.write(' ');
      }
      final t = b.toString().trim();
      if (t.isNotEmpty) lines.add(_terminate(t));
    }
    // Les notes de l'orateur complètent souvent la diapositive : on les ajoute.
    final notes = a.findFile('ppt/notesSlides/notesSlide${_num(f.name)}.xml');
    if (notes != null) {
      final n = XmlDocument.parse(utf8.decode(notes.content, allowMalformed: true));
      for (final p in n.descendants.whereType<XmlElement>().where((e) => e.name.local == 'p')) {
        final t = p.descendants.whereType<XmlElement>().where((e) => e.name.local == 't').map((e) => e.innerText).join().trim();
        // Le numéro de diapositive seul n'est pas une note.
        if (t.isNotEmpty && !RegExp(r'^\d+$').hasMatch(t)) lines.add(_terminate(t));
      }
    }
    pages.add(ExtractedPage('', lines.join('\n')));
  }
  return ExtractedDocument('slide', pages);
}

// ------------------------------------------------------------------ Excel
ExtractedDocument _xlsx(Uint8List bytes) {
  final a = _zip(bytes);
  final shared = <String>[];
  final sst = _xmlIn(a, 'xl/sharedStrings.xml');
  if (sst != null) {
    for (final si in sst.descendants.whereType<XmlElement>().where((e) => e.name.local == 'si')) {
      shared.add(si.descendants.whereType<XmlElement>().where((e) => e.name.local == 't').map((e) => e.innerText).join());
    }
  }
  final workbook = _xmlIn(a, 'xl/workbook.xml');
  final rels = _xmlIn(a, 'xl/_rels/workbook.xml.rels');
  final targets = <String, String>{
    for (final r in rels?.descendants.whereType<XmlElement>().where((e) => e.name.local == 'Relationship') ?? <XmlElement>[])
      r.getAttribute('Id') ?? '': r.getAttribute('Target') ?? '',
  };
  final sheets = <({String name, String path})>[];
  for (final s in workbook?.descendants.whereType<XmlElement>().where((e) => e.name.local == 'sheet') ?? <XmlElement>[]) {
    final rid = s.attributes.where((x) => x.name.local == 'id').firstOrNull?.value ?? '';
    var target = targets[rid] ?? '';
    if (target.startsWith('/')) {
      target = target.substring(1);
    } else if (target.isNotEmpty) {
      target = 'xl/$target';
    }
    sheets.add((name: s.getAttribute('name') ?? '', path: target));
  }
  if (sheets.isEmpty) {
    for (final f in a.files.where((f) => RegExp(r'^xl/worksheets/sheet\d+\.xml$').hasMatch(f.name)).toList()
      ..sort((x, y) => _num(x.name).compareTo(_num(y.name)))) {
      sheets.add((name: '', path: f.name));
    }
  }
  final pages = <ExtractedPage>[];
  for (final sheet in sheets) {
    final doc = _xmlIn(a, sheet.path);
    if (doc == null) continue;
    final rows = <String>[];
    for (final row in doc.descendants.whereType<XmlElement>().where((e) => e.name.local == 'row')) {
      final cells = <String>[];
      for (final c in row.children.whereType<XmlElement>().where((e) => e.name.local == 'c')) {
        final type = c.getAttribute('t');
        String value;
        if (type == 'inlineStr') {
          value = c.descendants.whereType<XmlElement>().where((e) => e.name.local == 't').map((e) => e.innerText).join();
        } else {
          final v = c.children.whereType<XmlElement>().where((e) => e.name.local == 'v').firstOrNull?.innerText ?? '';
          final i = int.tryParse(v);
          value = type == 's' ? (i != null && i >= 0 && i < shared.length ? shared[i] : '') : v;
        }
        value = value.trim();
        if (value.isNotEmpty) cells.add(value);
      }
      if (cells.isNotEmpty) rows.add(_terminate(cells.join(' ; ')));
    }
    pages.add(ExtractedPage(sheet.name, rows.join('\n')));
  }
  return ExtractedDocument('sheet', pages);
}

// ------------------------------------------------------------------ OpenDocument
String _odfText(XmlElement p) {
  final b = StringBuffer();
  void walk(XmlNode n) {
    for (final c in n.children) {
      if (c is XmlText) {
        b.write(c.value);
      } else if (c is XmlElement) {
        switch (c.name.local) {
          case 's':
            b.write(' ' * (int.tryParse(c.getAttribute('text:c') ?? c.getAttribute('c') ?? '') ?? 1));
          case 'tab':
            b.write('\t');
          case 'line-break':
            b.write('\n');
          case 'note' || 'soft-page-break':
            break;
          default:
            walk(c);
        }
      }
    }
  }

  walk(p);
  return b.toString().trim();
}

ExtractedDocument _odt(Uint8List bytes) {
  final a = _zip(bytes);
  final doc = _xmlIn(a, 'content.xml');
  if (doc == null) throw ExtractException('corrupt');
  final text = doc.descendants.whereType<XmlElement>().where((e) => e.name.local == 'text').firstOrNull;
  if (text == null) throw ExtractException('corrupt');
  // Sauts de page de LibreOffice (soft-page-break) : les pages telles qu'affichées.
  final hasBreaks = text.descendants.whereType<XmlElement>().any((e) => e.name.local == 'soft-page-break');
  final paras = <({String text, bool heading, bool breakBefore})>[];
  for (final e in text.descendants.whereType<XmlElement>().where((e) => e.name.local == 'p' || e.name.local == 'h')) {
    if (e.ancestors.whereType<XmlElement>().any((x) => x.name.local == 'p' || x.name.local == 'h')) continue;
    final prev = e.previousElementSibling;
    final breakBefore = (prev?.name.local == 'soft-page-break') ||
        e.children.whereType<XmlElement>().firstOrNull?.name.local == 'soft-page-break';
    final level = e.getAttribute('text:outline-level') ?? e.getAttribute('outline-level');
    paras.add((text: _odfText(e), heading: e.name.local == 'h' && (level == null || level == '1'), breakBefore: breakBefore));
  }
  if (hasBreaks) {
    final pages = <List<String>>[[]];
    for (final p in paras) {
      if (p.breakBefore && pages.last.isNotEmpty) pages.add([]);
      if (p.text.isNotEmpty) pages.last.add(p.text);
    }
    return ExtractedDocument('page', [for (final p in pages) ExtractedPage('', p.join('\n\n'))]);
  }
  return _byHeadings([for (final p in paras) (text: p.text, heading: p.heading)]);
}

ExtractedDocument _odp(Uint8List bytes) {
  final a = _zip(bytes);
  final doc = _xmlIn(a, 'content.xml');
  if (doc == null) throw ExtractException('corrupt');
  final pages = <ExtractedPage>[];
  for (final page in doc.descendants.whereType<XmlElement>().where((e) => e.name.local == 'page')) {
    final lines = [
      for (final p in page.descendants.whereType<XmlElement>().where((e) => e.name.local == 'p'))
        if (!p.ancestors.whereType<XmlElement>().any((x) => x.name.local == 'p')) _terminate(_odfText(p)),
    ].where((l) => l.isNotEmpty);
    pages.add(ExtractedPage('', lines.join('\n')));
  }
  return ExtractedDocument('slide', pages);
}

// ------------------------------------------------------------------ EPUB
ExtractedDocument _epub(Uint8List bytes) {
  final a = _zip(bytes);
  final container = _xmlIn(a, 'META-INF/container.xml');
  final opfPath = container?.descendants
      .whereType<XmlElement>()
      .where((e) => e.name.local == 'rootfile')
      .firstOrNull
      ?.getAttribute('full-path');
  List<String> chapters;
  if (opfPath != null && a.findFile(opfPath) != null) {
    final opf = _xmlIn(a, opfPath)!;
    final base = opfPath.contains('/') ? opfPath.substring(0, opfPath.lastIndexOf('/') + 1) : '';
    final manifest = {
      for (final e in opf.descendants.whereType<XmlElement>().where((e) => e.name.local == 'item'))
        e.getAttribute('id'): e.getAttribute('href'),
    };
    chapters = [
      for (final e in opf.descendants.whereType<XmlElement>().where((e) => e.name.local == 'itemref'))
        if (manifest[e.getAttribute('idref')] case final href?) base + Uri.decodeFull(href),
    ];
  } else {
    chapters = a.files.where((f) => RegExp(r'\.x?html?$').hasMatch(f.name)).map((f) => f.name).toList()..sort();
  }
  final pages = <ExtractedPage>[];
  for (final c in chapters) {
    final f = a.findFile(c);
    if (f == null) continue;
    final html = utf8.decode(f.content, allowMalformed: true);
    final text = htmlToText(html);
    if (text.trim().isEmpty) continue;
    final title = RegExp(r'<h[12][^>]*>(.*?)</h[12]>', caseSensitive: false, dotAll: true).firstMatch(html)?.group(1);
    final label = title == null ? '' : htmlToText(title).replaceAll('\n', ' ').trim();
    final parts = text.length > partChars * 2 ? splitParts(text) : [text];
    for (var i = 0; i < parts.length; i++) {
      final l = label.isEmpty ? '' : (parts.length > 1 ? '$label (${i + 1}/${parts.length})' : label);
      pages.add(ExtractedPage(l.length > 80 ? '${l.substring(0, 79)}…' : l, parts[i]));
    }
  }
  return ExtractedDocument('part', pages);
}
