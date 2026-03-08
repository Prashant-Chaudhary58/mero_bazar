import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  ReviewModel({
    super.id,
    required super.title,
    required super.rating,
    required super.text,
    super.userName,
    super.userId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'],
      title: json['title'] ?? '',
      rating: (json['rating'] as num).toDouble(),
      text: json['text'] ?? '',
      userName: json['user'] is Map ? json['user']['fullName'] : 'Anonymous',
      userId: json['user'] is Map ? json['user']['_id'] : json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'rating': rating, 'text': text};
  }
}
