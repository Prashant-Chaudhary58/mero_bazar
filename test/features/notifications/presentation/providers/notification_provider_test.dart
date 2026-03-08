import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/notifications/presentation/providers/notification_provider.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('NotificationProvider Unit Tests', () {
    late NotificationProvider provider;

    setUp(() {
      // NotificationProvider uses ApiService.dio which is static.
      // This is hard to mock without refactoring ApiService or using a library like get_it.
      // However, addRealTimeNotification doesn't use Dio.
      provider = NotificationProvider();
    });

    test('addRealTimeNotification should increment unreadCount', () {
      final initialCount = provider.unreadCount;
      provider.addRealTimeNotification({
        'type': 'message',
        'content': 'Test notification',
      });

      expect(provider.unreadCount, initialCount + 1);
      expect(provider.notifications.length, 1);
    });
  });
}
