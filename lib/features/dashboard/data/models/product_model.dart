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
    super.sellerName,
    super.sellerImage,
    super.sellerLat,
    super.sellerLng,
    super.sellerPhone,
    super.averageRating = 0.0,
    super.numOfReviews = 0,
    super.isVerified = false,
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
      sellerName: (json['seller'] is Map) ? json['seller']['fullName'] : null,
      sellerImage: (json['seller'] is Map) ? json['seller']['image'] : null,
      sellerLat: (json['seller'] is Map && json['seller']['lat'] != null)
          ? double.tryParse(json['seller']['lat'].toString())
          : null,
      sellerLng: (json['seller'] is Map && json['seller']['lng'] != null)
          ? double.tryParse(json['seller']['lng'].toString())
          : null,
      sellerPhone: (json['seller'] is Map) ? json['seller']['phone'] : null,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      numOfReviews: json['numOfReviews'] ?? 0,
      isVerified: json['isVerified'] ?? false,
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
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    String? category,
    String? quantity,
    String? image,
    String? seller,
    String? sellerName,
    String? sellerImage,
    double? sellerLat,
    double? sellerLng,
    String? sellerPhone,
    double? averageRating,
    int? numOfReviews,
    bool? isVerified,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      seller: seller ?? this.seller,
      sellerName: sellerName ?? this.sellerName,
      sellerImage: sellerImage ?? this.sellerImage,
      sellerLat: sellerLat ?? this.sellerLat,
      sellerLng: sellerLng ?? this.sellerLng,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      averageRating: averageRating ?? this.averageRating,
      numOfReviews: numOfReviews ?? this.numOfReviews,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
