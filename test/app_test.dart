import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genie_en_herbe/app.dart';
import 'package:genie_en_herbe/online/online_providers.dart';
import 'package:genie_en_herbe/online/service.dart';
import 'package:genie_en_herbe/ui/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Sans compte : l’accueil explique comment entrer', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(ProviderScope(
      overrides: [
        onlineServiceProvider.overrideWithValue(OnlineService(server: 'http://test.invalid', tokens: MemoryTokenStore())),
      ],
      child: const GenieApp(),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget); // téléphone de test en anglais
    expect(find.text('Génie en herbe'), findsWidgets);
  });
}
