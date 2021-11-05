import 'package:choose_food/main.dart' show MyApp;
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, find, setUp, tearDown, testWidgets;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;
import 'package:logger/logger.dart' show Logger;
import 'package:nock/nock.dart' show nock;
import 'package:supabase/supabase.dart' show SupabaseClient;

var log = Logger();

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
    GeolocatorPlatform.instance = MockGeolocatorPlatform();

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

class MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.always);

  @override
  Future<Position> getCurrentPosition(
          {LocationAccuracy desiredAccuracy = LocationAccuracy.best,
          bool forceAndroidLocationManager = false,
          Duration? timeLimit}) =>
      Future.value(Position(
          longitude: -31.9509882,
          latitude: 115.8577778,
          timestamp: DateTime(2021, 1, 1),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0));
}
