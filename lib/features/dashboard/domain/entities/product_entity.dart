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

  ProductEntity({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.quantity,
    this.image,
    this.seller,
  });
}
