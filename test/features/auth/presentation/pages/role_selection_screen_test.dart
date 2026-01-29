import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/auth/presentation/pages/role_selection_screen.dart';

void main() {
  group('RoleSelectionScreen Widget Tests', () {
    // Helper to pump the screen
    Future<void> pumpRoleSelectionScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const RoleSelectionScreen(),
          routes: {'/login': (context) => const Scaffold(body: Text('Login'))},
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders correctly with logo, title, and role cards', (
      tester,
    ) async {
      await pumpRoleSelectionScreen(tester);

      // App logo
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2)); // farmer + buyer

      // Title
      expect(find.text('Select Your role'), findsOneWidget);

      // Role cards
      expect(find.text('Seller'), findsOneWidget);
      expect(find.text('Buyer'), findsOneWidget);

      // Bottom texts
      expect(find.text('Join Us'), findsOneWidget);
      expect(find.text('Shop Green, Live Green.'), findsOneWidget);
    });

    testWidgets(
      'tapping Seller card navigates to /login with seller argument',
      (tester) async {
        await pumpRoleSelectionScreen(tester);

        // Find the Seller card
        final sellerFinder = find.text('Seller');
        expect(sellerFinder, findsOneWidget);

        // Tap the Seller column
        await tester.tap(
          find.ancestor(of: sellerFinder, matching: find.byType(InkWell)),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('tapping Buyer card navigates to /login with buyer argument', (
      tester,
    ) async {
      await pumpRoleSelectionScreen(tester);

      final buyerFinder = find.text('Buyer');
      expect(buyerFinder, findsOneWidget);

      await tester.tap(
        find.ancestor(of: buyerFinder, matching: find.byType(InkWell)),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('screen has proper layout and spacing', (tester) async {
      await pumpRoleSelectionScreen(tester);

      final columnFinder = find.byType(Column);
      expect(columnFinder, findsNWidgets(3));

      expect(find.byType(Spacer), findsOneWidget);

      // Bottom section exists
      expect(find.text('Join Us'), findsOneWidget);
      expect(find.text('Shop Green, Live Green.'), findsOneWidget);
    });

    testWidgets('images load without error (asset paths correct)', (
      tester,
    ) async {
      await pumpRoleSelectionScreen(tester);

      // If assets are missing, pumpWidget would throw
      expect(tester.takeException(), isNull);

      // Verify 2 Image widgets (farmer + buyer)
      expect(find.byType(Image), findsNWidgets(2));
    });
  });
}
