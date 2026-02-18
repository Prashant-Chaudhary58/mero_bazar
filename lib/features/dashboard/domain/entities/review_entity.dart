class ReviewEntity {
  final String? id;
  final double rating;
  final String text;
  final String? userName;
  final String? userId;

  ReviewEntity({
    this.id,
    required this.rating,
    required this.text,
    this.userName,
    this.userId,
  });
}
