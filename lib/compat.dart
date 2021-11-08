import 'dart:async' show Completer, Future;
import 'dart:html' show document;

import 'package:get/get.dart' show Get, Inst;
import 'package:google_maps/google_maps.dart' show LatLng;
import 'package:google_maps/google_maps_places.dart'
    show
        PlaceResult,
        PlacesService,
        PlacesService$Ext,
        PlaceResult$Ext,
        PlacePhoto$Ext,
        PlaceSearchRequest;
import 'package:google_maps_webservice/places.dart'
    show GoogleMapsPlaces, Location, PlacesSearchResult;

abstract class Place {
  String name;

  String reference;

  String buildPhotoUrl(num maxWidth);

  Place({required this.name, required this.reference});
}

class AndroidPlace extends Place {
  String photoReference;
  GoogleMapsPlaces places;

  AndroidPlace(
      {required String name,
      required String reference,
      required this.places,
      required this.photoReference})
      : super(name: name, reference: reference);

  @override
  String buildPhotoUrl(num maxWidth) => places.buildPhotoUrl(
      photoReference: photoReference, maxWidth: maxWidth as int);
}

class Result {
  List<Place> results;
  String? errorMessage;

  Result({required this.results, required this.errorMessage});
}

abstract class Compat {
  Future<Result> getPlaces(Location location, num radius, String type);
}

class Web implements Compat {
  PlacesService placesService = PlacesService(document.window);

  @override
  Future<Result> getPlaces(Location location, num radius, String type) async {
    var placeSearchRequest = PlaceSearchRequest();
    placeSearchRequest.type = type;
    placeSearchRequest.radius = radius;
    placeSearchRequest.location = LatLng(location.lat, location.lng);

    Completer<Result> completer = Completer();
    placesService.nearbySearch(
        placeSearchRequest,
        (results, status, metadata) => completer.complete(Result(
            results: convert(results), errorMessage: status.toString())));

    return await completer.future;
  }

  Place convertItem(PlaceResult? result) {
    return WebPlace(
        photo: result!.photos![0]!.url!,
        reference: result.placeId!,
        name: result.name!);
  }

  List<Place> convert(List<PlaceResult?>? results) {
    return results!.map(convertItem).toList();
  }
}

class WebPlace extends Place {
  String photo;

  WebPlace(
      {required String name, required String reference, required this.photo})
      : super(name: name, reference: reference);

  @override
  String buildPhotoUrl(num maxWidth) => photo;
}

class Android implements Compat {
  GoogleMapsPlaces places = Get.find();

  @override
  Future<Result> getPlaces(Location location, num radius, String type) async {
    var response =
        await places.searchNearbyWithRadius(location, radius, type: type);
    return Result(
        results: convert(response.results),
        errorMessage: response.errorMessage);
  }

  Place convertItem(PlacesSearchResult? result) {
    return AndroidPlace(
        name: result!.name,
        places: places,
        reference: result.reference,
        photoReference: result.photos[0].photoReference);
  }

  List<Place> convert(List<PlacesSearchResult> results) {
    return results.map((e) => convertItem(e)).toList();
  }
}
