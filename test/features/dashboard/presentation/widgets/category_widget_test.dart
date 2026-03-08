import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/category_widget.dart';
import '../../../../test_helper.dart';

void main() {
  testWidgets('CategoryWidget renders correctly', (tester) async {
    await tester.pumpWidget(
      createTestableWidget(
        child: const CategoryWidget(title: 'Vegetables', isSelected: true),
      ),
    );
    await tester.pump();

    expect(find.text('Vegetables'), findsOneWidget);
  });
}
