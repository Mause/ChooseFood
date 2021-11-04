import 'package:choose_food/main.dart' show MyApp;
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, find, setUp, tearDown, testWidgets;
import 'package:get/get.dart' show Get, Inst;
import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;
import 'package:nock/nock.dart' show nock;
import 'package:supabase/supabase.dart' show SupabaseClient;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  setUp(() {
    nock.init();
  });
  tearDown(() {
    nock.cleanAll();
  });

  testWidgets('screenshot', (WidgetTester tester) async {
    await Get.deleteAll(force: true);
    Get.put(SupabaseClient("https://dummy", "dummy"), permanent: true);

    nock("https://dummy")
        .get("/rest/v1/session?select=id%2Cdecision%28decision%29")
        .reply(200, [
      {
        "id": "0000-00000-00000-00000",
        "decision": [
          {"decision": true},
          {"decision": false}
        ]
      }
    ]);

    // Build the app.
    await tester.pumpWidget(const MyApp());

    await binding.convertFlutterSurfaceToImage();

    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Friends sessions"));

    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-friends');
  });
}
