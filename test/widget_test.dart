import 'dart:convert' show base64Url, json, jsonEncode;

import 'package:choose_food/generated_code/openapi.models.swagger.dart'
    show Users;
import 'package:choose_food/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        WidgetTester,
        expect,
        find,
        findsNothing,
        findsOneWidget,
        findsWidgets,
        hasLength,
        isNull,
        setUp,
        tearDown,
        testWidgets;
import 'package:flutter_test/src/finders.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart'
    show SelectorButton;
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

    var phone = '416041357';

    supabaseScope
        .post("/auth/v1/otp", json.encode({"phone": "+61" + phone}))
        .reply(200, {});
    var token = '101010';
    supabaseScope
        .post(
            "/auth/v1/verify",
            json.encode({
              'phone': "+61" + phone,
              'token': token,
              'type': 'sms',
              'redirect_to': null
            }))
        .reply(200, {
      "error": null,
      "access_token": "ey." +
          base64Url.encode(jsonEncode({"exp": null, "sub": "id"}).codeUnits) +
          ".ey",
      'expires_in': 3600
    });

    tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('plugin.libphonenumber'),
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case "isValidPhoneNumber":
          return true;
        case "formatAsYouType":
          return methodCall.arguments['phoneNumber'];
        case "normalizePhoneNumber":
          return methodCall.arguments['phoneNumber'];
        default:
          log.e(methodCall);
      }
    });

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(await tester.takeException(), isNull);

    Finder inputField = find.byKey(const Key('phone'));
    expect(inputField, findsOneWidget);

    await tester.tap(find.byType(SelectorButton));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(400.0, 234.0));
    await tester.pumpAndSettle();

    await tester.enterText(inputField, phone);
    await tester.pumpAndSettle();

    var phoneField = tester.state(inputField) as dynamic;
    var countries = phoneField.countries as List<dynamic>;
    var au = countries[13];
    phoneField.onCountryChanged(au);
    await tester.pumpAndSettle();

    expect(
        (list(ElevatedButton) + list(TextButton) + list(OutlinedButton))
            .map((e) => e as StatefulElement)
            .map((e) => e.widget as ButtonStyleButton)
            .map((e) => e.child as Text)
            .map((e) => e.data)
            .toList(),
        hasLength(9));

    await tester.tap(find.widgetWithText(TextButton, 'CONTINUE').at(0));
    await tester.pumpAndSettle();

    var loginCode = find.widgetWithText(TextFormField, "Login code");
    await tester.enterText(loginCode, token);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'CONTINUE').at(1));
    await tester.pumpAndSettle();

    expect(find.text("Welcome!"), findsWidgets);
  });
}

List<Element> list(Type t) {
  return find.byType(t).evaluate().toList();
}
