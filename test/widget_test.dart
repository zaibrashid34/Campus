import 'package:flutter_test/flutter_test.dart';
import 'package:campus_food_ordering/main.dart';

void main() {
  testWidgets('Campus food app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CampusFoodApp());
    expect(find.byType(CampusFoodApp), findsOneWidget);

    // Pump timer in SplashScreen
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
