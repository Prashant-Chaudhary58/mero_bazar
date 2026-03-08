import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/widgets/home_banner_widget.dart';
import '../../../../test_helper.dart';

void main() {
  testWidgets('HomeBannerWidget renders correctly', (tester) async {
    await tester.pumpWidget(
      createTestableWidget(child: const HomeBannerWidget()),
    );
    await tester.pump();

    expect(find.byType(HomeBannerWidget), findsOneWidget);
  });
}
