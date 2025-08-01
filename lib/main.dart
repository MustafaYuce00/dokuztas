import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'localization/app_localizations.dart';
import 'providers/language_provider.dart';

void main() {
  runApp(const DokuzTasApp());
}

class DokuzTasApp extends StatelessWidget {
  const DokuzTasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'Dokuz Taş',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              useMaterial3: true,
            ),
            locale: languageProvider.currentLocale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
/*
dil değitrime gelebilir türkçe ingilizce vs
ve yeni bir isim eklenebilir
zorluk seviyeleri eklenebilir


 
 taşlara ve belki süre eklene bilir sürebitince,
rastgele oynama veya karşı rakibe geçme vsgelebilir
olmasa da oolur 
*/