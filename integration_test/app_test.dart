import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'hooks/hook_example.dart';
import 'steps/colour_parameter.dart';
import 'steps/given_i_pick_a_colour_step.dart';
import 'steps/tap_button_n_times_step.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [RegExp('features/*.*.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..hooks = [HookExample()]
    ..stepDefinitions = [TapButtonNTimesStep(), GivenIPickAColour()]
    ..customStepParameterDefinitions = [ColourParameter()]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart";
  // ..tagExpression = "@smoke" // uncomment to see an example of running scenarios based on tag expressions
  return GherkinRunner().execute(config);
}
