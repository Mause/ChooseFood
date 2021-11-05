import 'dart:io' show File;
import 'package:flutter_driver/flutter_driver.dart' show FlutterDriver;
import 'package:integration_test/integration_test_driver_extended.dart'
    show integrationDriver;

Future<void> main() async {
  try {
    var driver = await FlutterDriver.connect(printCommunication: true);

    await integrationDriver(
      driver: driver,
      onScreenshot: (String screenshotName, List<int> screenshotBytes) async {
        final File image = await File('screenshots/$screenshotName.png')
            .create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );
  } catch (e) {
    // ignore: avoid_print
    print('Error occured: $e');
  }
}
