import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/notifications/data/models/notification_model.dart';

void main() {
  group('NotificationModel Extended Unit Tests', () {
    test('should return a valid model from JSON', () {
      final json = {
        '_id': '1',
        'recipient': 'user1',
        'sender': {'_id': 'user2', 'fullName': 'Sender', 'image': 'img.jpg'},
        'type': 'message',
        'content': 'Hello',
        'isRead': false,
        'createdAt': '2026-03-08T00:00:00.000Z',
      };

      final model = NotificationModel.fromJson(json);

      expect(model.id, '1');
      expect(model.senderName, 'Sender');
      expect(model.senderImage, 'img.jpg');
    });

    test('should handle flat sender field', () {
      final json = {
        '_id': '1',
        'recipient': 'user1',
        'sender': 'user2',
        'type': 'message',
        'content': 'Hello',
        'isRead': false,
        'createdAt': '2026-03-08T00:00:00.000Z',
      };
      final model = NotificationModel.fromJson(json);
      expect(model.senderId, 'user2');
      expect(model.senderName, 'User');
    });
  });
}
