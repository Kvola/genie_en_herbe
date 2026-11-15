/// Documents, pages et questions tels que le serveur les envoie.
library;

import 'package:flutter/widgets.dart';

int _int(Object? v, [int fallback = 0]) => v is num ? v.toInt() : fallback;
String _str(Object? v) => v == null ? '' : '$v';
List<Map<String, dynamic>> _maps(Object? v) =>
    v is List ? v.whereType<Map>().map((m) => m.cast<String, dynamic>()).toList() : const [];

/// Un document de la bibliothèque (sans ses pages).
class DocumentSummary {
  DocumentSummary(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  String get name => _str(json['name']);
  String get filename => _str(json['filename']);
  String get fileKind => _str(json['file_kind']);

  /// `page`, `slide`, `sheet`, `part`.
  String get unit => _str(json['unit']).isEmpty ? 'page' : _str(json['unit']);
  String get lang => _str(json['lang']).isEmpty ? 'fr' : _str(json['lang']);

  /// `uploading`, `ready`.
  String get state => _str(json['state']);

  /// `private`, `shared`, `public`.
  String get visibility => _str(json['visibility']);
  String? get shareCode => json['share_code'] as String?;
  String get owner => _str(json['owner']);
  bool get mine => json['mine'] == true;
  int get pageCount => _int(json['page_count']);
  int get chars => _int(json['chars']);
}

/// Nombre de questions d'une page, par origine.
class QuestionCounts {
  QuestionCounts(this.json);

  final Map<String, dynamic> json;

  int get total => _int(json['total']);
  int get validated => _int(json['validated']);
  int get ai => _int(json['ai']);
  int get offline => _int(json['offline']);
  int get manual => _int(json['manual']);
}

/// Une page (sans son texte).
class PageInfo {
  PageInfo(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  int get number => _int(json['number']);
  String get label => _str(json['label']);
  int get chars => _int(json['chars']);

  /// `none`, `queued`, `running`, `done`, `failed`.
  String get aiState => _str(json['ai_state']).isEmpty ? 'none' : _str(json['ai_state']);
  bool get offlineDone => json['offline_done'] == true;
  QuestionCounts get questions => QuestionCounts((json['questions'] as Map?)?.cast<String, dynamic>() ?? const {});

  bool get aiPending => aiState == 'queued' || aiState == 'running';

  /// Une page presque vide (page de titre, page blanche) ne donne pas de question.
  bool get nearlyEmpty => chars < 150;
}

class DocumentDetail extends DocumentSummary {
  DocumentDetail(super.json);

  List<PageInfo> get pages => [for (final m in _maps(json['pages'])) PageInfo(m)];
}

/// Une question de la banque, vue par le propriétaire du document (relecture).
class BankQuestion {
  BankQuestion(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  int get pageId => _int(json['page_id']);
  String get prompt => _str(json['prompt']);
  List<String> get options => (json['options'] as List? ?? const []).map((e) => '$e').toList();
  int get answer => _int(json['answer']);
  String get explain => _str(json['explain']);
  String get quote => _str(json['quote']);

  /// `ai`, `offline`, `manual`.
  String get source => _str(json['source']);

  /// `proposed`, `validated`.
  String get state => _str(json['state']);
  bool get validated => state == 'validated';
  int get timesPlayed => _int(json['times_played']);
}

/// Le texte d'une page.
class PageText {
  PageText(this.json);

  final Map<String, dynamic> json;

  int get id => _int(json['id']);
  int get number => _int(json['number']);
  String get label => _str(json['label']);
  String get text => _str(json['text']);
  int get documentId => _int(json['document_id']);
  String get document => _str(json['document']);
  String get unit => _str(json['unit']);
  String get lang => _str(json['lang']);
  int get pageCount => _int(json['page_count']);
}

/// Quota d'IA du joueur.
class AiQuota {
  AiQuota(this.json);

  final Map<String, dynamic> json;

  bool get enabled => json['enabled'] == true;
  int get daily => _int(json['daily']);
  int get freeRemaining => _int(json['free_remaining']);
  int get credits => _int(json['credits']);

  /// `failures` : trop d'échecs de l'IA aujourd'hui.
  String get limited => _str(json['limited']);
}

/// Une page choisie pour un match, telle que l'état du match la décrit.
class PageRef {
  const PageRef(this.id, this.label, this.documentId, this.document);

  final int id;
  final String label;
  final int documentId;
  final String document;

  static List<PageRef> list(Object? v) => [
    for (final m in _maps(v)) PageRef(_int(m['id']), _str(m['label']), _int(m['document_id']), _str(m['document'])),
  ];
}

/// Pages choisies d'un document.
class DocPages {
  const DocPages(this.documentId, this.documentName, this.unit, this.pages);

  final int documentId;
  final String documentName;
  final String unit;
  final List<PageInfo> pages;
}

/// Sélection de pages (d'un ou plusieurs documents) pour un match ou un tournoi.
class PageSelection {
  const PageSelection(this.docs);

  static const empty = PageSelection([]);

  final List<DocPages> docs;

  bool get isEmpty => docs.every((d) => d.pages.isEmpty);
  List<int> get pageIds => [for (final d in docs) for (final p in d.pages) p.id];
  int get readyQuestions => docs.fold(0, (n, d) => n + d.pages.fold(0, (m, p) => m + p.questions.total));
  int get pendingAi => docs.fold(0, (n, d) => n + d.pages.where((p) => p.aiPending).length);

  /// « Titre : p. 3–5, 8 ; Autre : diapo 2 ».
  String label(BuildContext context) {
    final en = Localizations.localeOf(context).languageCode == 'en';
    return [
      for (final d in docs)
        if (d.pages.isNotEmpty) '${d.documentName} : ${unitShort(d.unit, en)} ${ranges(d.pages.map((p) => p.number))}',
    ].join(' ; ');
  }

  /// Remplace les pages par leur état à jour (après préparation des questions).
  PageSelection refreshed(List<PageInfo> fresh) {
    final byId = {for (final p in fresh) p.id: p};
    return PageSelection([
      for (final d in docs) DocPages(d.documentId, d.documentName, d.unit, [for (final p in d.pages) byId[p.id] ?? p]),
    ]);
  }
}

String unitShort(String unit, bool en) => switch (unit) {
  'slide' => en ? 'slide' : 'diapo',
  'sheet' => en ? 'sheet' : 'feuille',
  'part' => en ? 'part' : 'partie',
  _ => 'p.',
};

/// « 1–3, 5, 8–9 ».
String ranges(Iterable<int> numbers) {
  final sorted = numbers.toSet().toList()..sort();
  final out = <String>[];
  var i = 0;
  while (i < sorted.length) {
    var j = i;
    while (j + 1 < sorted.length && sorted[j + 1] == sorted[j] + 1) {
      j++;
    }
    out.add(i == j ? '${sorted[i]}' : '${sorted[i]}–${sorted[j]}');
    i = j + 1;
  }
  return out.join(', ');
}
