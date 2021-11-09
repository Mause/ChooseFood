import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'openapi.enums.swagger.dart' as enums;

part 'openapi.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class Countries {
  Countries({
    this.id,
    this.name,
    this.iso2,
    this.iso3,
    this.localName,
    this.continent,
  });

  factory Countries.fromJson(Map<String, dynamic> json) =>
      _$CountriesFromJson(json);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'iso2')
  final String? iso2;
  @JsonKey(name: 'iso3')
  final String? iso3;
  @JsonKey(name: 'local_name')
  final String? localName;
  @JsonKey(
      name: 'continent',
      toJson: countriesContinentToJson,
      fromJson: countriesContinentFromJson)
  final enums.CountriesContinent? continent;
  static const fromJsonFactory = _$CountriesFromJson;
  static const toJsonFactory = _$CountriesToJson;
  Map<String, dynamic> toJson() => _$CountriesToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Countries &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.iso2, iso2) ||
                const DeepCollectionEquality().equals(other.iso2, iso2)) &&
            (identical(other.iso3, iso3) ||
                const DeepCollectionEquality().equals(other.iso3, iso3)) &&
            (identical(other.localName, localName) ||
                const DeepCollectionEquality()
                    .equals(other.localName, localName)) &&
            (identical(other.continent, continent) ||
                const DeepCollectionEquality()
                    .equals(other.continent, continent)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(iso2) ^
      const DeepCollectionEquality().hash(iso3) ^
      const DeepCollectionEquality().hash(localName) ^
      const DeepCollectionEquality().hash(continent) ^
      runtimeType.hashCode;
}

extension $CountriesExtension on Countries {
  Countries copyWith(
      {int? id,
      String? name,
      String? iso2,
      String? iso3,
      String? localName,
      enums.CountriesContinent? continent}) {
    return Countries(
        id: id ?? this.id,
        name: name ?? this.name,
        iso2: iso2 ?? this.iso2,
        iso3: iso3 ?? this.iso3,
        localName: localName ?? this.localName,
        continent: continent ?? this.continent);
  }
}

@JsonSerializable(explicitToJson: true)
class Decision {
  Decision({
    this.id,
    this.createdAt,
    this.sessionId,
    this.decision,
    this.placeReference,
    this.participantId,
  });

  factory Decision.fromJson(Map<String, dynamic> json) =>
      _$DecisionFromJson(json);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'sessionId')
  final String? sessionId;
  @JsonKey(name: 'decision')
  final bool? decision;
  @JsonKey(name: 'placeReference')
  final String? placeReference;
  @JsonKey(name: 'participantId')
  final String? participantId;
  static const fromJsonFactory = _$DecisionFromJson;
  static const toJsonFactory = _$DecisionToJson;
  Map<String, dynamic> toJson() => _$DecisionToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Decision &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.sessionId, sessionId) ||
                const DeepCollectionEquality()
                    .equals(other.sessionId, sessionId)) &&
            (identical(other.decision, decision) ||
                const DeepCollectionEquality()
                    .equals(other.decision, decision)) &&
            (identical(other.placeReference, placeReference) ||
                const DeepCollectionEquality()
                    .equals(other.placeReference, placeReference)) &&
            (identical(other.participantId, participantId) ||
                const DeepCollectionEquality()
                    .equals(other.participantId, participantId)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(sessionId) ^
      const DeepCollectionEquality().hash(decision) ^
      const DeepCollectionEquality().hash(placeReference) ^
      const DeepCollectionEquality().hash(participantId) ^
      runtimeType.hashCode;
}

extension $DecisionExtension on Decision {
  Decision copyWith(
      {int? id,
      String? createdAt,
      String? sessionId,
      bool? decision,
      String? placeReference,
      String? participantId}) {
    return Decision(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        sessionId: sessionId ?? this.sessionId,
        decision: decision ?? this.decision,
        placeReference: placeReference ?? this.placeReference,
        participantId: participantId ?? this.participantId);
  }
}

@JsonSerializable(explicitToJson: true)
class Participant {
  Participant({
    this.id,
    this.createdAt,
    this.userId,
    this.session,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'userId')
  final int? userId;
  @JsonKey(name: 'session')
  final String? session;
  static const fromJsonFactory = _$ParticipantFromJson;
  static const toJsonFactory = _$ParticipantToJson;
  Map<String, dynamic> toJson() => _$ParticipantToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Participant &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.session, session) ||
                const DeepCollectionEquality().equals(other.session, session)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(session) ^
      runtimeType.hashCode;
}

