// ignore_for_file: avoid_print

import 'package:flutter_gherkin/flutter_gherkin.dart'
    show FlutterTestConfiguration, GherkinTestSuite;
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

// The application under test.
import 'package:choose_food/main.dart' as app;

part 'gherkin_test_driver.g.dart';

@GherkinTestSuite()
void main() {
  executeTestSuite(
    FlutterTestConfiguration.DEFAULT([])
      ..reporters = [
        StdoutReporter(MessageLevel.error)
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        ProgressReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        TestRunSummaryReporter()
          ..setWriteLineFn(print)
          ..setWriteFn(print),
        JsonReporter(
          writeReport: (_, __) => Future<void>.value(),
        ),
      ],
    (World world) => app.main(),
  );
}
