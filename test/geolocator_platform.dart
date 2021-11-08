import 'package:geolocator/geolocator.dart';

class MockGeolocatorPlatform extends GeolocatorPlatform {
  @override
  Future<LocationPermission> requestPermission() =>
      Future.value(LocationPermission.always);

  @override
  Future<bool> isLocationServiceEnabled() => Future.value(true);

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
