import 'package:choose_food/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  Future<void> takeScreenshot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();

    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-$name');
  }

  testWidgets('screenshot', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const MyApp());

    await takeScreenshot(tester, "default");

    await tester.tap(find.text("Friends sessions"));

    await takeScreenshot(tester, 'friends');
  });
}
