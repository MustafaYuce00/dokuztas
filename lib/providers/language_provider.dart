import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('tr', 'TR'); // Varsayılan Türkçe

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadLanguage();
  }

  // Dil değiştirme
  void changeLanguage(Locale locale) async {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      notifyListeners();
      
      // Tercihi kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);
      await prefs.setString('country_code', locale.countryCode ?? '');
    }
  }

  // Kaydedilen dili yükle
  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');
    final countryCode = prefs.getString('country_code');
    
    if (languageCode != null) {
      _currentLocale = Locale(languageCode, countryCode);
      notifyListeners();
    }
  }

  // Dil listesi
  List<Locale> get supportedLocales => const [
    Locale('tr', 'TR'),
    Locale('en', 'US'),
  ];

  // Dil adları
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return 'Türkçe';
    }
  }
}
