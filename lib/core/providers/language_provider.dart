import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _boxName = 'settingsBox';
  static const String _langKey = 'selectedLanguage';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final box = await Hive.openBox(_boxName);
    final String? langCode = box.get(_langKey);
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  Future<void> setLanguage(String langCode) async {
    if (_locale.languageCode == langCode) return;

    _locale = Locale(langCode);
    notifyListeners();

    final box = await Hive.openBox(_boxName);
    await box.put(_langKey, langCode);
  }
}
