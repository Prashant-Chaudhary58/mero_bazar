class NotificationModel {
  final String id;
  final String recipient;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String type;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.recipient,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.type,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'],
      recipient: json['recipient'] is Map
          ? json['recipient']['_id']
          : json['recipient'],
      senderId: json['sender'] is Map ? json['sender']['_id'] : json['sender'],
      senderName: json['sender'] is Map
          ? (json['sender']['fullName'] ?? 'User')
          : 'User',
      senderImage: json['sender'] is Map ? json['sender']['image'] : null,
      type: json['type'],
      content: json['content'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
