import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.category,
    required super.quantity,
    super.image,
    super.seller,
    super.sellerLat,
    super.sellerLng,
    super.sellerPhone,
    super.averageRating = 0.0,
    super.numOfReviews = 0,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      category: json['category'],
      quantity: json['quantity']?.toString() ?? '0',
      image: json['image'],
      seller: json['seller'] is Map ? json['seller']['_id'] : json['seller'],
      sellerLat: (json['seller'] is Map && json['seller']['location'] != null)
          ? (json['seller']['location']['coordinates'][1] as num?)?.toDouble()
          : null,
      sellerLng: (json['seller'] is Map && json['seller']['location'] != null)
          ? (json['seller']['location']['coordinates'][0] as num?)?.toDouble()
          : null,
      sellerPhone: (json['seller'] is Map) ? json['seller']['phone'] : null,
      averageRating: json['averageRating'] ?? 0.0,
      numOfReviews: json['numOfReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'quantity': quantity,
      'image': image,
      // 'seller': seller, // Typically not sent on creation
    };
  }
}
