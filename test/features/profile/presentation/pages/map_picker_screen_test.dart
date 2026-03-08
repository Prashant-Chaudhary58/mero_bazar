import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/profile/presentation/pages/map_picker_screen.dart';
import '../../../../test_helper.dart';

void main() {
  Widget createMapPickerScreen() {
    return createTestableWidget(child: const MapPickerScreen());
  }

  group('MapPickerScreen Widget Tests', () {
    testWidgets('renders map picker title', (tester) async {
      await tester.pumpWidget(createMapPickerScreen());
      await tester.pump();

      expect(find.text('Pick Location'), findsOneWidget);
    });
  });
}
