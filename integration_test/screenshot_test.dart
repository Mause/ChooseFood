import 'dart:io' show HttpClient, HttpClientRequest, HttpOverrides;

import 'package:choose_food/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets('screenshot', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const MyApp());

    await binding.convertFlutterSurfaceToImage();

    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Friends sessions"));

    var mockHttpClient = MockHttpClient();
    when(mockHttpClient.get("", 443, "/rest/v1/session?select=%2A"))
        .thenAnswer((realInvocation) => Future.value(MockHttpClientRequest()));

    await HttpOverrides.runZoned(() => tester.pumpAndSettle(),
        createHttpClient: (_) {
      return mockHttpClient;
    });
    await binding.takeScreenshot('screenshot-friends');
  });
}
