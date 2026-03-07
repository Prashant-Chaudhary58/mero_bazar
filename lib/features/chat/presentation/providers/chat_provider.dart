import 'package:flutter/material.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;

  List<ChatEntity> _chats = [];
  List<MessageEntity> _currentMessages = [];
  bool _isLoading = false;
  String? _error;

  IO.Socket? _socket;
  String? _currentChatId;

  UserEntity? _currentUser;
  UserEntity? get user => _currentUser;

  List<ChatEntity> get chats => _chats;
  List<MessageEntity> get currentMessages => _currentMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ChatProvider(this._chatRepository);

  void initSocket(UserEntity? user) {
    _currentUser = user;
    if (user == null) return;

    // Configure socket url based on ApiService
    String socketUrl = ApiService.baseUrl.replaceFirst('api/v1', '');
    socketUrl = socketUrl.replaceAll('/api', '');

    _socket = IO.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket?.connect();

    _socket?.onConnect((_) {
      print('Socket connected');
      _socket?.emit('setup', user.id);
    });

    _socket?.on('connected', (_) => print('User setup completed'));

    _socket?.on('message received', (newMessage) {
      if (newMessage != null) {
        final messageEntity = MessageEntity(
          id: newMessage['_id'],
          chat: newMessage['chat'] is Map
              ? newMessage['chat']['_id']
              : newMessage['chat'],
          sender: newMessage['sender'],
          text: newMessage['text'],
          createdAt: DateTime.parse(newMessage['createdAt']),
        );

        if (_currentChatId == messageEntity.chat) {
          _currentMessages.add(messageEntity);
          notifyListeners();
        } else {
          // New message for another chat, perhaps show notification or update chat list
          fetchChats();
        }
      }
    });

    _socket?.onDisconnect((_) => print('Socket disconnected'));
  }

  void joinChat(String chatId) {
    _currentChatId = chatId;
    _socket?.emit('join chat', chatId);
  }

  void leaveChat() {
    if (_currentChatId != null) {
      // No specific leave emit logic if not configured, but we can clear local state
      _currentChatId = null;
    }
  }

  void disconnectSocket() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  Future<void> fetchChats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _chats = await _chatRepository.getChats();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMessages(String chatId) async {
    _isLoading = true;
    _error = null;
    _currentMessages = [];
    notifyListeners();

    try {
      _currentMessages = await _chatRepository.getMessages(chatId);
      joinChat(chatId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ChatEntity?> createOrGetChat(String receiverId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final chat = await _chatRepository.createOrGetChat(receiverId);
      // Optional: add to list if not exists
      if (!_chats.any((c) => c.id == chat.id)) {
        _chats.insert(0, chat);
      }
      return chat;
    } catch (e) {
      _error = e.toString();
      rethrow; // Propagate error back to the UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String chatId, String text) async {
    try {
      final message = await _chatRepository.sendMessage(chatId, text);
      _currentMessages.add(message);
      notifyListeners();

      // Find chat safely
      final currentChat = _chats.firstWhere(
        (c) => c.id == chatId,
        orElse: () => _chats.isNotEmpty
            ? _chats.first
            : ChatEntity(id: chatId, updatedAt: DateTime.now()),
      );

      final participants = currentChat.otherParticipant != null
          ? [currentChat.otherParticipant!['_id']]
          : [];

      // Emit through socket
      final msgMap = {
        '_id': message.id,
        'chat': {
          '_id': message.chat,
          'participants': participants,
        }, // minimal payload matching expected backend emit
        'sender': message.sender,
        'text': message.text,
        'createdAt': message.createdAt.toIso8601String(),
      };

      _socket?.emit('new message', msgMap);

      // Update local chat list last message
      fetchChats();
    } catch (e) {
      print('Failed to send message: $e');
    }
  }
}