extension $ParticipantExtension on Participant {
  Participant copyWith(
      {int? id, String? createdAt, int? userId, String? session}) {
    return Participant(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        userId: userId ?? this.userId,
        session: session ?? this.session);
  }
}

@JsonSerializable(explicitToJson: true)
class Session {
  Session({
    this.id,
    this.createdAt,
    this.concludedTime,
    this.point,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'concludedTime')
  final String? concludedTime;
  @JsonKey(name: 'point')
  final Point? point;
  static const fromJsonFactory = _$SessionFromJson;
  static const toJsonFactory = _$SessionToJson;
  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Session &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality()
                    .equals(other.createdAt, createdAt)) &&
            (identical(other.concludedTime, concludedTime) ||
                const DeepCollectionEquality()
                    .equals(other.concludedTime, concludedTime)) &&
            (identical(other.point, point) ||
                const DeepCollectionEquality().equals(other.point, point)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(concludedTime) ^
      const DeepCollectionEquality().hash(point) ^
      runtimeType.hashCode;
}

extension $SessionExtension on Session {
  Session copyWith(
      {String? id, String? createdAt, String? concludedTime, Point? point}) {
    return Session(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        concludedTime: concludedTime ?? this.concludedTime,
        point: point ?? this.point);
  }
}

@JsonSerializable(explicitToJson: true)
class Point {
  Point({
    this.type,
    this.coordinates,
  });

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  @JsonKey(name: 'type', toJson: pointTypeToJson, fromJson: pointTypeFromJson)
  final enums.PointType? type;
  @JsonKey(name: 'coordinates', defaultValue: <double>[])
  final List<double>? coordinates;
  static const fromJsonFactory = _$PointFromJson;
  static const toJsonFactory = _$PointToJson;
  Map<String, dynamic> toJson() => _$PointToJson(this);

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Point &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.coordinates, coordinates) ||
                const DeepCollectionEquality()
                    .equals(other.coordinates, coordinates)));
  }

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(coordinates) ^
      runtimeType.hashCode;
}

extension $PointExtension on Point {
  Point copyWith({enums.PointType? type, List<double>? coordinates}) {
    return Point(
        type: type ?? this.type, coordinates: coordinates ?? this.coordinates);
  }
}

String? countriesContinentToJson(enums.CountriesContinent? countriesContinent) {
  return enums.$CountriesContinentMap[countriesContinent];
}

enums.CountriesContinent countriesContinentFromJson(
    String? countriesContinent) {
  if (countriesContinent == null) {
    return enums.CountriesContinent.swaggerGeneratedUnknown;
  }

  return enums.$CountriesContinentMap.entries
      .firstWhere(
          (element) =>
              element.value.toLowerCase() == countriesContinent.toLowerCase(),
          orElse: () => const MapEntry(
              enums.CountriesContinent.swaggerGeneratedUnknown, ''))
      .key;
}

List<String> countriesContinentListToJson(
    List<enums.CountriesContinent>? countriesContinent) {
  if (countriesContinent == null) {
    return [];
  }

  return countriesContinent
      .map((e) => enums.$CountriesContinentMap[e]!)
      .toList();
}

List<enums.CountriesContinent> countriesContinentListFromJson(
    List? countriesContinent) {
  if (countriesContinent == null) {
    return [];
  }

  return countriesContinent
      .map((e) => countriesContinentFromJson(e.toString()))
      .toList();
}

String? pointTypeToJson(enums.PointType? pointType) {
  return enums.$PointTypeMap[pointType];
}

enums.PointType pointTypeFromJson(String? pointType) {
  if (pointType == null) {
    return enums.PointType.swaggerGeneratedUnknown;
  }

  return enums.$PointTypeMap.entries
      .firstWhere(
          (element) => element.value.toLowerCase() == pointType.toLowerCase(),
          orElse: () =>
              const MapEntry(enums.PointType.swaggerGeneratedUnknown, ''))
      .key;
}

List<String> pointTypeListToJson(List<enums.PointType>? pointType) {
  if (pointType == null) {
    return [];
  }

  return pointType.map((e) => enums.$PointTypeMap[e]!).toList();
}

List<enums.PointType> pointTypeListFromJson(List? pointType) {
  if (pointType == null) {
    return [];
  }

  return pointType.map((e) => pointTypeFromJson(e.toString())).toList();
}
