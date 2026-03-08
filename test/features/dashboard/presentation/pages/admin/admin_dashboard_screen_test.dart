import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/admin/admin_dashboard_screen.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../test_helper.dart';

void main() {
  late MockAdminProvider mockAdminProvider;

  setUp(() {
    mockAdminProvider = MockAdminProvider();
    when(() => mockAdminProvider.isLoading).thenReturn(false);
    when(
      () => mockAdminProvider.stats,
    ).thenReturn({'totalProducts': 10, 'pendingProducts': 2});
    when(() => mockAdminProvider.pendingProducts).thenReturn([]);
  });

  group('AdminDashboardScreen Widget Tests', () {
    testWidgets('renders correctly', (tester) async {
      // Manual setup since TestHelper doesn't have AdminProvider yet
      await tester.pumpWidget(
        createTestableWidget(child: const AdminDashboardScreen()),
      );
      await tester.pump();
      expect(find.byType(AdminDashboardScreen), findsOneWidget);
    });
  });
}
