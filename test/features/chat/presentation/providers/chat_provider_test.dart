import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/chat/presentation/providers/chat_provider.dart';
import 'package:mero_bazar/features/chat/domain/repositories/chat_repository.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  group('ChatProvider Unit Tests', () {
    late ChatProvider chatProvider;
    late MockChatRepository mockRepo;

    setUp(() {
      mockRepo = MockChatRepository();
      chatProvider = ChatProvider(mockRepo);
    });

    test('clearUnreadCount should reset count to 0', () {
      // Manual internal access or via mock logic if possible
      // Actually, we can just call it and check.
      chatProvider.clearUnreadCount();
      expect(chatProvider.unreadMessagesCount, 0);
    });
  });
}
