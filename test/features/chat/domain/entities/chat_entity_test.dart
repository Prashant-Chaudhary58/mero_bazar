import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/chat/domain/entities/chat_entity.dart';

void main() {
  group('ChatEntity Unit Tests', () {
    test('should hold data correctly', () {
      final now = DateTime.now();
      final chat = ChatEntity(
        id: '1',
        otherParticipant: {'fullName': 'John', 'image': 'img.jpg'},
        lastMessage: {'content': 'Hi'},
        updatedAt: now,
      );

      expect(chat.id, '1');
      expect(chat.otherParticipant?['fullName'], 'John');
      expect(chat.lastMessage?['content'], 'Hi');
      expect(chat.updatedAt, now);
    });

    test('MessageEntity should hold data correctly', () {
      final now = DateTime.now();
      final msg = MessageEntity(
        id: 'm1',
        chat: '1',
        text: 'Hello',
        createdAt: now,
      );

      expect(msg.id, 'm1');
      expect(msg.text, 'Hello');
      expect(msg.createdAt, now);
    });
  });
}
