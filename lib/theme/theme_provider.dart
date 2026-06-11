import 'package:flutter/material.dart';

/// Holds the current light/dark preference and notifies listeners on change.
///
/// Wired up in [main] with `provider`; the home screen toggles it. This is the
/// foundation for the optional "Dark mode" bonus feature.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
