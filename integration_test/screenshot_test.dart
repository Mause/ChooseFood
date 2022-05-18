import 'dart:async';

import 'package:choose_food/components/friends_sessions.dart';
import 'package:choose_food/main.dart' show MyApp;
import 'package:flutter_test/flutter_test.dart'
    show
        WidgetTester,
        expect,
        find,
        findsOneWidget,
        setUp,
        setUpAll,
        tearDown,
        testWidgets;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;
import 'package:logger/logger.dart' show Logger;
import 'package:network_image_mock/src/network_image_mock.dart' show image;
import 'package:nock/nock.dart' show nock;
import 'package:supabase_flutter/supabase_flutter.dart'
    show Session, Supabase, SupabaseClient;

import '../test/geolocator_platform.dart' show MockGeolocatorPlatform;
import '../test/widget_test.dart' show accessToken;

var log = Logger();

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    Supabase.initialize(url: "https://supabase", anonKey: "");
    Supabase.instance.client.auth.currentSession =
        Session(accessToken: accessToken());
  });

  setUp(() {
    nock.init();
  });
  tearDown(() {
    nock.cleanAll();
  });

  testWidgets('screenshot', (WidgetTester tester) async {
    await Get.deleteAll(force: true);
    var supabaseClient = SupabaseClient("https://supabase", "dummy");
    supabaseClient.auth.setAuth(accessToken());
    Get.put(supabaseClient, permanent: true);
    GeolocatorPlatform.instance = MockGeolocatorPlatform();

    var sessionId = "0000-00000-00000-00000";
    var supabaseScope = nock("https://supabase");
    supabaseScope
        .get("/rest/v1/session?select=%2A&concludedTime=is.null")
        .reply(200, []);
    supabaseScope
        .get(
            "/rest/v1/session?select=id%2Cdecision%28decision%2CplaceReference%2CparticipantId%29&concludedTime=is.null")
        .reply(200, [
      {
        "id": "0000-00000-00000-00000",
        "decision": [
          {"decision": true},
          {"decision": false}
        ]
      }
    ]);
    supabaseScope.post("/rest/v1/session", {
      "point": {
        "type": "Point",
        "coordinates": [115.8577778, -31.9509882]
      }
    }).reply(200, [
      {
        "id": sessionId,
      }
    ]);
    var mapsScope = nock("https://maps.googleapis.com");
    mapsScope
        .get(
            "/maps/api/place/nearbysearch/json?location=115.8577778%2C-31.9509882&type=restaurant&radius=3000&key")
        .reply(200, {
      'status': 'OK',
      'results': [
        {
          "reference": "1",
          'place_id': '1',
          "photos": [
            {"width": 200, "photo_reference": "1", "height": 200}
          ],
          "name": "Park Center",
        }
      ]
    });
    mapsScope
        .get("/maps/api/place/photo?photoreference=1&maxwidth=411&key")
        .reply(200, image, headers: {"Content-Type": "image/png"});
    supabaseScope.post("/rest/v1/participant",
        {"sessionId": sessionId, "userId": "id"}).reply(200, [{}]);

    // Build the app.
    await tester.pumpWidget(const MyApp());
    await binding.convertFlutterSurfaceToImage();
    await pumpAndSettle(tester, "Inited app");

    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Get places"));
    await pumpAndSettle(tester, "Tapped Get places");
    await binding.takeScreenshot('screenshot-get-places');

    await tester.tap(find.text("Friends sessions"));
    await pumpAndSettle(tester, "tapped Friends sessions");
    await binding.takeScreenshot('screenshot-friends');

    expect(find.byType(SessionCard), findsOneWidget);
    await binding.takeScreenshot('screenshot-friends');
  });
}

Future<void> pumpAndSettle(WidgetTester tester, String message) async {
  await timeout(tester.pumpAndSettle(), message);
}

Future<T> timeout<T>(Future<T> future, String message) async {
  return await future.timeout(const Duration(seconds: 30), onTimeout: () {
    var e = TimeoutException(message);
    log.e("Timed out on: \"$message\"", e);
    throw e;
  });
}
