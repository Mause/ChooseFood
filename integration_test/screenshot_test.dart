import 'dart:io';

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

    var packageName = "me.mause.choosefood";
    await grant(packageName, 'android.permission.READ_EXTERNAL_STORAGE');
    await grant(packageName, 'android.permission.READ_PHONE_STATE');
    await grant(packageName, 'android.permission.ACCESS_FINE_LOCATION');
    await grant(packageName, 'android.permission.ACCESS_COARSE_LOCATION');

    var nockScope = nock("https://dummy");
    nockScope
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
    nockScope.post("/rest/v1/session", {}).reply(200, [
      {
        "id": "0000-00000-00000-00000",
      }
    ]);
    nock("https://maps.googleapis.com")
        .get(
            "/maps/api/place/nearbysearch/json?location=-31.9925197%2C115.8909208&type=restaurant&radius=3000&key")
        .reply(200, {});

    // Build the app.
    await tester.pumpWidget(const MyApp());
    await binding.convertFlutterSurfaceToImage();

    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Get places"));

    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-get-places');

    await tester.tap(find.text("Friends sessions"));

    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-friends');
  });
}

Future<void> grant(String packageName, String permission) async {
  // var path = await Process.run("C:\\Windows\\System32\\where.exe", ["adb"], runInShell: true);
  await Process.run("adb", ['shell', 'pm', 'grant', packageName, permission],
      runInShell: true);
}
