import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/background.dart';
import '../../engine/text_tools.dart';
import '../../extract/extractors.dart';
import '../../extract/ocr.dart';
import '../../extract/pages.dart';
import '../../extract/pdf_extract.dart';
import '../../online/api.dart';
import '../../online/online_providers.dart';
import '../../providers.dart';
import '../common.dart';
import '../online/online_common.dart';
import 'document_screen.dart';

/// Message d'un fichier illisible.
String extractError(BuildContext context, String code) {
  final l = context.l10n;
  return switch (code) {
    'legacy_office' => l.errLegacyOffice,
    'empty' => l.errEmptyFile,
    'corrupt' => l.errCorrupt,
    'encrypted' => l.errEncrypted,
    'too_large' => l.errTooLarge,
    _ => l.errUnsupported,
  };
}

/// Lot de pages envoyé en une fois (le serveur en accepte 100 et 600 000 caractères).
const _batchPages = 25;
const _batchChars = 150000;

/// Charger un document : choisir un fichier (ou photographier des pages, ou coller un texte),
/// le lire page par page sur le téléphone, vérifier, puis l'envoyer par lots.
class ImportScreen extends ConsumerStatefulWidget {
  const ImportScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ImportScreen()));

  @override
  ConsumerState<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends ConsumerState<ImportScreen> {
  final _title = TextEditingController();
  ExtractedDocument? _doc;
  String _fileName = '';
  String _fileKind = '';
  String _lang = 'auto';

  /// Lecture ou envoi en cours : (message, avancement 0..1 ou null).
  (String, double?)? _progress;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _setProgress(String message, [double? value]) {
    if (mounted) setState(() => _progress = (message, value));
  }

  void _loaded(ExtractedDocument doc, String fileName, String kind, String title) {
    if (!doc.hasText) {
      context.toast(context.l10n.errNoText);
      setState(() => _progress = null);
      return;
    }
    setState(() {
      _doc = doc;
      _fileName = fileName;
      _fileKind = kind;
      _title.text = title;
      _progress = null;
      final sample = doc.pages.map((p) => p.text).join('\n').substring(0, doc.chars.clamp(0, 20000));
      _lang = detectLanguage(sample);
    });
  }

  Future<void> _pickFile() async {
    final l = context.l10n;
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [...supportedExtensions, 'doc', 'ppt', 'xls'],
    );
    final file = picked.firstOrNull;
    if (file == null || !mounted) return;
    final size = await file.length();
    if (size != null && size > maxImportBytes) {
      if (mounted) context.toast(extractError(context, 'too_large'));
      return;
    }
    _setProgress(l.importReading);
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    try {
      final ext = extensionOf(file.name);
      final doc = ext == 'pdf'
          ? await const PdfExtractor().extract(bytes, onProgress: (d, t) => _setProgress(l.importReadingPages(d, t), d / t))
          : await runInBackground(() => extractPages(file.name, bytes));
      if (!mounted) return;
      final dot = file.name.lastIndexOf('.');
      _loaded(doc, file.name, ext, dot > 0 ? file.name.substring(0, dot) : file.name);
    } on ExtractException catch (e) {
      if (mounted) {
        setState(() => _progress = null);
        context.toast(extractError(context, e.code));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _progress = null);
        context.toast(extractError(context, 'corrupt'));
      }
    }
  }

  /// Pages d'un cahier ou d'un manuel photographiées : une photo = une page (OCR sur le téléphone).
  Future<void> _scan() async {
    final l = context.l10n;
    const ocr = OcrService();
    List<String>? images;
    try {
      images = await ocr.scanDocument(pageLimit: 40);
    } catch (_) {
      if (mounted) context.toast(l.errScanner);
      return;
    }
    if (images == null || !mounted) return;
    final pages = <ExtractedPage>[];
    for (var i = 0; i < images.length; i++) {
      _setProgress(l.importRecognizing(i + 1, images.length), (i + 1) / images.length);
      try {
        pages.add(ExtractedPage('', await ocr.recognizeFile(images[i])));
      } catch (_) {
        pages.add(const ExtractedPage('', ''));
      }
    }
    if (!mounted) return;
    _loaded(ExtractedDocument('page', pages), '', 'photo', l.importScanTitle);
  }

  Future<void> _paste() async {
    final l = context.l10n;
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.importPaste),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: controller,
            autofocus: true,
            minLines: 8,
            maxLines: 14,
            decoration: InputDecoration(hintText: l.importPasteHint, border: const OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, controller.text), child: Text(l.confirm)),
        ],
      ),
    );
    controller.dispose();
    if (text == null || text.trim().length < 80 || !mounted) {
      if (text != null && mounted) context.toast(l.errNoText);
      return;
    }
    final doc = pagesFromText(text);
    final firstLine = text.trim().split('\n').first.trim();
    _loaded(doc, '', 'txt', firstLine.length > 60 ? '${firstLine.substring(0, 59)}…' : firstLine);
  }

  Future<void> _upload() async {
    final l = context.l10n;
    final doc = _doc!;
    final title = _title.text.trim();
    if (title.length < 2) {
      context.toast(l.importNeedTitle);
      return;
    }
    final service = ref.read(onlineServiceProvider);
    _setProgress(l.importSending, 0);
    int? id;
    try {
      id = await service.beginDocument({
        'name': title,
        'filename': _fileName,
        'file_kind': _fileKind,
        'unit': doc.unit,
        if (_lang != 'auto') 'lang': _lang,
      });
      var sent = 0;
      while (sent < doc.pages.length) {
        final batch = <Map<String, String>>[];
        var chars = 0;
        while (sent + batch.length < doc.pages.length && batch.length < _batchPages) {
          final page = doc.pages[sent + batch.length];
          if (batch.isNotEmpty && chars + page.text.length > _batchChars) break;
          batch.add(page.toJson());
          chars += page.text.length;
        }
        await _sendWithRetry(() => service.sendPages(id!, batch));
        sent += batch.length;
        _setProgress(l.importSendingPages(sent, doc.pages.length), sent / doc.pages.length);
      }
      final done = await service.finishDocument(id, langGiven: _lang != 'auto');
      ref.invalidate(libraryProvider);
      if (!mounted) return;
      final navigator = Navigator.of(context);
      navigator.pop();
      await DocumentScreen.open(navigator.context, done.id, justImported: true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _progress = null);
      final existing = e.code == 'DUPLICATE' ? e.details['document_id'] : null;
      if (existing is num) {
        context.toast(l.importDuplicate);
        final navigator = Navigator.of(context);
        navigator.pop();
        await DocumentScreen.open(navigator.context, existing.toInt());
        return;
      }
      context.toast(onlineError(context, e));
    }
  }

  /// Un lot perdu par le réseau est renvoyé (deux fois au plus) ; une erreur du serveur ne l'est pas.
  Future<T> _sendWithRetry<T>(Future<T> Function() send) async {
    for (var attempt = 0;; attempt++) {
      try {
        return await send();
      } on ApiException catch (e) {
        if (!e.isNetwork || attempt >= 2) rethrow;
        await Future<void>.delayed(Duration(seconds: 2 * (attempt + 1)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final progress = _progress;
    final doc = _doc;
    return PopScope(
      canPop: progress == null,
      child: Scaffold(
        appBar: AppBar(title: Text(l.importTitle)),
        body: SafeArea(
          top: false,
          child: progress != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(progress.$1, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(value: progress.$2),
                      ],
                    ),
                  ),
                )
              : doc == null
              ? _sources(context)
              : _review(context, doc),
        ),
      ),
    );
  }

  Widget _sources(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.importIntro),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(l.importFile),
            subtitle: Text(l.importFileHint),
            onTap: _pickFile,
          ),
        ),
        if (ocrSupported) ...[
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.document_scanner_outlined),
              title: Text(l.importScan),
              subtitle: Text(l.importScanHint),
              onTap: _scan,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: const Icon(Icons.content_paste),
            title: Text(l.importPaste),
            subtitle: Text(l.importPasteSub),
            onTap: _paste,
          ),
        ),
        const SizedBox(height: 16),
        Text(l.importPrivacy, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _review(BuildContext context, ExtractedDocument doc) {
    final l = context.l10n;
    final empty = doc.pages.where((p) => p.text.trim().length < 80).length;
    const langs = ['fr', 'en', 'es', 'pt', 'de', 'it'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _title,
          maxLength: 120,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(labelText: l.importDocTitle),
        ),
        DropdownButtonFormField<String>(
          initialValue: _lang,
          decoration: InputDecoration(labelText: l.importLang, helperText: l.importLangHint, helperMaxLines: 2),
          items: [
            DropdownMenuItem(value: 'auto', child: Text(l.importLangAuto)),
            for (final c in langs) DropdownMenuItem(value: c, child: Text(languageName(c))),
          ],
          onChanged: (v) => setState(() => _lang = v ?? 'auto'),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.layers_outlined),
            title: Text(l.docUnits(doc.pages.length, doc.unit)),
            subtitle: Text([
              l.importChars(doc.chars),
              if (empty > 0) l.importEmptyPages(empty),
              if (doc.unit == 'part') l.importPartsHint,
            ].join('\n')),
            isThreeLine: empty > 0 || doc.unit == 'part',
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < doc.pages.length && i < 30; i++)
          ListTile(
            dense: true,
            leading: CircleAvatar(radius: 14, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
            title: Text(
              doc.pages[i].label.isNotEmpty ? doc.pages[i].label : _excerpt(doc.pages[i].text, l.importBlankPage),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (doc.pages.length > 30)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(l.importMorePages(doc.pages.length - 30), style: Theme.of(context).textTheme.bodySmall),
          ),
        const SizedBox(height: 16),
        FilledButton.icon(icon: const Icon(Icons.cloud_upload_outlined), label: Text(l.importSend), onPressed: _upload),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () => setState(() => _doc = null), child: Text(l.importOther)),
      ],
    );
  }

  static String _excerpt(String text, String blank) {
    final t = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (t.isEmpty) return blank;
    return t.length > 120 ? '${t.substring(0, 119)}…' : t;
  }
}

/// Nom d'une langue dans sa propre langue.
String languageName(String code) => switch (code) {
  'fr' => 'Français',
  'en' => 'English',
  'es' => 'Español',
  'pt' => 'Português',
  'de' => 'Deutsch',
  'it' => 'Italiano',
  _ => code,
};
