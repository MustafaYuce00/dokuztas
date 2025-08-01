import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('tr', 'TR'), // Türkçe
    Locale('en', 'US'), // İngilizce
  ];

  // Ana Sayfa
  String get appTitle => locale.languageCode == 'tr' ? 'Dokuz Taş' : 'Nine Men\'s Morris';
  String get playGame => locale.languageCode == 'tr' ? 'Oyuna Başla' : 'Start Game';
  String get settings => locale.languageCode == 'tr' ? 'Ayarlar' : 'Settings';
  String get about => locale.languageCode == 'tr' ? 'Hakkında' : 'About';
  String get language => locale.languageCode == 'tr' ? 'Dil' : 'Language';
  String get turkish => locale.languageCode == 'tr' ? 'Türkçe' : 'Turkish';
  String get english => locale.languageCode == 'tr' ? 'İngilizce' : 'English';
  String get howToPlay => locale.languageCode == 'tr' ? 'NASIL OYNANIR?' : 'HOW TO PLAY?';
  String get strategyGame => locale.languageCode == 'tr' ? 'İki oyuncu için strateji oyunu' : 'Strategy game for two players';
  
  // Nasıl Oynanır Ekranı
  String get gameObjective => locale.languageCode == 'tr' ? 'AMAÇ' : 'OBJECTIVE';
  String get gameObjectiveDesc => locale.languageCode == 'tr' 
    ? 'Taşlarınızı aynı satır, sütun veya çapraz çizgi üzerinde üç tane yan yana getirerek rakibinizi yenin!' 
    : 'Defeat your opponent by getting three of your stones in a row, column, or diagonal line!';
  String get gamePhases => locale.languageCode == 'tr' ? 'OYUN AŞAMALARI' : 'GAME PHASES';
  String get gamePhasesDesc => locale.languageCode == 'tr'
    ? '1. YERLEŞTIRME AŞAMASI: Her oyuncu sırayla 3 taşını tahta üzerine yerleştirir.\n\n2. HAREKET AŞAMASI: Tüm taşlar yerleştirildikten sonra, oyuncular taşlarını bağlantılı noktalara hareket ettirebilir.'
    : '1. PLACEMENT PHASE: Each player takes turns placing their 3 stones on the board.\n\n2. MOVEMENT PHASE: After all stones are placed, players can move their stones to connected points.';
  String get winning => locale.languageCode == 'tr' ? 'KAZANMA' : 'WINNING';
  String get winningDesc => locale.languageCode == 'tr'
    ? 'Taşlarınızdan üçünü aynı çizgi üzerinde yan yana getirdiğinizde oyunu kazanırsınız!'
    : 'You win the game when you get three of your stones in a line!';
  String get tips => locale.languageCode == 'tr' ? 'İPUÇLARI' : 'TIPS';
  String get tipsDesc => locale.languageCode == 'tr'
    ? '• Merkez noktayı kontrol etmeye çalışın\n• Rakibinizin üçlü yapmasını engelleyin\n• Birden fazla kazanma şansı yaratın'
    : '• Try to control the center point\n• Block your opponent from making three in a row\n• Create multiple winning opportunities';
  String get players => locale.languageCode == 'tr' ? 'OYUNCULAR' : 'PLAYERS';
  String get firstPlayer => locale.languageCode == 'tr' ? 'İlk Oyuncu' : 'First Player';
  String get secondPlayer => locale.languageCode == 'tr' ? 'İkinci Oyuncu' : 'Second Player';
  String get understoodLetsPlay => locale.languageCode == 'tr' ? 'ANLADIM, OYNAYALIM!' : 'GOT IT, LET\'S PLAY!';

  // Oyun Sayfası
  String get redPlayer => locale.languageCode == 'tr' ? 'KIRMIZI' : 'RED';
  String get bluePlayer => locale.languageCode == 'tr' ? 'MAVİ' : 'BLUE';
  String get playerTurn => locale.languageCode == 'tr' ? 'OYUNCUNUN SIRASI' : 'PLAYER\'S TURN';
  String get placingPhase => locale.languageCode == 'tr' ? 'TAŞ YERLEŞTIRME' : 'PLACING STONES';
  String get movingPhase => locale.languageCode == 'tr' ? 'TAŞ TAŞIMA' : 'MOVING STONES';
  
  // Kazanma Ekranı
  String get playerWins => locale.languageCode == 'tr' ? 'KAZANDI!' : 'WINS!';
  String get playAgain => locale.languageCode == 'tr' ? 'Tekrar Oyna' : 'Play Again';
  String get backToHome => locale.languageCode == 'tr' ? 'Ana Sayfaya Dön' : 'Back to Home';
  String get congratulations => locale.languageCode == 'tr' ? 'Tebrikler!' : 'Congratulations!';
  String get scoreStatus => locale.languageCode == 'tr' ? 'SKOR DURUMU' : 'SCORE STATUS';
  
  // Genel
  String get back => locale.languageCode == 'tr' ? 'Geri' : 'Back';
  String get close => locale.languageCode == 'tr' ? 'Kapat' : 'Close';
  String get ok => locale.languageCode == 'tr' ? 'Tamam' : 'OK';
  String get cancel => locale.languageCode == 'tr' ? 'İptal' : 'Cancel';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
