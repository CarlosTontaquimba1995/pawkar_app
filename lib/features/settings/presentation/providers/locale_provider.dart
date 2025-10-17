import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'locale';
  Locale? _locale;
  final SharedPreferences _prefs;

  LocaleProvider(this._prefs);

  Locale? get locale => _locale;

  Future<void> initialize() async {
    final localeCode = _prefs.getString(_localeKey);
    if (localeCode != null) {
      _locale = Locale(localeCode);
    } else {
      _locale = const Locale('es');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!const {'es'}.contains(locale.languageCode)) return;
    
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    _prefs.remove(_localeKey);
    notifyListeners();
  }
}
