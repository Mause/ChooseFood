// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:convert';

import 'package:google_maps_webservice/places.dart'
    show GoogleMapsPlaces, Location;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart' as geolocator;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:choose_food/main.dart';
import 'package:mockito/annotations.dart' show GenerateMocks;
import 'package:mockito/mockito.dart' show throwOnMissingStub, verify, when;

import './widget_test.mocks.dart';

@GenerateMocks([http.Client, geolocator.GeolocatorPlatform])
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Increment'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Places load', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Card), findsNothing);

    var myHomePageState =
        tester.state(find.byType(MyHomePage)) as MyHomePageState;
    var client = MockClient();
    throwOnMissingStub(client);
    myHomePageState.places =
        GoogleMapsPlaces(httpClient: client, baseUrl: 'http://localhost:8080');
    var mockGeolocatorPlatform = MockGeolocatorPlatform();
    myHomePageState.geolocatorPlatform = mockGeolocatorPlatform;
    throwOnMissingStub(mockGeolocatorPlatform);

    var response = Future.value(http.Response(
        json.encode({
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
        }),
        200));

    var uri = Uri.parse(myHomePageState.places.buildNearbySearchUrl(
        type: "restaurant", radius: 3000, location: Location(lat: 0, lng: 0)));
    when(client.get(uri)).thenAnswer((_) async => response);
    when(client.get(Uri.parse(
            "https://maps.googleapis.com/maps/api/place/photo?photoreference=1&maxwidth=800")))
        .thenAnswer((_) => Future.value(http.Response(
            "\xFF\xD8\xFF\xE0\x00\x10\x4A\x46\x49\x46\x00\x01", 504,
            headers: {"Content-Type": "image/jpeg"})));

    when(mockGeolocatorPlatform.isLocationServiceEnabled())
        .thenAnswer((_) => Future.value(true));
    when(mockGeolocatorPlatform.requestPermission())
        .thenAnswer((_) => Future.value(geolocator.LocationPermission.always));
    when(mockGeolocatorPlatform.getCurrentPosition(
            timeLimit: const Duration(seconds: 10)))
        .thenAnswer((_) => Future.value(geolocator.Position(
            latitude: 0,
            longitude: 0,
            altitude: 0,
            accuracy: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            timestamp: DateTime.now(),
            floor: 0,
            isMocked: true)));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Get places'));
    await tester.pump();

    verify(client.get(uri)).called(1);

    expect(find.byType(Card), findsOneWidget);
  });
}
