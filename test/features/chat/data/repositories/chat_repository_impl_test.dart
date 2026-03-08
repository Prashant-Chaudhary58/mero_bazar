import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:mero_bazar/features/chat/data/models/chat_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mero_bazar/features/chat/data/datasources/chat_remote_datasource.dart';

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late ChatRepositoryImpl repository;
  late MockChatRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(mockRemoteDataSource);
    registerFallbackValue(
      MessageModel(id: '', chat: '', text: '', createdAt: DateTime.now()),
    );
  });

  group('ChatRepositoryImpl Unit Tests', () {
    test('should get chats from remote datasource', () async {
      final chats = [ChatModel(id: '1', updatedAt: DateTime.now())];
      when(
        () => mockRemoteDataSource.getChats(),
      ).thenAnswer((_) async => chats);

      final result = await repository.getChats();

      expect(result.first.id, chats.first.id);
      verify(() => mockRemoteDataSource.getChats()).called(1);
    });

    test('should send message via remote datasource', () async {
      final message = MessageModel(
        id: '1',
        chat: 'c1',
        text: 'Hi',
        createdAt: DateTime.now(),
      );
      when(
        () => mockRemoteDataSource.sendMessage(any(), any()),
      ).thenAnswer((_) async => message);

      final result = await repository.sendMessage('c1', 'Hi');

      expect(result.id, message.id);
      verify(() => mockRemoteDataSource.sendMessage('c1', 'Hi')).called(1);
    });
  });
}
