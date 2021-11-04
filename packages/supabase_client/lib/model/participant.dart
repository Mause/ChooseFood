//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Participant {
  /// Returns a new [Participant] instance.
  Participant({
    @required this.id,
    this.createdAt = 'now()',
    @required this.userId,
    @required this.session,
  });

  /// Note: This is a Primary Key.<pk/>
  int id;

  String createdAt;

  int userId;

  /// Note: This is a Foreign Key to `session.id`.<fk table='session' column='id'/>
  String session;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Participant &&
     other.id == id &&
     other.createdAt == createdAt &&
     other.userId == userId &&
     other.session == session;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (createdAt == null ? 0 : createdAt.hashCode) +
    (userId == null ? 0 : userId.hashCode) +
    (session == null ? 0 : session.hashCode);

  @override
  String toString() => 'Participant[id=$id, createdAt=$createdAt, userId=$userId, session=$session]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    if (createdAt != null) {
      json[r'created_at'] = createdAt;
    }
      json[r'userId'] = userId;
      json[r'session'] = session;
    return json;
  }

  /// Returns a new [Participant] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Participant fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Participant(
        id: mapValueOfType<int>(json, r'id'),
        createdAt: mapValueOfType<String>(json, r'created_at'),
        userId: mapValueOfType<int>(json, r'userId'),
        session: mapValueOfType<String>(json, r'session'),
      );
    }
    return null;
  }

  static List<Participant> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Participant.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Participant>[];

  static Map<String, Participant> mapFromJson(dynamic json) {
    final map = <String, Participant>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Participant.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Participant-objects as value to a dart map
  static Map<String, List<Participant>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<Participant>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Participant.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}

