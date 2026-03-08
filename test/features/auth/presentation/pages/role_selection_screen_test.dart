import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/auth/presentation/pages/role_selection_screen.dart';
import '../../../../test_helper.dart';

void main() {
  group('RoleSelectionScreen Widget Tests', () {
    Widget createRoleSelectionScreen() {
      return createTestableWidget(child: const RoleSelectionScreen());
    }

    testWidgets('renders correctly with logo and role cards', (tester) async {
      await tester.pumpWidget(createRoleSelectionScreen());
      await tester.pumpAndSettle();

      expect(find.text('Select Your role'), findsOneWidget);
      expect(find.text('Seller'), findsOneWidget);
      expect(find.text('Buyer'), findsOneWidget);
    });
  });
}
