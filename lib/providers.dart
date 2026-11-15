import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_update.dart';
import 'online/doc_models.dart';
import 'online/online_providers.dart';
import 'online/page_cache.dart';

/// Vérification des nouvelles versions : null = aucune (tests, iOS, ordinateur).
final appUpdateCheckerProvider = Provider<AppUpdateChecker?>((ref) => null);

/// Web : page de téléchargement de l'application Android à proposer (null = rien).
final webInstallUrlProvider = Provider<Uri?>((ref) => null);

/// Réglages de l'appareil (langue, thème, taille du texte), gardés dans les préférences.
class AppSettings {
  const AppSettings({this.localeCode, this.themeMode = 'system', this.textScale = 1.0});

  /// null = langue du téléphone.
  final String? localeCode;

  /// `system`, `light`, `dark`.
  final String themeMode;

  /// Taille du texte des pages (lecture).
  final double textScale;

  AppSettings copyWith({String? Function()? localeCode, String? themeMode, double? textScale}) => AppSettings(
    localeCode: localeCode == null ? this.localeCode : localeCode(),
    themeMode: themeMode ?? this.themeMode,
    textScale: textScale ?? this.textScale,
  );
}

/// Préférences : remplacé dans les tests par une valeur en mémoire.
final preferencesProvider = FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  static const _locale = 'locale', _theme = 'theme', _scale = 'text_scale';

  @override
  Future<AppSettings> build() async {
    try {
      final p = await ref.watch(preferencesProvider.future);
      return AppSettings(
        localeCode: p.getString(_locale),
        themeMode: p.getString(_theme) ?? 'system',
        textScale: p.getDouble(_scale) ?? 1.0,
      );
    } catch (_) {
      // Préférences illisibles (navigateur en mode privé) : réglages par défaut.
      return const AppSettings();
    }
  }

  Future<void> _save(AppSettings next, Future<void> Function(SharedPreferences p) write) async {
    state = AsyncData(next);
    try {
      await write(await ref.read(preferencesProvider.future));
    } catch (_) {}
  }

  Future<void> setLocale(String? code) => _save(
    (state.value ?? const AppSettings()).copyWith(localeCode: () => code),
    (p) async => code == null ? await p.remove(_locale) : await p.setString(_locale, code),
  );

  Future<void> setTheme(String mode) =>
      _save((state.value ?? const AppSettings()).copyWith(themeMode: mode), (p) => p.setString(_theme, mode));

  Future<void> setTextScale(double scale) =>
      _save((state.value ?? const AppSettings()).copyWith(textScale: scale), (p) => p.setDouble(_scale, scale));
}

/// La bibliothèque du joueur : ses documents et ceux qu'on lui a partagés.
final libraryProvider = FutureProvider.autoDispose<({List<DocumentSummary> mine, List<DocumentSummary> shared})>(
  (ref) => ref.watch(onlineServiceProvider).documents(),
);

/// Fiche d'un document (pages et état de leurs questions).
final documentProvider = FutureProvider.autoDispose.family<DocumentDetail, int>(
  (ref, id) => ref.watch(onlineServiceProvider).document(id),
);

/// Quota et crédits IA du joueur.
final aiQuotaProvider = FutureProvider.autoDispose<AiQuota>((ref) => ref.watch(onlineServiceProvider).aiQuota());

/// Pages gardées sur le téléphone (lecture et entraînement sans réseau).
final pageCacheProvider = Provider<PageCache>((ref) => PageCache());
