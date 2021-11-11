import 'package:choose_food/generated_code/openapi.models.swagger.dart'
    show Users;
import 'package:choose_food/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        WidgetTester,
        expect,
        find,
        findsNothing,
        findsOneWidget,
        setUp,
        tearDown,
        testWidgets;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:network_image_mock/network_image_mock.dart'
    show mockNetworkImagesFor;
import 'package:nock/nock.dart';
import 'package:nock/src/scope.dart';
import 'package:supabase/supabase.dart' as supabase;

import 'geolocator_platform.dart' show MockGeolocatorPlatform;

void main() {
  late NockScope supabaseScope;
  late NockScope mapsScope;

  setUp(() {
    nock.init();
    supabaseScope = nock("https://supabase");
    mapsScope = nock("https://maps.googleapis.com");
    supabaseScope
        .get("/rest/v1/session?select=%2A&concludedTime=is.null")
        .reply(200, []);
  });
  tearDown(() {
    nock.cleanAll();
  });

  testWidgets('Places load', (tester) async {
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

    mapsScope
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

  testWidgets('Friends sessions', (WidgetTester tester) async {
    var id = "00000-00000-00000-00000";
    var placeReference = "placeReference";
    supabaseScope
        .get(
            "/rest/v1/session?select=id%2Cdecision%28decision%2CplaceReference%2CparticipantId%29&concludedTime=is.null")
        .reply(200, [
      {
        ColumnNames.session.id: id,
        "decision": [
          {
            ColumnNames.decision.decision: true,
            ColumnNames.decision.placeReference: placeReference,
            ColumnNames.decision.participantId: 101
          }
        ]
      }
    ]);

    var placeName = 'The Last Drop';
    mapsScope
        .get("/maps/api/place/details/json?placeid=$placeReference&key")
        .reply(
            200,
            PlacesDetailsResponse(
                status: 'OK',
                result: PlaceDetails(
                    name: placeName, placeId: '', reference: placeReference),
                htmlAttributions: []).toJson());
    var email2 = 'fake@example.com';
    var interceptor =
        supabaseScope.get("/rest/v1/users?select=name&id=in.%28%22101%22%29");
    interceptor.reply(200, [Users(id: 'PID', email: email2).toJson()]);

    await tester.pumpWidget(const MyApp());

    await tester
        .tap(find.widgetWithText(NavigationDestination, 'Friends sessions'))
        .timeout(const Duration(seconds: 10));
    await tester.pumpAndSettle().timeout(const Duration(seconds: 10));

    expect(find.byType(Card), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Join'));
    await tester.pumpAndSettle().timeout(const Duration(seconds: 10));

    await tester.tap(find.widgetWithText(TextButton, 'View details'));
    await tester.pumpAndSettle().timeout(const Duration(seconds: 10));

    expect(find.byType(AlertDialog), findsOneWidget);
    // TODO: assert text is displayed
  });

  testWidgets('Login dialog', (WidgetTester tester) async {
    Get.put(supabase.SupabaseClient("https://supabase", ""));

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
  });
}
