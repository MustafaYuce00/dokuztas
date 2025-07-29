import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DokuzTasApp());
}

class DokuzTasApp extends StatelessWidget {
  const DokuzTasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dokuz Taş',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
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