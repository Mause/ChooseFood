import 'dart:io'
    show HttpClient, HttpClientRequest, HttpClientResponse, HttpOverrides;

import 'package:choose_food/components/friends_sessions.dart';
import 'package:choose_food/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase/supabase.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

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

    var myHomePageState =
        tester.state(find.byType(FriendsSessions)) as FriendsSessionsState;
    myHomePageState.supabaseClient = SupabaseClient("https://dummy", "dummy");

    var mockHttpClient = MockHttpClient();
    var mockHttpClientRequest = MockHttpClientRequest();
    throwOnMissingStub(mockHttpClient);
    throwOnMissingStub(mockHttpClientRequest);
    when(mockHttpClientRequest.done)
        .thenReturn(Future.value(MockHttpClientResponse()));
    when(mockHttpClient.get("dummy", 443, "/rest/v1/session?select=%2A"))
        .thenAnswer((_) => Future.value(mockHttpClientRequest));

    await HttpOverrides.runZoned(() => tester.pumpAndSettle(),
        createHttpClient: (_) => mockHttpClient);
    await binding.takeScreenshot('screenshot-friends');
  });
}
