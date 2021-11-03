import 'package:choose_food/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets('screenshot', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const MyApp());

    await binding.convertFlutterSurfaceToImage();

    // Trigger a frame.
    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-default');

    await tester.tap(find.text("Friends sessions"));

    await tester.pumpAndSettle();
    await binding.takeScreenshot('screenshot-friends');
  });
}
