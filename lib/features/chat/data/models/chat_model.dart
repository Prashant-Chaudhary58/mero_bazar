import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    super.otherParticipant,
    super.lastMessage,
    required super.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      otherParticipant: json['otherParticipant'] is Map
          ? json['otherParticipant']
          : (json['otherParticipant'] != null
                ? {'_id': json['otherParticipant']}
                : null),
      lastMessage: json['lastMessage'] is Map
          ? json['lastMessage']
          : (json['lastMessage'] != null ? {'_id': json['lastMessage']} : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.chat,
    super.sender,
    required super.text,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      chat: json['chat'] is Map ? json['chat']['_id'] : json['chat'],
      sender: json['sender'],
      text: json['text'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
