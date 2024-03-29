import 'dart:convert' show base64Url, json, jsonEncode;
import 'dart:io' show Platform;

import 'package:choose_food/components/friends_sessions.dart'
    show FriendsSessions, SessionWithDecisions;
import 'package:choose_food/generated_code/openapi.enums.swagger.dart'
    show PointType;
import 'package:choose_food/generated_code/openapi.models.swagger.dart'
    show Decision, Participant, Point, Session, Users;
import 'package:choose_food/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_test/flutter_test.dart'
    show
        Skip,
        WidgetTester,
        expect,
        setUpAll,
        find,
        findsNothing,
        findsOneWidget,
        findsWidgets,
        hasLength,
        isNull,
        setUp,
        tearDown;
import 'package:flutter_test/src/finders.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:get/get.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl_phone_number_input/src/widgets/selector_button.dart'
    show SelectorButton;
import 'package:network_image_mock/network_image_mock.dart'
    show mockNetworkImagesFor;
import 'package:nock/nock.dart';
import 'package:nock/src/scope.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:test/test.dart' show group;

import 'geolocator_platform.dart' show MockGeolocatorPlatform;

List<MapEntry<String, String>> getColours(String prefix) => {
      '${prefix}_100': '000000000',
      '${prefix}_50': '000000000',
      '${prefix}_100': '000000000',
      '${prefix}_200': '000000000',
      '${prefix}_300': '000000000',
      '${prefix}_400': '000000000',
      '${prefix}_500': '000000000',
      '${prefix}_600': '000000000',
      '${prefix}_700': '000000000',
      '${prefix}_800': '000000000',
      '${prefix}_900': '000000000',
    }.entries.toList();

void setupColours(WidgetTester tester) => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('material_you_colours'),
            (message) async {
      switch (message.method) {
        case "getMaterialYouColours":
          return Map.fromEntries(getColours('system_accent1') +
              getColours('system_accent2') +
              getColours('system_accent3') +
              getColours('system_neutral1') +
              getColours('system_neutral2'));
      }
      throw Exception(message.method);
    });

String accessToken({String role = "authenticated"}) =>
    "ey." +
    base64Url.encode(jsonEncode({
      "sub": "id",
      "aud": "",
      'phone': "",
      'role': "authenticated",
      'updated_at': "",
    }).codeUnits) +
    ".ey";

void setupContacts(WidgetTester tester,
        {List<Map<String, dynamic>>? contacts}) =>
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('github.com/QuisApp/flutter_contacts'),
        (message) async {
      switch (message.method) {
        case "requestPermission":
          return true;
        case "select":
          return contacts ?? [];
      }
      throw Exception(message.method);
    });

void setupLibPhoneNumber(WidgetTester tester) =>
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
        case "getRegionInfo":
          return {};
      }
      throw Exception(methodCall.method);
    });

void testWidgets(String name, Future<void> Function(WidgetTester tester) fn) {
  flutter_test.testWidgets(name, (tester) async {
    // ignore: avoid_print
    print("::group::$name");
    await fn(tester);
    // ignore: avoid_print
    print("::endgroup::");
  });
}

