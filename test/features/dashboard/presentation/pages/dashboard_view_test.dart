import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/pages/dashboard_view.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';

void main() {
  late MockDashboardProvider mockDashboardProvider;
  late MockChatProvider mockChatProvider;

  setUp(() {
    mockDashboardProvider = MockDashboardProvider();
    mockChatProvider = MockChatProvider();

    when(() => mockDashboardProvider.selectedIndex).thenReturn(0);
    when(() => mockChatProvider.unreadMessagesCount).thenReturn(0);
    when(() => mockChatProvider.chats).thenReturn([]);
  });

  Widget createDashboardView() {
    return createTestableWidget(
      child: const DashboardView(),
      dashboardProvider: mockDashboardProvider,
      chatProvider: mockChatProvider,
    );
  }

  group('DashboardView Widget Tests', () {
    testWidgets('renders bottom navigation with 4 items', (tester) async {
      await tester.pumpWidget(createDashboardView());
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Favourite'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('calls setSelectedIndex when a tab is tapped', (tester) async {
      await tester.pumpWidget(createDashboardView());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chat'));
      verify(() => mockDashboardProvider.setSelectedIndex(1)).called(1);
    });
  });
}
