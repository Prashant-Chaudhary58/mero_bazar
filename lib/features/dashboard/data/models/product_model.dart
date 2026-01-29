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
