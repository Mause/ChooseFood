import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:gherkin/gherkin.dart';

// ignore: non_constant_identifier_names
StepDefinitionGeneric GivenIPickAColour() {
  return when2<String, int, FlutterWorld>(
    'I tap the {string} button {int} times',
    (key, count, context) async {
      final locator = find.byValueKey(key);
      for (var i = 0; i < count; i += 1) {
        await context.world.driver!.tap(locator);
      }
    },
  );
}
