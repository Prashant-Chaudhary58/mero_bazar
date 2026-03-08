import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/product_card_widget.dart';
import '../../../../test_helper.dart';

void main() {
  testWidgets('ProductCardWidget renders product information', (tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        child: const ProductCardWidget(
          name: 'Test Product',
          image: 'assets/logo.png',
          price: 100,
          rating: 4.5,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('Rs. 100'), findsOneWidget);
  });
}
