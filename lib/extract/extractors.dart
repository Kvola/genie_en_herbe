/// Outils d'extraction communs (logique pure Dart, testée) : formats acceptés,
/// décodage des fichiers texte, HTML et RTF. Le découpage en pages est dans
/// `pages.dart` (et `pdf_extract.dart` pour le PDF). Les anciens formats
/// binaires (.doc, .ppt, .xls) ne sont pas lisibles : on demande de les
/// enregistrer en .docx/.pptx/.xlsx/.pdf.
library;

import 'dart:convert';
import 'dart:typed_data';


class ExtractException implements Exception {
  ExtractException(this.code);

  /// `unsupported` | `legacy_office` | `empty` | `corrupt` | `encrypted` | `too_large`
  final String code;

  @override
  String toString() => 'ExtractException($code)';
}

/// Extensions acceptées par le sélecteur de fichiers.
const supportedExtensions = [
  'txt', 'md', 'markdown', 'csv', 'html', 'htm', 'docx', 'pptx', 'xlsx', 'odt', 'odp', 'epub', 'rtf', 'pdf', //
];

/// Taille maximale d'un fichier importé (au-delà, l'appareil peine et le quiz n'aurait pas de sens).
const maxImportBytes = 40 * 1024 * 1024;

String extensionOf(String name) {
  final dot = name.lastIndexOf('.');
  return dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
}

/// UTF-8 (avec ou sans BOM), UTF-16 (BOM), sinon Latin-1 / Windows-1252.
String decodeTextBytes(Uint8List b) {
  if (b.length >= 2 && b[0] == 0xFF && b[1] == 0xFE) return _utf16(b.sublist(2), little: true);
  if (b.length >= 2 && b[0] == 0xFE && b[1] == 0xFF) return _utf16(b.sublist(2), little: false);
  final start = (b.length >= 3 && b[0] == 0xEF && b[1] == 0xBB && b[2] == 0xBF) ? 3 : 0;
  try {
    return utf8.decode(b.sublist(start));
  } on FormatException {
    return b.map(cp1252Char).join();
  }
}

/// Caractères Windows-1252 de 0x80 à 0x9F (guillemets, tirets, œ, €…) ; Latin-1 ailleurs.
const _cp1252 = {
  0x80: '€', 0x82: '‚', 0x83: 'ƒ', 0x84: '„', 0x85: '…', 0x86: '†', 0x87: '‡', 0x88: 'ˆ', 0x89: '‰', 0x8A: 'Š', //
  0x8B: '‹', 0x8C: 'Œ', 0x8E: 'Ž', 0x91: '‘', 0x92: '’', 0x93: '“', 0x94: '”', 0x95: '•', 0x96: '–', 0x97: '—', //
  0x98: '˜', 0x99: '™', 0x9A: 'š', 0x9B: '›', 0x9C: 'œ', 0x9E: 'ž', 0x9F: 'Ÿ',
};

String cp1252Char(int b) => _cp1252[b] ?? String.fromCharCode(b);

String _utf16(Uint8List b, {required bool little}) {
  final units = <int>[];
  for (var i = 0; i + 1 < b.length; i += 2) {
    units.add(little ? b[i] | (b[i + 1] << 8) : (b[i] << 8) | b[i + 1]);
  }
  return String.fromCharCodes(units);
}

// ---------------------------------------------------------------------- //
// HTML
// ---------------------------------------------------------------------- //
const _entities = {
  'amp': '&', 'lt': '<', 'gt': '>', 'quot': '"', 'apos': "'", 'nbsp': ' ', 'laquo': '«', 'raquo': '»', //
  'rsquo': '’', 'lsquo': '‘', 'rdquo': '”', 'ldquo': '“', 'hellip': '…', 'mdash': '—', 'ndash': '–', 'oelig': 'œ', //
  'eacute': 'é', 'egrave': 'è', 'ecirc': 'ê', 'agrave': 'à', 'acirc': 'â', 'ccedil': 'ç', 'ocirc': 'ô', 'ucirc': 'û', //
  'ugrave': 'ù', 'icirc': 'î', 'iuml': 'ï', 'euml': 'ë', 'Eacute': 'É', 'Agrave': 'À', 'Ccedil': 'Ç',
};

String decodeEntities(String s) => s.replaceAllMapped(RegExp(r'&(#x[0-9a-fA-F]+|#\d+|[a-zA-Z]+);'), (m) {
  final e = m[1]!;
  if (e.startsWith('#x')) return String.fromCharCode(int.tryParse(e.substring(2), radix: 16) ?? 0x20);
  if (e.startsWith('#')) return String.fromCharCode(int.tryParse(e.substring(1)) ?? 0x20);
  return _entities[e] ?? m[0]!;
});

