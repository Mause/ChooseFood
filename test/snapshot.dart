import 'dart:typed_data' show ByteData;
import 'dart:ui' show Image, ImageByteFormat;

import 'package:flutter/widgets.dart' show Element;
import 'package:flutter_test/flutter_test.dart'
    show Finder, Future, TestWidgetsFlutterBinding, goldenFileComparator;
import 'package:flutter_test/src/_matchers_io.dart' show captureImage;
import 'package:golden_toolkit/golden_toolkit.dart' show loadAppFonts;

Future<String?> snapshot(String path, Finder item) async {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized()
          as TestWidgetsFlutterBinding;

  return binding.runAsync<String?>(() async {
    final Iterable<Element> elements = item.evaluate();
    if (elements.isEmpty) {
      return 'could not be rendered because no widget was found';
    } else if (elements.length > 1) {
      return 'matched too many widgets';
    }
    await loadAppFonts();

    final Image? image = await captureImage(elements.single);

    if (image == null) {
      throw AssertionError('Future<Image> completed to null');
    }
    final ByteData? bytes = await image.toByteData(format: ImageByteFormat.png);
    if (bytes == null) return 'could not encode screenshot.';
    await goldenFileComparator.update(
        Uri(path: path), bytes.buffer.asUint8List());
    return null;
  });
}
