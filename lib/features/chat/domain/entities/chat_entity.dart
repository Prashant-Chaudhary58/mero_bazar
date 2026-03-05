class ChatEntity {
  final String id;
  final Map<String, dynamic>? otherParticipant;
  final Map<String, dynamic>? lastMessage;
  final DateTime updatedAt;

  ChatEntity({
    required this.id,
    this.otherParticipant,
    this.lastMessage,
    required this.updatedAt,
  });
}

class MessageEntity {
  final String id;
  final String chat;
  final Map<String, dynamic>? sender;
  final String text;
  final DateTime createdAt;

  MessageEntity({
    required this.id,
    required this.chat,
    this.sender,
    required this.text,
    required this.createdAt,
  });
}
