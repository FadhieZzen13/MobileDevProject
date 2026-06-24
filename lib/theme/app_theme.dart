import 'package:flutter/material.dart';

/// Central design system for the app.
///
/// Colour roles encode meaning (see design/ui_blueprint.html):
///   * RED  = wayfinding   -> ColorScheme.primary / primaryContainer
///   * GREEN = sustainability -> ColorScheme.secondary / secondaryContainer
/// Neutrals are warm-tinted toward the brand hue; never pure #fff / #000.
///
/// Screens must read colours from `Theme.of(context).colorScheme`, never
/// hard-code hex values, so light and dark stay consistent.
class AppTheme {
  AppTheme._();

  // ---- Light palette ------------------------------------------------------
  static const _bgL = Color(0xFFFBFAF8);
  static const _surfaceL = Color(0xFFFFFFFF);
  static const _surface2L = Color(0xFFF4F1EC);
  static const _inkL = Color(0xFF2A2622);
  static const _mutedL = Color(0xFF78716A);
  static const _faintL = Color(0xFFA8A29B);
  static const _borderL = Color(0xFFECE8E2);
  static const _redL = Color(0xFFD23B2E);
  static const _redTintL = Color(0xFFFBEAE7);
  static const _redInkL = Color(0xFF8C231B);
  static const _greenL = Color(0xFF3FA06B);
  static const _greenTintL = Color(0xFFE8F4EC);
  static const _greenInkL = Color(0xFF1F6B43);

  // ---- Dark palette -------------------------------------------------------
  static const _bgD = Color(0xFF1A1714);
  static const _surfaceD = Color(0xFF232019);
  static const _surface2D = Color(0xFF2C2823);
  static const _inkD = Color(0xFFF2EEE8);
  static const _mutedD = Color(0xFFB0A79F);
  static const _faintD = Color(0xFF7A736C);
  static const _borderD = Color(0xFF38332D);
  static const _redD = Color(0xFFE86B5E);
  static const _redTintD = Color(0xFF3A211C);
  static const _redInkD = Color(0xFFF2C6BE);
  static const _greenD = Color(0xFF6FBF92);
  static const _greenTintD = Color(0xFF1E3329);
  static const _greenInkD = Color(0xFFBFE6CE);

  static ThemeData get light => _build(
        brightness: Brightness.light,
        bg: _bgL,
        surface: _surfaceL,
        surface2: _surface2L,
        ink: _inkL,
        muted: _mutedL,
        faint: _faintL,
        border: _borderL,
        red: _redL,
        redTint: _redTintL,
        redInk: _redInkL,
        green: _greenL,
        greenTint: _greenTintL,
        greenInk: _greenInkL,
        onAccent: Colors.white,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        bg: _bgD,
        surface: _surfaceD,
        surface2: _surface2D,
        ink: _inkD,
        muted: _mutedD,
        faint: _faintD,
        border: _borderD,
        red: _redD,
        redTint: _redTintD,
        redInk: _redInkD,
        green: _greenD,
        greenTint: _greenTintD,
        greenInk: _greenInkD,
        onAccent: const Color(0xFF1A1714),
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color surface,
    required Color surface2,
    required Color ink,
    required Color muted,
    required Color faint,
    required Color border,
    required Color red,
    required Color redTint,
    required Color redInk,
    required Color green,
    required Color greenTint,
    required Color greenInk,
    required Color onAccent,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: red,
      onPrimary: onAccent,
      primaryContainer: redTint,
      onPrimaryContainer: redInk,
      secondary: green,
      onSecondary: onAccent,
      secondaryContainer: greenTint,
      onSecondaryContainer: greenInk,
      tertiary: green,
      onTertiary: onAccent,
      tertiaryContainer: greenTint,
      onTertiaryContainer: greenInk,
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: muted,
      outline: faint,
      outlineVariant: border,
      surfaceContainerHighest: surface2,
      surfaceContainerHigh: surface2,
      surfaceContainer: surface2,
    );

    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      cardColor: surface,
      dividerColor: border,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      textTheme: base.textTheme.copyWith(
        headlineMedium: base.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          color: ink,
        ),
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: ink,
        ),
        titleLarge: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
    );
  }
}
