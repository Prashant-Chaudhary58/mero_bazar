class ReviewEntity {
  final String? id;
  final String title;
  final double rating;
  final String text;
  final String? userName;
  final String? userId;

  ReviewEntity({
    this.id,
    required this.title,
    required this.rating,
    required this.text,
    this.userName,
    this.userId,
  });
}
