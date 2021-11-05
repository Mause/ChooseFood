//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.0

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Countries {
  /// Returns a new [Countries] instance.
  Countries({
    @required this.id,
    this.name,
    @required this.iso2,
    this.iso3,
    this.localName,
    this.continent,
  });

  /// Note: This is a Primary Key.<pk/>
  int id;

  /// Full country name.
  String name;

  /// ISO 3166-1 alpha-2 code.
  String iso2;

  /// ISO 3166-1 alpha-3 code.
  String iso3;

  /// Local variation of the name.
  String localName;

  CountriesContinentEnum continent;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Countries &&
     other.id == id &&
     other.name == name &&
     other.iso2 == iso2 &&
     other.iso3 == iso3 &&
     other.localName == localName &&
     other.continent == continent;

  @override
  int get hashCode =>
  // ignore: unnecessary_parenthesis
    (id == null ? 0 : id.hashCode) +
    (name == null ? 0 : name.hashCode) +
    (iso2 == null ? 0 : iso2.hashCode) +
    (iso3 == null ? 0 : iso3.hashCode) +
    (localName == null ? 0 : localName.hashCode) +
    (continent == null ? 0 : continent.hashCode);

  @override
  String toString() => 'Countries[id=$id, name=$name, iso2=$iso2, iso3=$iso3, localName=$localName, continent=$continent]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = id;
    if (name != null) {
      json[r'name'] = name;
    }
      json[r'iso2'] = iso2;
    if (iso3 != null) {
      json[r'iso3'] = iso3;
    }
    if (localName != null) {
      json[r'local_name'] = localName;
    }
    if (continent != null) {
      json[r'continent'] = continent;
    }
    return json;
  }

  /// Returns a new [Countries] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Countries fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();
      return Countries(
        id: mapValueOfType<int>(json, r'id'),
        name: mapValueOfType<String>(json, r'name'),
        iso2: mapValueOfType<String>(json, r'iso2'),
        iso3: mapValueOfType<String>(json, r'iso3'),
        localName: mapValueOfType<String>(json, r'local_name'),
        continent: CountriesContinentEnum.fromJson(json[r'continent']),
      );
    }
    return null;
  }

  static List<Countries> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(Countries.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <Countries>[];

  static Map<String, Countries> mapFromJson(dynamic json) {
    final map = <String, Countries>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) => map[key] = Countries.fromJson(value));
    }
    return map;
  }

  // maps a json object with a list of Countries-objects as value to a dart map
  static Map<String, List<Countries>> mapListFromJson(dynamic json, {bool emptyIsNull, bool growable,}) {
    final map = <String, List<Countries>>{};
    if (json is Map && json.isNotEmpty) {
      json
        .cast<String, dynamic>()
        .forEach((key, dynamic value) {
          map[key] = Countries.listFromJson(
            value,
            emptyIsNull: emptyIsNull,
            growable: growable,
          );
        });
    }
    return map;
  }
}


class CountriesContinentEnum {
  /// Instantiate a new enum with the provided [value].
  const CountriesContinentEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value ?? '';

  String toJson() => value;

  static const africa = CountriesContinentEnum._(r'Africa');
  static const antarctica = CountriesContinentEnum._(r'Antarctica');
  static const asia = CountriesContinentEnum._(r'Asia');
  static const europe = CountriesContinentEnum._(r'Europe');
  static const oceania = CountriesContinentEnum._(r'Oceania');
  static const northAmerica = CountriesContinentEnum._(r'North America');
  static const southAmerica = CountriesContinentEnum._(r'South America');

  /// List of all possible values in this [enum][CountriesContinentEnum].
  static const values = <CountriesContinentEnum>[
    africa,
    antarctica,
    asia,
    europe,
    oceania,
    northAmerica,
    southAmerica,
  ];

  static CountriesContinentEnum fromJson(dynamic value) =>
    CountriesContinentEnumTypeTransformer().decode(value);

  static List<CountriesContinentEnum> listFromJson(dynamic json, {bool emptyIsNull, bool growable,}) =>
    json is List && json.isNotEmpty
      ? json.map(CountriesContinentEnum.fromJson).toList(growable: true == growable)
      : true == emptyIsNull ? null : <CountriesContinentEnum>[];
}

/// Transformation class that can [encode] an instance of [CountriesContinentEnum] to String,
/// and [decode] dynamic data back to [CountriesContinentEnum].
class CountriesContinentEnumTypeTransformer {
  factory CountriesContinentEnumTypeTransformer() => _instance ??= const CountriesContinentEnumTypeTransformer._();

  const CountriesContinentEnumTypeTransformer._();

  String encode(CountriesContinentEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CountriesContinentEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CountriesContinentEnum decode(dynamic data, {bool allowNull}) {
    if (data != null) {
      switch (data.toString()) {
        case r'Africa': return CountriesContinentEnum.africa;
        case r'Antarctica': return CountriesContinentEnum.antarctica;
        case r'Asia': return CountriesContinentEnum.asia;
        case r'Europe': return CountriesContinentEnum.europe;
        case r'Oceania': return CountriesContinentEnum.oceania;
        case r'North America': return CountriesContinentEnum.northAmerica;
        case r'South America': return CountriesContinentEnum.southAmerica;
        default:
          if (allowNull == false) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CountriesContinentEnumTypeTransformer] instance.
  static CountriesContinentEnumTypeTransformer _instance;
}


