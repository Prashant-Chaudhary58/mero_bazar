import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/home_search_widget.dart';
import '../../../../test_helper.dart';

void main() {
  testWidgets('HomeSearchWidget renders correctly', (tester) async {
    await tester.pumpWidget(
      createTestableWidget(child: const HomeSearchWidget()),
    );
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
  });
}
