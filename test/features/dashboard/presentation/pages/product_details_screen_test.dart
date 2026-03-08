import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/product_details_screen.dart';
import 'package:mero_bazar/features/dashboard/data/models/product_model.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';

void main() {
  Widget createProductDetailsScreen() {
    return createTestableWidget(child: const ProductDetailsScreen());
  }

  group('ProductDetailsScreen Widget Tests', () {
    testWidgets('renders product details screen', (tester) async {
      // We'll wrap in a navigator to avoid ModalRoute.of(context) issues if it doesn't default correctly
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: const RouteSettings(arguments: {'isEditable': false}),
            builder: (context) => createProductDetailsScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ProductDetailsScreen), findsOneWidget);
    });
  });
}