void main() {
  late NockScope supabaseScope;
  late NockScope mapsScope;
  late supabase.SupabaseClient supabaseClient;

  setUpAll(() {
    supabase.Supabase.initialize(url: "https://supabase", anonKey: "");
    supabase.Supabase.instance.client.auth.currentSession =
        supabase.Session(accessToken: accessToken());
  });

  setUp(() {
    nock.init();
    supabaseScope = nock("https://supabase");
    mapsScope = nock("https://maps.googleapis.com");
    supabaseScope
        .get("/rest/v1/session?select=%2A&concludedTime=is.null")
        .reply(200, []);
    supabaseClient = supabase.SupabaseClient("https://supabase", "");
    supabaseClient.auth.setAuth(accessToken());
  });
  tearDown(() {
    nock.cleanAll();
  });

  testWidgets('Places load', (tester) async {
    setupColours(tester);
    var sessionId = "0000-00000-00000-00000";
    var point =
        Point(type: PointType.point, coordinates: [115.8577778, -31.9509882]);
    supabaseScope.post("/rest/v1/session", {"point": point.toJson()}).reply(
        200, [Session(id: sessionId, point: point)]);

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
    mockParticipant(supabaseScope, sessionId);

    await Get.deleteAll();
    geolocator.GeolocatorPlatform.instance = MockGeolocatorPlatform();
    Get.put(supabaseClient);

    await tester.pumpWidget(const MyApp());

    expect(find.byType(Card), findsNothing);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get places'));
    await mockNetworkImagesFor(() => tester.pump());

    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('Friends sessions', (WidgetTester tester) async {
    var phone = '+614000000000';
    setupLibPhoneNumber(tester);
    setupContacts(tester, contacts: [
      {
        "phones": [
          {"normalizedNumber": phone}
        ]
      }
    ]);

    var id = "00000-00000-00000-00000";
    var placeReference = "placeReference";
    supabaseScope
        .get(
            "/rest/v1/session?select=id%2Cdecision%28decision%2CplaceReference%2CparticipantId%29&concludedTime=is.null")
        .reply(200, [
      SessionWithDecisions(
          id: id,
          decision: [
            Decision(
                decision: true,
                placeReference: placeReference,
                participantId: 101,
                id: 0)
          ],
          point: Point())
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
    var email = 'fake@example.com';
    supabaseScope
        .get("/rest/v1/users?select=name&id=in.%28101%29")
        .reply(200, [Users(id: 'PID', email: email, phone: phone).toJson()]);
    mockParticipant(supabaseScope, id);

    supabaseScope.post("/rest/v1/rpc/get_matching_users", {
      "phones": [phone]
    }).reply(200, [Users()]);

    await tester.pumpWidget(const MyApp());

    await tester
        .tap(find.widgetWithText(NavigationDestination, 'Friends sessions'))
        .timeout(const Duration(seconds: 10));
    await tester.pumpAndSettle().timeout(const Duration(seconds: 10));

    expect(find.text("You have 1 friends"), findsOneWidget);

    expect(find.byType(Card), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Join'));
    await tester.pumpAndSettle().timeout(const Duration(seconds: 10));

    await tester.tap(find.widgetWithText(TextButton, 'View details'));
    await tester.pumpAndSettle().timeout(const Duration(seconds: 10));

    expect(find.byType(AlertDialog), findsOneWidget);
    // TODO: assert text is displayed
  });

  testWidgets('Login dialog', (WidgetTester tester) async {
    setupLibPhoneNumber(tester);
    await Get.deleteAll();
    supabaseClient.auth.currentSession = null;
    Get.put(supabaseClient);

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
        .reply(200,
            {"error": null, "access_token": accessToken(), 'expires_in': 3600});

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

    expect(find.text('You are now logged in. Eat well 💜'), findsWidgets);
  });

  group('golden tests', () {
    testGoldens('golden', (tester) async {
      setupContacts(tester);
      supabaseScope
          .get(
              "/rest/v1/session?select=id%2Cdecision%28decision%2CplaceReference%2CparticipantId%29&concludedTime=is.null")
          .reply(200, [
        SessionWithDecisions(
            decision: [
              Decision(
                  id: 0, placeReference: "", participantId: 0, decision: false)
            ],
            id: "0",
            concludedTime: null,
            createdAt: DateTime.now().toIso8601String(),
            point: Point())
      ]);
      supabaseScope
          .get("/rest/v1/participant?select=%2A&userId=in.%28%29")
          .reply(200, []);
      supabaseScope.post(
          "/rest/v1/rpc/get_matching_users", {"phones": []}).reply(200, []);

      var goldens = GoldenBuilder.column(
          wrap: (widget) => Container(
              width: 600,
              height: 1000,
              margin: const EdgeInsets.all(20),
              child: widget))
        ..addScenario('main', const FriendsSessions());
      await loadAppFonts();

      await tester.pumpWidgetBuilder(goldens.build(),
          surfaceSize: const Size.square(1500));
      await screenMatchesGolden(tester, 'main', autoHeight: true);
    });
  }, onPlatform: {
    'windows': Platform.environment.containsKey('CI')
        ? [const Skip("Only run on CI if not on windows")]
        : []
  });
}

void mockParticipant(NockScope supabaseScope, String sessionId) {
  supabaseScope.post("/rest/v1/participant", {
    "sessionId": sessionId,
    "userId": "id"
  }).reply(200, [Participant(id: 0, sessionId: sessionId, userId: '0')]);
}

List<Element> list(Type t) {
  return find.byType(t).evaluate().toList();
}
