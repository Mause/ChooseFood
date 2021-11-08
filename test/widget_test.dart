// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:nock/nock.dart';
import 'package:supabase/supabase.dart' as supabase;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:choose_food/main.dart';
import 'package:mockito/annotations.dart' show GenerateMocks;
import 'package:mockito/mockito.dart' show throwOnMissingStub;
import 'package:network_image_mock/network_image_mock.dart'
    show mockNetworkImagesFor;
import 'geolocator_platform.dart' show MockGeolocatorPlatform;

import './widget_test.mocks.dart';

@GenerateMocks([
  http.Client,
  supabase.SupabaseClient,
  supabase.SupabaseQueryBuilder,
  supabase.PostgrestBuilder,
])
void main() {
  setUp(() {
    nock.init();
  });
  tearDown(() {
    nock.cleanAll();
  });

  testWidgets('Places load', (tester) async {
    var mockSupabaseClient = MockSupabaseClient();
    throwOnMissingStub(mockSupabaseClient);
    var supabaseScope = nock("https://supabase");
    supabaseScope
        .get("/rest/v1/session?select=%2A&concludedTime=is.null")
        .reply(200, []);
    supabaseScope.post("/rest/v1/session", {
      "point": {
        "type": "Point",
        "coordinates": [115.8577778, -31.9509882]
      }
    }).reply(200, [
      {
        "id": "0000-00000-00000-00000",
      }
    ]);

    nock("https://maps.googleapis.com")
        .get(
            "/maps/api/place/nearbysearch/json?location=115.8577778%2C-31.9509882&type=restaurant&radius=3000&key")
        .reply(200, {
      "results": [
        {
          "reference": "1",
          "name": "Place",
          "place_id": "pid",
          "photos": [
            {"photo_reference": "1", "width": 1, "height": 1}
          ]
        }
      ],
      "status": "OK"
    });

    Get.deleteAll();
    geolocator.GeolocatorPlatform.instance = MockGeolocatorPlatform();
    Get.put(supabase.SupabaseClient("https://supabase", ""));

    await tester.pumpWidget(const MyApp());

    expect(find.byType(Card), findsNothing);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get places'));
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byType(Card), findsOneWidget);
  });
}
