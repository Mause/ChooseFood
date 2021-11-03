// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart' show ElevatedButton, ListView;
import 'package:logger/logger.dart' show Logger;
import 'package:test/test.dart' show group, test;

import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;

var log = Logger();

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;

  group('ChooseFood', () {
    test('Screenshot', () async {
//    await tester.tap(find.widgetWithText(ElevatedButton, 'Get places'));
//    await tester.pump();

//    expect(find.byType(ListView), findsOneWidget);

      log.i("converting");
      await binding.convertFlutterSurfaceToImage();
      log.i("converted");

      log.i("screenshot");
      await binding.callbackManager.takeScreenshot('screenshot');
      log.i("screenshot");
    });
  });
}
