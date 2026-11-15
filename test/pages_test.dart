import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genie_en_herbe/extract/extractors.dart';
import 'package:genie_en_herbe/extract/pages.dart';

Uint8List zip(Map<String, String> files) {
  final a = Archive();
  for (final e in files.entries) {
    final data = utf8.encode(e.value);
    a.addFile(ArchiveFile(e.key, data.length, data));
  }
  return Uint8List.fromList(ZipEncoder().encode(a));
}

String para(String text, {String extra = '', String style = ''}) =>
    '<w:p>${style.isEmpty ? '' : '<w:pPr><w:pStyle w:val="$style"/></w:pPr>'}<w:r>$extra<w:t>$text</w:t></w:r></w:p>';

String docxXml(String body) =>
    '<?xml version="1.0"?><w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
    '<w:body>$body</w:body></w:document>';

void main() {
  final sentence = 'Le fleuve Niger traverse plusieurs pays de l’Afrique de l’Ouest avant la mer. ';

  test('Word : sauts de page enregistrés', () {
    final body = para('Première page.') +
        para('Suite de la première page.') +
        para('Deuxième page.', extra: '<w:lastRenderedPageBreak/>') +
        para('Troisième page après un saut manuel.', extra: '<w:br w:type="page"/>');
    final doc = extractPages('cours.docx', zip({'word/document.xml': docxXml(body)}));
    expect(doc.unit, 'page');
    expect(doc.pages.map((p) => p.text).toList(), [
      'Première page.\n\nSuite de la première page.',
      'Deuxième page.',
      'Troisième page après un saut manuel.',
    ]);
  });

  test('Word sans sauts : parties par titres', () {
    final body = para('Introduction', style: 'Titre1') +
        para(sentence) +
        para('Le delta intérieur', style: 'Heading1') +
        para(sentence * 2);
    final doc = extractPages('cours.docx', zip({'word/document.xml': docxXml(body)}));
    expect(doc.unit, 'part');
    expect(doc.pages.map((p) => p.label).toList(), ['Introduction', 'Le delta intérieur']);
    expect(doc.pages[1].text, startsWith('Le delta intérieur'));
  });

  test('Word sans sauts ni titres : parties de 3 000 caractères environ', () {
    final body = List.generate(120, (_) => para(sentence)).join();
    final doc = extractPages('cours.docx', zip({'word/document.xml': docxXml(body)}));
    expect(doc.unit, 'part');
    expect(doc.pages.length, greaterThan(2));
    expect(doc.pages.every((p) => p.text.length <= partChars + sentence.length), isTrue);
    expect(doc.pages.every((p) => p.label.isEmpty), isTrue);
  });

  test('PowerPoint : une diapositive par page, notes comprises, vides gardées', () {
    String slide(String t) =>
        '<p:sld xmlns:p="p" xmlns:a="a"><p:txBody><a:p><a:r><a:t>$t</a:t></a:r></a:p></p:txBody></p:sld>';
    final doc = extractPages('cours.pptx', zip({
      'ppt/slides/slide1.xml': slide('Le Niger'),
      'ppt/slides/slide2.xml': '<p:sld xmlns:p="p"/>',
      'ppt/slides/slide10.xml': slide('Conclusion'),
      'ppt/notesSlides/notesSlide1.xml': '<p:notes xmlns:p="p" xmlns:a="a"><a:p><a:r><a:t>Dire que le fleuve est long</a:t></a:r></a:p></p:notes>',
    }));
    expect(doc.unit, 'slide');
    expect(doc.pages.map((p) => p.text).toList(), ['Le Niger.\nDire que le fleuve est long.', '', 'Conclusion.']);
  });

  test('Excel : une feuille par page, avec son nom', () {
    final doc = extractPages('notes.xlsx', zip({
      'xl/workbook.xml': '<workbook xmlns:r="r"><sheets><sheet name="Pays" r:id="rId1"/><sheet name="Fleuves" r:id="rId2"/></sheets></workbook>',
      'xl/_rels/workbook.xml.rels': '<Relationships><Relationship Id="rId1" Target="worksheets/sheet1.xml"/>'
          '<Relationship Id="rId2" Target="worksheets/sheet2.xml"/></Relationships>',
      'xl/sharedStrings.xml': '<sst><si><t>Mali</t></si><si><t>Bamako</t></si><si><t>Niger</t></si></sst>',
      'xl/worksheets/sheet1.xml': '<worksheet><sheetData><row><c t="s"><v>0</v></c><c t="s"><v>1</v></c></row></sheetData></worksheet>',
      'xl/worksheets/sheet2.xml': '<worksheet><sheetData><row><c t="s"><v>2</v></c><c><v>4200</v></c></row></sheetData></worksheet>',
    }));
    expect(doc.unit, 'sheet');
    expect(doc.pages.map((p) => p.label).toList(), ['Pays', 'Fleuves']);
    expect(doc.pages.map((p) => p.text).toList(), ['Mali ; Bamako.', 'Niger ; 4200.']);
  });

  test('Texte : sauts de page ou parties', () {
    final doc = extractPages('a.txt', Uint8List.fromList(utf8.encode('Page un.\fPage deux.\f')));
    expect(doc.unit, 'page');
    expect(doc.pages.map((p) => p.text).toList(), ['Page un.', 'Page deux.']);
    expect(pagesFromText(sentence * 3).unit, 'part');
  });

  test('Fichiers refusés', () {
    expect(() => extractPages('vieux.doc', Uint8List(10)), throwsA(isA<ExtractException>()));
    expect(() => extractPages('x.docx', Uint8List.fromList([1, 2, 3, 4])), throwsA(isA<ExtractException>()));
    expect(() => extractPages('vide.txt', Uint8List.fromList(utf8.encode('   '))), throwsA(isA<ExtractException>()));
  });
}
