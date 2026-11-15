import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genie_en_herbe/l10n/gen/app_localizations.dart';

void main() {
  test('Zéro n’est pas « 1 » en français', () async {
    final fr = await AppLocalizations.delegate.load(const Locale('fr'));
    expect(fr.questionsCount(0), 'aucune question');
    expect(fr.questionsCount(1), '1 question');
    expect(fr.questionsCount(3), '3 questions');
    expect(fr.docUnits(2, 'slide'), '2 diapositives');
  });
}