/// Texte lisible d'une page HTML : blocs → paragraphes ; scripts, styles et menus ignorés.
String htmlToText(String html) {
  var s = html.replaceAll(RegExp(r'<!--.*?-->', dotAll: true), ' ');
  s = s.replaceAll(
    RegExp(r'<(script|style|noscript|nav|header|footer|svg|head)\b.*?</\1\s*>', caseSensitive: false, dotAll: true),
    ' ',
  );
  s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  s = s.replaceAll(RegExp(r'</?(p|div|h[1-6]|li|tr|section|article|blockquote|pre|ul|ol|table)\b[^>]*>', caseSensitive: false), '\n\n');
  s = s.replaceAll(RegExp(r'<[^>]+>'), ' ');
  s = decodeEntities(s);
  return _tidy(s);
}

String _tidy(String s) => s
    .replaceAll(RegExp(r'[ \t\u00a0]+'), ' ')
    .split('\n')
    .map((l) => l.trim())
    .join('\n')
    .replaceAll(RegExp(r'\n{3,}'), '\n\n')
    .trim();

// ---------------------------------------------------------------------- //
// RTF (lecture simple : texte, paragraphes, caractères spéciaux)
// ---------------------------------------------------------------------- //
const _rtfSkip = {
  'fonttbl', 'colortbl', 'stylesheet', 'info', 'pict', 'header', 'footer', 'headerl', 'headerr', 'footerl', //
  'footerr', 'footnote', 'listtable', 'listoverridetable', 'rsidtbl', 'generator', 'xmlnstbl', 'themedata', //
  'colorschememapping', 'latentstyles', 'datastore', 'fldinst', 'object', 'filetbl', 'revtbl',
};

String rtfToText(String rtf) {
  final out = StringBuffer();
  final stack = <(bool, int)>[]; // (groupe ignoré, uc)
  var skip = false;
  var uc = 1; // caractères de repli après \uN
  var pendingSkip = 0;
  var i = 0;
  while (i < rtf.length) {
    final ch = rtf[i];
    if (ch == '{') {
      stack.add((skip, uc));
      i++;
      if (rtf.startsWith(r'{\*', i - 1)) skip = true;
      continue;
    }
    if (ch == '}') {
      if (stack.isNotEmpty) (skip, uc) = stack.removeLast();
      i++;
      continue;
    }
    if (ch == '\\') {
      final m = RegExp(r"\\([a-zA-Z]+)(-?\d+)? ?|\\'([0-9a-fA-F]{2})|\\(.)", dotAll: true).matchAsPrefix(rtf, i);
      if (m == null) {
        i++;
        continue;
      }
      i = m.end;
      if (m[3] != null) {
        if (pendingSkip > 0) {
          pendingSkip--;
        } else if (!skip) {
          out.write(cp1252Char(int.parse(m[3]!, radix: 16)));
        }
        continue;
      }
      if (m[4] != null) {
        final c = m[4]!;
        if (!skip && (c == '\\' || c == '{' || c == '}')) out.write(c);
        if (!skip && c == '~') out.write(' ');
        if (!skip && (c == '\n' || c == '\r')) out.write('\n'); // « \ » en fin de ligne = paragraphe
        continue;
      }
      final word = m[1]!;
      final arg = m[2] == null ? null : int.parse(m[2]!);
      if (_rtfSkip.contains(word)) {
        skip = true;
      } else if (word == 'uc') {
        uc = arg ?? 1;
      } else if (word == 'u' && arg != null) {
        if (!skip) out.writeCharCode(arg < 0 ? arg + 65536 : arg);
        pendingSkip = uc;
      } else if (!skip) {
        switch (word) {
          case 'par' || 'line' || 'sect' || 'page':
            out.write('\n');
          case 'tab' || 'cell':
            out.write('\t');
          case 'row':
            out.write('\n');
          case 'emdash':
            out.write('—');
          case 'endash':
            out.write('–');
          case 'lquote':
            out.write('‘');
          case 'rquote':
            out.write('’');
          case 'ldblquote':
            out.write('“');
          case 'rdblquote':
            out.write('”');
          case 'bullet':
            out.write('•');
        }
      }
      continue;
    }
    if (ch == '\r' || ch == '\n') {
      i++;
      continue;
    }
    if (pendingSkip > 0) {
      pendingSkip--;
    } else if (!skip) {
      out.write(ch);
    }
    i++;
  }
  return _tidy(out.toString().replaceAll('\n', '\n\n'));
}
