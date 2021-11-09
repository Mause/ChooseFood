import 'package:json_annotation/json_annotation.dart';

enum CountriesContinent {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('Africa')
  africa,
  @JsonValue('Antarctica')
  antarctica,
  @JsonValue('Asia')
  asia,
  @JsonValue('Europe')
  europe,
  @JsonValue('Oceania')
  oceania,
  @JsonValue('North America')
  northAmerica,
  @JsonValue('South America')
  southAmerica
}

const $CountriesContinentMap = {
  CountriesContinent.africa: 'Africa',
  CountriesContinent.antarctica: 'Antarctica',
  CountriesContinent.asia: 'Asia',
  CountriesContinent.europe: 'Europe',
  CountriesContinent.oceania: 'Oceania',
  CountriesContinent.northAmerica: 'North America',
  CountriesContinent.southAmerica: 'South America',
  CountriesContinent.swaggerGeneratedUnknown: ''
};

enum PointType {
  @JsonValue('swaggerGeneratedUnknown')
  swaggerGeneratedUnknown,
  @JsonValue('Point')
  point
}

const $PointTypeMap = {
  PointType.point: 'Point',
  PointType.swaggerGeneratedUnknown: ''
};
