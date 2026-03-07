import 'package:dio/dio.dart';
import '../models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getMessages(String chatId);
  Future<ChatModel> createOrGetChat(String receiverId);
  Future<MessageModel> sendMessage(String chatId, String text);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;

  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ChatModel>> getChats() async {
    final response = await dio.get('/chats');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => ChatModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load chats');
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final response = await dio.get('/chats/$chatId/messages');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => MessageModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load messages');
  }

  @override
  Future<ChatModel> createOrGetChat(String receiverId) async {
    try {
      final response = await dio.post(
        '/chats',
        data: {'receiverId': receiverId},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ChatModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to create or get chat');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['error'] ?? 'Network Error: Failed to create chat',
      );
    }
  }

  @override
  Future<MessageModel> sendMessage(String chatId, String text) async {
    final response = await dio.post(
      '/chats/$chatId/messages',
      data: {'text': text},
    );
    if (response.statusCode == 201) {
      return MessageModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to send message');
  }
}
