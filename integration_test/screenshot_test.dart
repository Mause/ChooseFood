import 'dart:io'
    show HttpClient, HttpClientRequest, HttpClientResponse, HttpOverrides;

import 'package:choose_food/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase/supabase.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MyHttpOverrides extends HttpOverrides {
  HttpClient httpClient;
  MyHttpOverrides(this.httpClient);
  @override
  HttpClient createHttpClient(SecurityContext? sc) => httpClient;
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets('screenshot', (WidgetTester tester) async {
    await Get.deleteAll(force: true);
    Get.put(SupabaseClient("https://dummy", "dummy"), permanent: true);
    var mockHttpClient = MockHttpClient();
    throwOnMissingStub(mockHttpClient);
    HttpOverrides.global = MyHttpOverrides(mockHttpClient);

    // Build the app.
    await tester.pumpWidget(const MyApp());

    await binding.convertFlutterSurfaceToImage();

    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Friends sessions"));

    var mockHttpClientRequest = MockHttpClientRequest();
    throwOnMissingStub(mockHttpClientRequest);
    var mockHttpClientResponse = MockHttpClientResponse();
    when(mockHttpClientResponse.first).thenReturn(Future.value("[]".codeUnits));
    when(mockHttpClientRequest.done)
        .thenReturn(Future.value(mockHttpClientResponse));
    when(mockHttpClient.get("dummy", 443, "/rest/v1/session?select=%2A"))
        .thenAnswer((_) => Future.value(mockHttpClientRequest));

    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-friends');
  });
}
