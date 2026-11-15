import 'package:flutter_test/flutter_test.dart';
import 'package:genie_en_herbe/engine/text_tools.dart';

void main() {
  test('Un titre n’est pas collé à la phrase suivante', () {
    final s = splitSentences("L'empire du Mali\nL'empire fut fondé vers 1235. Il dura longtemps.");
    expect(s.map((x) => x.text).toList(), ["L'empire du Mali", "L'empire fut fondé vers 1235.", 'Il dura longtemps.']);
    expect(splitSentences('Le fleuve traverse\nle Mali.').length, 1);
  });
}
