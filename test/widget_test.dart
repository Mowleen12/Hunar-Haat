import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hunar_haat_genai/main.dart';

void main() {
  testWidgets('App launches and shows initial screen', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Wait for any async initialization (e.g. FutureBuilder, Provider, etc.)
    await tester.pumpAndSettle();

    // Verify that the app launched without crashing
    expect(find.byType(MyApp), findsOneWidget);

    // Optional: Check for a known widget in your app
    // Example: If your app has an AppBar with title "Hunar Haat"
    // expect(find.text('Hunar Haat'), findsOneWidget);

    // Or if you have a home screen with a specific widget:
    // expect(find.byType(HomeScreen), findsOneWidget);

    // Or if you have a loading indicator initially:
    // expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}