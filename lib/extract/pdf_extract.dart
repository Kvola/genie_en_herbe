/// Pages d'un PDF : texte natif de chaque page ; une page sans texte (scannée,
/// photographiée) passe par l'OCR sur l'appareil (pas dans un navigateur : seul
/// le texte natif y est lu). Les pages gardent leur numéro (une page vide reste).
library;

import 'dart:math';
import 'dart:typed_data';

import 'package:pdfrx/pdfrx.dart';

import '../engine/text_tools.dart';
import 'extractors.dart';
import 'ocr.dart';
import 'pages.dart';

/// Pages lues au maximum (la limite du serveur).
const maxPdfPages = 400;

/// Pages scannées passées à l'OCR au maximum (c'est lent : quelques secondes par page).
const maxOcrPages = 80;

class PdfExtractor {
  const PdfExtractor({this.ocr = const OcrService()});

  final OcrService ocr;

  /// [onProgress] : (pages traitées, total) pour la barre de progression.
  Future<ExtractedDocument> extract(Uint8List bytes, {void Function(int done, int total)? onProgress}) async {
    if (bytes.length > maxImportBytes) throw ExtractException('too_large');
    await pdfrxFlutterInitialize();
    final PdfDocument doc;
    try {
      doc = await PdfDocument.openData(bytes, sourceName: 'import-${bytes.length}-${bytes.hashCode}');
    } on PdfPasswordException {
      throw ExtractException('encrypted');
    } catch (_) {
      throw ExtractException('corrupt');
    }
    try {
      final total = min(doc.pages.length, maxPdfPages);
      final pages = <ExtractedPage>[];
      var ocrDone = 0;
      for (var i = 0; i < total; i++) {
        final page = doc.pages[i];
        var text = (await page.loadText())?.fullText ?? '';
        if (ocrSupported && text.trim().length < 40 && ocrDone < maxOcrPages) {
          ocrDone++;
          final scanned = await _ocrPage(page, i);
          if (scanned.trim().length > text.trim().length) text = scanned;
        }
        pages.add(ExtractedPage('', cleanText(text)));
        onProgress?.call(i + 1, total);
      }
      if (!pages.any((p) => p.text.isNotEmpty)) throw ExtractException('empty');
      return ExtractedDocument('page', pages);
    } finally {
      await doc.dispose();
    }
  }

  Future<String> _ocrPage(PdfPage page, int index) async {
    // ~200 dpi, borné : assez net pour l'OCR sans saturer la mémoire.
    final scale = min(200 / 72, 2400 / max(page.width, page.height));
    final w = (page.width * scale).round(), h = (page.height * scale).round();
    final image = await page.render(fullWidth: w.toDouble(), fullHeight: h.toDouble(), backgroundColor: 0xFFFFFFFF);
    if (image == null) return '';
    try {
      final path = await ocr.bgraToTempPng(image.pixels, image.width, image.height, 'pdf-page-$index');
      return await ocr.recognizeFile(path);
    } catch (_) {
      return ''; // une page illisible n'empêche pas de lire les autres
    } finally {
      image.dispose();
    }
  }
}
