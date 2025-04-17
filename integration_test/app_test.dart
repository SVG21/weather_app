import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:weather_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Weather App Integration Tests', () {
    testWidgets('1. Your location card is shown with weather details',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Then the location card is displayed with weather details
      expect(find.byType(Card), findsWidgets);
      expect(find.byIcon(Icons.thermostat), findsWidgets);
      expect(find.byIcon(Icons.water_drop), findsWidgets);
      expect(find.byIcon(Icons.wb_iridescent), findsWidgets);
      expect(find.byIcon(Icons.air), findsWidgets);
    });

    testWidgets('2. Pollen info note is shown on home screen', (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // Then the pollen info note should be visible
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(
        find.text('Note: The pollen count will only be displayed for Europe.'),
        findsOneWidget,
      );
    });

    testWidgets('3. Add new location: Kathmandu appears on screen',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // And the location search bar is present
      final input = find.byType(TextField);
      expect(input, findsOneWidget);

      // When I enter "Kathmandu" in the search bar
      await tester.enterText(input, 'Kathmandu');

      // And I tap the search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Then a card for "Kathmandu" is displayed on the screen
      expect(find.text('Kathmandu'), findsOneWidget);
    });

    testWidgets('4. Add duplicate location: Shows duplicate message',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // And the location search bar is present
      final input = find.byType(TextField);
      expect(input, findsOneWidget);

      // And "Kathmandu" has already been added
      await tester.enterText(input, 'Kathmandu');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // When I try to add "Kathmandu" again
      await tester.enterText(input, 'Kathmandu');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Then a "Location already added" message is displayed
      expect(find.text('Location already added'), findsOneWidget);
    });

    testWidgets('5. Add invalid location: Shows not found message',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // And the location search bar is present
      final input = find.byType(TextField);
      expect(input, findsOneWidget);

      // When I enter an invalid location "abcdefghijk"
      await tester.enterText(input, 'abcdefghijk');

      // And I tap the search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Then a "Could not find that city" message is displayed
      expect(find.text('Could not find that city'), findsOneWidget);
    });

    testWidgets('6. Tap location: Navigates to forecast screen',
        (tester) async {
      // Given the app is running
      app.main();
      await tester.pumpAndSettle();

      // And the location search bar is present
      final input = find.byType(TextField);
      await tester.enterText(input, 'Kathmandu');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // When I tap the "Kathmandu" card
      final kathmanduCard = find.ancestor(
        of: find.text('Kathmandu'),
        matching: find.byType(Card),
      );
      await tester.tap(kathmanduCard);
      await tester.pumpAndSettle();

      // Then I am navigated to the 7-Day Forecast screen
      expect(find.text('7-Day Forecast'), findsOneWidget);
    });

    testWidgets('7. Forecast screen shows weather icons', (tester) async {
      // Given I am on the 7-Day Forecast screen for "Kathmandu"
      app.main();
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      await tester.enterText(input, 'Kathmandu');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final kathmanduCard = find.ancestor(
        of: find.text('Kathmandu'),
        matching: find.byType(Card),
      );
      await tester.tap(kathmanduCard);
      await tester.pumpAndSettle();

      // Then the forecast screen displays weather icons
      expect(find.byIcon(Icons.thermostat), findsWidgets);
      expect(find.byIcon(Icons.water_drop), findsWidgets);
      expect(find.byIcon(Icons.air), findsWidgets);
      expect(find.byIcon(Icons.cloud), findsWidgets);
    });

    testWidgets('8. Go back and delete location card', (tester) async {
      // Given I am on the 7-Day Forecast screen for "Kathmandu"
      app.main();
      await tester.pumpAndSettle();

      final input = find.byType(TextField);
      await tester.enterText(input, 'Kathmandu');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final kathmanduCard = find.ancestor(
        of: find.text('Kathmandu'),
        matching: find.byType(Card),
      );
      await tester.tap(kathmanduCard);
      await tester.pumpAndSettle();

      // When I tap the back button
      final backButton = find.byTooltip('Back');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // And I swipe to delete the "Kathmandu" card
      final kathmanduCardOnHome = find.ancestor(
        of: find.text('Kathmandu'),
        matching: find.byType(Card),
      );
      await tester.drag(kathmanduCardOnHome, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Then the "Kathmandu" card is no longer displayed
      expect(find.text('Kathmandu'), findsNothing);
    });
  });
}
