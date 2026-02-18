class ProductEntity {
  final String? id;
  final String name;
  final String description;
  final num price;
  final String category;
  final String
  quantity; // Changed from countInStock (int) to quantity (String) for consistency with backend
  final String? image;
  final String? seller;
  final double? sellerLat;
  final double? sellerLng;
  final String? sellerPhone;
  final num averageRating;
  final int numOfReviews;
  final bool isVerified;

  ProductEntity({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
    this.image,
    this.seller,
    this.sellerLat,
    this.sellerLng,
    this.sellerPhone,
    this.averageRating = 0.0,
    this.numOfReviews = 0,
    this.isVerified = false,
  });
}
