import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.example.app/colors');

Future<ThemeData> getThemeData() async {
  var snapshot = await getMaterialYouColor();

  final primarySwatch = snapshot?.accent1 ?? Colors.blue;
  final accent2Swatch = snapshot?.accent2 ?? Colors.blue;
  final accent3Swatch = snapshot?.accent3 ?? Colors.blue;
  return ThemeData(
    primarySwatch: primarySwatch,
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) => accent2Swatch),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.resolveWith((states) => accent3Swatch),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent3Swatch.shade300,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: accent2Swatch.shade100,
      selectedIconTheme: IconThemeData(
        color: accent2Swatch.shade900,
      ),
      unselectedIconTheme: IconThemeData(
        color: accent2Swatch.shade300,
      ),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
    ),
  );
}

Future<MaterialYouPalette?> getMaterialYouColor() async {
  // Material You colors are available on Android only
  if (defaultTargetPlatform != TargetPlatform.android) return null;

  try {
    final data = await platform.invokeMethod('getMaterialYouColors');
    if (data == null) return null;

    final Map<String, dynamic> items =
        (json.decode(data) as Map<String, dynamic>);
    return MaterialYouPalette(
      accent1: items.getAccent1(),
      accent2: items.getAccent2(),
      accent3: items.getAccent3(),
      neutral1: items.getNeutral1(),
      neutral2: items.getNeutral2(),
    );
  } on PlatformException catch (_) {
    return null;
  }
}

class MaterialYouPalette {
  final MaterialColor accent1;
  final MaterialColor accent2;
  final MaterialColor accent3;
  final MaterialColor neutral1;
  final MaterialColor neutral2;

  MaterialYouPalette({
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.neutral1,
    required this.neutral2,
  });
}

int _parseHexString(String value) =>
    int.parse(value.substring(3, 9), radix: 16) + 0xFF000000;

extension _ColorExtractionExtension on Map<String, dynamic> {
  Color getColor(String colorName) {
    final value = this[colorName];
    final parsed = _parseHexString(value);
    return Color(parsed);
  }

  MaterialColor getAccent1() {
    return get('accent1');
  }

  MaterialColor getAccent2() {
    return get('accent2');
  }

  MaterialColor getAccent3() {
    return get('accent3');
  }

  MaterialColor getNeutral1() {
    return get("neutral1");
  }

  MaterialColor getNeutral2() {
    return get("neutral2");
  }

  MaterialColor get(String infix) {
    return MaterialColor(
      _parseHexString(this['system_${infix}_100']),
      <int, Color>{
        50: getColor('system_${infix}_50'),
        100: getColor('system_${infix}_100'),
        200: getColor('system_${infix}_200'),
        300: getColor('system_${infix}_300'),
        400: getColor('system_${infix}_400'),
        500: getColor('system_${infix}_500'),
        600: getColor('system_${infix}_600'),
        700: getColor('system_${infix}_700'),
        800: getColor('system_${infix}_800'),
        900: getColor('system_${infix}_900'),
      },
    );
  }
}
