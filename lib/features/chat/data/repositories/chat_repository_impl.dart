import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatEntity>> getChats() async {
    return await remoteDataSource.getChats();
  }

  @override
  Future<List<MessageEntity>> getMessages(String chatId) async {
    return await remoteDataSource.getMessages(chatId);
  }

  @override
  Future<ChatEntity> createOrGetChat(String receiverId) async {
    return await remoteDataSource.createOrGetChat(receiverId);
  }

  @override
  Future<MessageEntity> sendMessage(String chatId, String text) async {
    return await remoteDataSource.sendMessage(chatId, text);
  }
}
