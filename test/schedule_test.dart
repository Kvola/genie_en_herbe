import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genie_en_herbe/l10n/gen/app_localizations.dart';
import 'package:genie_en_herbe/ui/online/schedule.dart';

void main() {
  testWidgets('Date d’un match programmé, en français', (tester) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 30);
    final tomorrow = DateTime(now.year, now.month, now.day + 1, 9, 5);
    final later = DateTime(now.year, now.month, now.day + 5, 15, 0);
    late List<String> out;
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(builder: (c) {
        out = [formatSchedule(c, today), formatSchedule(c, tomorrow), formatSchedule(c, later)];
        return const SizedBox();
      }),
    ));
    expect(out[0], 'aujourd’hui à 23:30');
    expect(out[1], 'demain à 09:05');
    expect(out[2], endsWith('à 15:00'));
    expect(out[2], isNot(contains('demain')));
  });
}
