import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/review_entity.dart';
import 'dart:io';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts({
    double? lat,
    double? lng,
    double? radius,
  });
  Future<ProductEntity> getProduct(String id);
  Future<ProductEntity> createProduct(ProductEntity product, File? imageFile);
  Future<ProductEntity> updateProduct(
    String id,
    ProductEntity product,
    File? imageFile,
  );
  Future<void> deleteProduct(String id);
  Future<List<ReviewEntity>> getReviews(String productId);
  Future<ReviewEntity> addReview(
    String productId,
    String title,
    int rating,
    String text,
  );
  Future<List<ProductEntity>> getMyProducts();

  // Admin Methods
  Future<Map<String, dynamic>> getStats();
  Future<List<ProductEntity>> getPendingProducts();
  Future<void> verifyProduct(String id);
  Future<void> denyProduct(String id);
}
