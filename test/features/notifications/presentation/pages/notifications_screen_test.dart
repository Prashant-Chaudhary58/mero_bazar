import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:mero_bazar/features/notifications/presentation/providers/notification_provider.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../test_helper.dart';

void main() {
  late MockNotificationProvider mockNotificationProvider;

  setUp(() {
    mockNotificationProvider = MockNotificationProvider();
    when(() => mockNotificationProvider.notifications).thenReturn([]);
    when(() => mockNotificationProvider.unreadCount).thenReturn(0);
    when(() => mockNotificationProvider.isLoading).thenReturn(false);
    // Mock fetchNotifications to return a completed future immediately
    when(
      () => mockNotificationProvider.fetchNotifications(),
    ).thenAnswer((_) async {});
  });

  Widget createNotificationsScreen() {
    return createTestableWidget(
      child: const NotificationsScreen(),
      notificationProvider: mockNotificationProvider,
    );
  }

  group('NotificationsScreen Widget Tests', () {
    testWidgets('renders title and empty state correctly', (tester) async {
      await tester.pumpWidget(createNotificationsScreen());
      // pump() instead of pumpAndSettle to avoid timing out on microtasks if they spiral
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('No notifications yet'), findsOneWidget);
    });
  });
}
