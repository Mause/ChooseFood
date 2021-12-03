import 'dart:convert' show jsonDecode;

import 'package:flutter/services.dart' show ServicesBinding, rootBundle;
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, $checkedCreate;
import 'package:logger/logger.dart' show Logger;

part 'config.g.dart';

var logger = Logger();

@JsonSerializable()
class Config {
  final String googleMapsConfig;

  Config({required this.googleMapsConfig});

  toJson() => _$ConfigToJson(this);
  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}

Future<Config> getConfig() async {
  logger.i("ServicesBinding", ServicesBinding.instance);
  String string = await rootBundle.loadString("config/config.json");
  return Config.fromJson(jsonDecode(string));
}
