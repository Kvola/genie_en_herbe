import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genie_en_herbe/app/version.dart';
import 'package:genie_en_herbe/online/doc_models.dart';
import 'package:genie_en_herbe/online/models.dart';
import 'package:genie_en_herbe/ui/online/online_links.dart';

PageInfo page(int id, int number, {int total = 3, String ai = 'none'}) => PageInfo({
  'id': id,
  'number': number,
  'label': 'Page $number',
  'chars': 500,
  'ai_state': ai,
  'questions': {'total': total},
});

void main() {
  test('Plages de pages', () {
    expect(ranges([5, 1, 2, 3, 9, 8]), '1–3, 5, 8–9');
    expect(ranges([]), '');
  });

  testWidgets('Sélection : libellé, questions prêtes, IA en cours, mise à jour', (tester) async {
    final sel = PageSelection([
      DocPages(1, 'Histoire', 'page', [page(10, 1), page(11, 2, ai: 'queued'), page(13, 4)]),
      DocPages(2, 'Cours', 'slide', [page(20, 3)]),
    ]);
    late String label;
    await tester.pumpWidget(Localizations(
      locale: const Locale('fr'),
      delegates: const [DefaultWidgetsLocalizations.delegate],
      child: Builder(builder: (c) {
        label = sel.label(c);
        return const SizedBox();
      }),
    ));
    expect(label, 'Histoire : p. 1–2, 4 ; Cours : diapo 3');
    expect(sel.pageIds, [10, 11, 13, 20]);
    expect(sel.readyQuestions, 12);
    expect(sel.pendingAi, 1);
    final fresh = sel.refreshed([page(11, 2, total: 9, ai: 'done')]);
    expect(fresh.readyQuestions, 18);
    expect(fresh.pendingAi, 0);
    expect(PageSelection.empty.isEmpty, isTrue);
  });

  test('État d’un match : pages, organisateur, citation', () {
    final m = MatchState({
      'host_only': true,
      'creator_pseudo': 'MmeKone',
      'pages': [
        {'id': 3, 'label': 'Page 1', 'document_id': 7, 'document': 'Histoire'},
      ],
      'question': {'page_id': 3, 'quote': 'Le fleuve Niger…', 'source': 'offline'},
    });
    expect(m.hostOnly, isTrue);
    expect(m.pages.single.document, 'Histoire');
    expect(m.question!.pageId, 3);
    expect(m.question!.quote, 'Le fleuve Niger…');
  });

  test('Liens : partie (6 caractères) ou document partagé (D + 7)', () {
    expect(parseGameLink(Uri.parse('https://x.ci/genie-en-herbe/rejoindre/ab12cd')).join, 'AB12CD');
    expect(parseGameLink(Uri.parse('genieenherbe://join/AB12CD')).join, 'AB12CD');
    expect(parseDocumentLink(Uri.parse('https://x.ci/genie-en-herbe/join/dabc2345')), 'DABC2345');
    expect(parseDocumentLink(Uri.parse('genieenherbe://join/DABC2345')), 'DABC2345');
    expect(parseDocumentLink(Uri.parse('https://x.ci/genie-en-herbe/rejoindre/AB12CD')), isNull);
    expect(parseGameLink(Uri.parse('https://x.ci/genie-en-herbe/rejoindre/DABC2345')).join, isNull);
    expect(parseGroupLink(Uri.parse('https://x.ci/genie-en-herbe/rejoindre/gabc2345')), 'GABC2345');
    expect(parseGroupLink(Uri.parse('https://x.ci/genie-en-herbe/rejoindre/DABC2345')), isNull);
    expect(parseDocumentLink(Uri.parse('https://x.ci/genie-en-herbe/rejoindre/GABC2345')), isNull);
  });

  test('La version affichée est celle du pubspec', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(RegExp(r'^version: ([\d.]+)\+', multiLine: true).firstMatch(pubspec)!.group(1), appVersion);
  });
}

