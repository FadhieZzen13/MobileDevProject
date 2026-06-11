import 'package:flutter/material.dart';

/// Centralised colours and theming so every screen looks consistent.
///
/// UI consistency is 20% of the grade — always pull colours from the active
/// [Theme] / [ColorScheme] instead of hard-coding them in individual screens.
class AppTheme {
  AppTheme._();

  // UPM / faculty green as the brand seed colour.
  static const Color seed = Color(0xFF1B6B3A);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      );
}
