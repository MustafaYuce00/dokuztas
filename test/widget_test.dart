// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dokuztas/main.dart';

void main() {
  testWidgets('Dokuz Taş home screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DokuzTasApp());

    // Verify that the home screen loads with correct initial state
    expect(find.text('DOKUZ TAŞ'), findsOneWidget);
    expect(find.text('OYNA'), findsOneWidget);
    expect(find.text('NASIL OYNANIR?'), findsOneWidget);

    // Verify that the play button exists
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    
    // Verify that the help button exists
    expect(find.byIcon(Icons.help_outline), findsOneWidget);
  });

  testWidgets('Navigation to game screen works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DokuzTasApp());

    // Tap the play button
    await tester.tap(find.text('OYNA'));
    await tester.pumpAndSettle();
    
    // Verify that we navigated to the game screen
    expect(find.text('Dokuz Taş'), findsOneWidget);
    expect(find.text('Red Player\'s Turn'), findsOneWidget);
  });
}
