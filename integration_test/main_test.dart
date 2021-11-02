// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

// import 'package:flutter/material.dart' show ElevatedButton, ListView;
import 'package:flutter_test/flutter_test.dart' show testWidgets;

import 'package:choose_food/main.dart' show MyApp;
import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;

  testWidgets('Places load', (tester) async {
    tester.printToConsole("pumping");
    await tester.pumpWidget(const MyApp());
    tester.printToConsole("pumped");

//    await tester.tap(find.widgetWithText(ElevatedButton, 'Get places'));
//    await tester.pump();

//    expect(find.byType(ListView), findsOneWidget);

    tester.printToConsole("converting");
    await binding.convertFlutterSurfaceToImage();
    tester.printToConsole("converted");

    await binding.takeScreenshot('screenshot-$Platform.operatingSystem');
    tester.printToConsole("screenshot");
  });
}
