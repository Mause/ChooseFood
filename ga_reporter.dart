// ignore_for_file: avoid_print

import 'dart:convert' show json;
import 'dart:io' show stdin;

import 'package:testreport/testreport.dart' show Processor, Test, unfinished;

void printUnprinted(Processor processor, Set printed) {
  for (var suite in processor.report.suites) {
    for (var test in suite.tests) {
      for (var line in test.prints) {
        if (!printed.contains([test, line])) {
          print(line);
          printed.add([test, line]);
        }
      }
    }
  }
}

void main() {
  var processor = Processor(timestamp: DateTime.now());

  Set printed = {};

  Test? current;
  while (true) {
    var line = stdin.readLineSync();
    if (line == null) break;
    processor.process(json.decode(line));
    printUnprinted(processor, printed);
    if (processor.report.suites.isNotEmpty) {
      var suite = processor.report.suites.first;
      current = suite.tests.isNotEmpty ? suite.tests.last : null;
      if (current?.duration == 0) {
        print("::group::${current!.name}");
      } else if (current?.duration != unfinished) {
        print("::endgroup::");
      }
    }
  }
}
