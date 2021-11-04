//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Decision {
  /// Returns a new [Decision] instance.
  Decision({
    @required this.id,
    this.createdAt = 'now()',
    this.sessionId,
    this.decision,
    @required this.placeReference,
  });

  /// Note: This is a Primary Key.<pk/>
  int id;

  String createdAt;

  /// Note: This is a Foreign Key to `session.id`.<fk table='session' column='id'/>
  String sessionId;

  bool decision;

  String placeReference;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Decision &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.sessionId == sessionId &&
     other.decision == decision &&
     other.placeReference == placeReference;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (createdAt == null ? 0 : createdAt.hashCode) +
    (sessionId == null ? 0 : sessionId.hashCode) +
    (decision == null ? 0 : decision.hashCode) +
    (placeReference == null ? 0 : placeReference.hashCode);

  @override
  String toString() => 'Decision[id=$id, createdAt=$createdAt, sessionId=$sessionId, decision=$decision, placeReference=$placeReference]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    if (createdAt != null) {
      json[r'created_at'] = createdAt;
    }
    if (sessionId != null) {
      json[r'sessionId'] = sessionId;
    }
    if (decision != null) {
      json[r'decision'] = decision;
    }
      json[r'placeReference'] = placeReference;
    return json;
  }

  /// Returns a new [Decision] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Decision fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Decision(
        id: mapValueOfType<int>(json, r'id'),
        createdAt: mapValueOfType<String>(json, r'created_at'),
        sessionId: mapValueOfType<String>(json, r'sessionId'),
        decision: mapValueOfType<bool>(json, r'decision'),
        placeReference: mapValueOfType<String>(json, r'placeReference'),
      );
    }
    return null;
  }

  static List<Decision> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Decision.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Decision>[];

  static Map<String, Decision> mapFromJson(dynamic json) {
    final map = <String, Decision>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Decision.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Decision-objects as value to a dart map
  static Map<String, List<Decision>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<Decision>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Decision.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}
