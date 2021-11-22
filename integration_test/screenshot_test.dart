import 'dart:async' show Future, TimeoutException;

import 'package:choose_food/main.dart' show MyApp;
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart' show findsOneWidget;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:integration_test/integration_test.dart'
    show IntegrationTestWidgetsFlutterBinding;
import 'package:logger/logger.dart' show Logger;
import 'package:network_image_mock/src/network_image_mock.dart' show image;
import 'package:nock/nock.dart' show nock;
import 'package:supabase/supabase.dart' show SupabaseClient;
import 'package:test/test.dart' show Timeout, expect, setUp, tearDown, test;

import '../test/geolocator_platform.dart' show MockGeolocatorPlatform;
import '../test/widget_test.dart' show accessToken;

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

  test('screenshot', () async {
    var tester = await FlutterDriver.connect();

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
        {"sessionId": sessionId, "userId": "id"}).reply(200, {});

    // Build the app.
    binding.attachRootWidget(const MyApp());
    await binding.pump();
    await binding.convertFlutterSurfaceToImage();
    await binding.pump();

    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Get places"));
    await binding.pump();
    await binding.takeScreenshot('screenshot-get-places');

    await tester.tap(find.text("Friends sessions"));
    await binding.pump();
    await binding.takeScreenshot('screenshot-friends');

    expect(find.byType("SessionCard"), findsOneWidget);
    await binding.takeScreenshot('screenshot-friends');
  }, timeout: const Timeout(Duration(seconds: 130)));
}

Future<T> timeout<T>(Future<T> future, String message) async {
  return await future.timeout(const Duration(seconds: 30), onTimeout: () {
    var e = TimeoutException(message);
    log.e("Timed out on: \"$message\"", e);
    throw e;
  });
}
