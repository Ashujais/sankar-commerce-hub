import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Provider managing active application theme (Light / Dark) with local persistence.
class ThemeProvider with ChangeNotifier {
  final StorageService _storageService = StorageService.instance;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Loads saved theme mode on startup.
  Future<void> loadTheme() async {
    try {
      final savedMode = await _storageService.getThemeMode();
      if (savedMode == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
      notifyListeners();
    } catch (_) {
      _themeMode = ThemeMode.light;
    }
  }

  /// Toggles between light and dark themes.
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
      await _storageService.saveThemeMode('dark');
    } else {
      _themeMode = ThemeMode.light;
      await _storageService.saveThemeMode('light');
    }
    notifyListeners();
  }

  /// Sets specific theme mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storageService.saveThemeMode(mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}
