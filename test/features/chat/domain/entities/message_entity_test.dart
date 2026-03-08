import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/chat/domain/entities/chat_entity.dart';

void main() {
  group('MessageEntity Unit Tests', () {
    test('should hold correct property values', () {
      final now = DateTime.now();
      final message = MessageEntity(
        id: 'msg1',
        chat: 'chat1',
        text: 'Hello',
        createdAt: now,
        sender: {'_id': 'user1', 'fullName': 'User One'},
      );

      expect(message.id, 'msg1');
      expect(message.chat, 'chat1');
      expect(message.text, 'Hello');
      expect(message.createdAt, now);
      expect(message.sender?['_id'], 'user1');
    });
  });
}
