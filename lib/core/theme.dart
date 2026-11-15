import 'package:flutter/material.dart';

/// Couleurs de marque : vert forêt (la pousse, l'école), or (le buzzer, la
/// victoire), papier (lecture). Ce sont des couleurs de **marque**, pas de
/// texte : un écran n'emploie jamais ces constantes pour colorer un texte ou
/// une icône, mais la [GeniePalette] du thème, lisible en clair ET en sombre.
abstract final class GenieColors {
  static const forest = Color(0xFF2E6B30);
  static const gold = Color(0xFFC9A227);
  static const paper = Color(0xFFF7F9F3);
  static const ink = Color(0xFF1E261F);

  // Fonds du mode sombre.
  static const darkSurface = Color(0xFF131813);
  static const darkCard = Color(0xFF1C231C);
}

/// Couleurs sémantiques de l'application, déclinées pour chaque luminosité.
///
/// Chaque couple texte/fond est vérifié par test/theme_contrast_test.dart
/// (WCAG : 4,5:1 pour un texte, 3:1 pour une icône ou un grand texte).
@immutable
class GeniePalette extends ThemeExtension<GeniePalette> {
  const GeniePalette({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.error,
    required this.errorContainer,
    required this.accentText,
    required this.accentIcon,
    required this.brandIcon,
    required this.heroBackground,
    required this.heroForeground,
    required this.heroMuted,
    required this.heroAccent,
    required this.heroButton,
    required this.onHeroButton,
    required this.highlight,
    required this.card,
  });

  /// Bonne réponse, élément terminé (texte, icône, bordure).
  final Color success;

  /// Fond d'une proposition juste / pastille « terminé ».
  final Color successContainer;
  final Color onSuccessContainer;

  /// Mauvaise réponse, action destructrice.
  final Color error;
  final Color errorContainer;

  /// L'or quand il porte un texte.
  final Color accentText;

  /// L'or pour une icône (victoire, statistiques).
  final Color accentIcon;

  /// Icône de marque sur une carte (le vert forêt en clair, un vert clair en sombre).
  final Color brandIcon;

  /// Carte mise en avant (accueil).
  final Color heroBackground;
  final Color heroForeground;
  final Color heroMuted;
  final Color heroAccent;
  final Color heroButton;
  final Color onHeroButton;

  /// Surlignage d'un passage (citation qui justifie une réponse).
  final Color highlight;

  /// Fond des cartes (repris par le thème des Card).
  final Color card;

  static const light = GeniePalette(
    success: Color(0xFF2E6B2A),
    successContainer: Color(0xFFE3F0E1),
    onSuccessContainer: Color(0xFF1B4419),
    error: Color(0xFFA12B2B),
    errorContainer: Color(0xFFF8E3E3),
    accentText: Color(0xFF7A5F00),
    accentIcon: Color(0xFFA27F0E),
    brandIcon: GenieColors.forest,
    heroBackground: GenieColors.forest,
    heroForeground: Colors.white,
    heroMuted: Color(0xFFD3E6CF),
    heroAccent: Color(0xFFE8CB6A),
    heroButton: GenieColors.gold,
    onHeroButton: GenieColors.ink,
    highlight: Color(0x40C9A227),
    card: Colors.white,
  );

  static const dark = GeniePalette(
    success: Color(0xFF8BCF88),
    successContainer: Color(0xFF1F3A21),
    onSuccessContainer: Color(0xFFCDEBCB),
    error: Color(0xFFF29B9B),
    errorContainer: Color(0xFF3D2224),
    accentText: Color(0xFFE8CB6A),
    accentIcon: Color(0xFFE8CB6A),
    brandIcon: Color(0xFF9CD48A),
    heroBackground: Color(0xFF285C2A),
    heroForeground: Colors.white,
    heroMuted: Color(0xFFD5E8D0),
    heroAccent: Color(0xFFF0D683),
    heroButton: Color(0xFFE8CB6A),
    onHeroButton: GenieColors.ink,
    highlight: Color(0x55E8CB6A),
    card: GenieColors.darkCard,
  );

  @override
  GeniePalette copyWith() => this;

  @override
  GeniePalette lerp(GeniePalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return GeniePalette(
      success: l(success, other.success),
      successContainer: l(successContainer, other.successContainer),
      onSuccessContainer: l(onSuccessContainer, other.onSuccessContainer),
      error: l(error, other.error),
      errorContainer: l(errorContainer, other.errorContainer),
      accentText: l(accentText, other.accentText),
      accentIcon: l(accentIcon, other.accentIcon),
      brandIcon: l(brandIcon, other.brandIcon),
      heroBackground: l(heroBackground, other.heroBackground),
      heroForeground: l(heroForeground, other.heroForeground),
      heroMuted: l(heroMuted, other.heroMuted),
      heroAccent: l(heroAccent, other.heroAccent),
      heroButton: l(heroButton, other.heroButton),
      onHeroButton: l(onHeroButton, other.onHeroButton),
      highlight: l(highlight, other.highlight),
      card: l(card, other.card),
    );
  }
}

extension PaletteX on BuildContext {
  GeniePalette get palette => Theme.of(this).extension<GeniePalette>()!;
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final palette = dark ? GeniePalette.dark : GeniePalette.light;
  final scheme = ColorScheme.fromSeed(
    seedColor: GenieColors.forest,
    brightness: brightness,
    primary: dark ? const Color(0xFF9CD48A) : GenieColors.forest,
    onPrimary: dark ? const Color(0xFF0F2A10) : Colors.white,
    secondary: dark ? palette.accentText : GenieColors.gold,
    error: palette.error,
    surface: dark ? GenieColors.darkSurface : GenieColors.paper,
    onSurface: dark ? const Color(0xFFE6E8EC) : GenieColors.ink,
    onSurfaceVariant: dark ? const Color(0xFFB9BFC9) : const Color(0xFF4F5663),
    outline: dark ? const Color(0xFF8A93A0) : const Color(0xFF747B86),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    extensions: [palette],
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(backgroundColor: scheme.surface, foregroundColor: scheme.onSurface, centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 0,
      color: palette.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: dark ? 0.9 : 0.6)),
      ),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}

/// Style d'un texte à lire (une page de document) à la taille choisie.
TextStyle readingStyle(BuildContext context, [double scale = 1]) {
  final base = Theme.of(context).textTheme.bodyLarge!;
  return base.copyWith(fontSize: 17 * scale, height: 1.55);
}
