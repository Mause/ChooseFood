//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Session {
  /// Returns a new [Session] instance.
  Session({
    @required this.id,
    this.createdAt = 'now()',
    this.concludedTime = 'timezone(\'utc\'::text, now())',
    this.point,
  });

  /// Note: This is a Primary Key.<pk/>
  String id;

  String createdAt;

  String concludedTime;

  String point;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Session &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.concludedTime == concludedTime &&
     other.point == point;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (createdAt == null ? 0 : createdAt.hashCode) +
    (concludedTime == null ? 0 : concludedTime.hashCode) +
    (point == null ? 0 : point.hashCode);

  @override
  String toString() => 'Session[id=$id, createdAt=$createdAt, concludedTime=$concludedTime, point=$point]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    if (createdAt != null) {
      json[r'created_at'] = createdAt;
    }
    if (concludedTime != null) {
      json[r'concludedTime'] = concludedTime;
    }
    if (point != null) {
      json[r'point'] = point;
    }
    return json;
  }

  /// Returns a new [Session] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Session fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Session(
        id: mapValueOfType<String>(json, r'id'),
        createdAt: mapValueOfType<String>(json, r'created_at'),
        concludedTime: mapValueOfType<String>(json, r'concludedTime'),
        point: mapValueOfType<String>(json, r'point'),
      );
    }
    return null;
  }

  static List<Session> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Session.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Session>[];

  static Map<String, Session> mapFromJson(dynamic json) {
    final map = <String, Session>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Session.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Session-objects as value to a dart map
  static Map<String, List<Session>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<Session>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Session.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

