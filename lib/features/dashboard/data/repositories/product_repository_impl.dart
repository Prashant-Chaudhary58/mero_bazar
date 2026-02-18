import 'dart:io';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProductEntity>> getAllProducts({
    double? lat,
    double? lng,
    double? radius,
  }) async {
    return await remoteDataSource.getAllProducts(
      lat: lat,
      lng: lng,
      radius: radius,
    );
  }

  @override
  Future<ProductEntity> getProduct(String id) async {
    return await remoteDataSource.getProduct(id);
  }

  @override
  Future<ProductEntity> createProduct(
    ProductEntity product,
    File? imageFile,
  ) async {
    return await remoteDataSource.createProduct(product, imageFile);
  }

  @override
  Future<ProductEntity> updateProduct(
    String id,
    ProductEntity product,
    File? imageFile,
  ) async {
    return await remoteDataSource.updateProduct(id, product, imageFile);
  }

  @override
  Future<void> deleteProduct(String id) async {
    return await remoteDataSource.deleteProduct(id);
  }

  @override
  Future<List<ReviewEntity>> getReviews(String productId) async {
    return await remoteDataSource.getReviews(productId);
  }

  @override
  Future<ReviewEntity> addReview(
    String productId,
    int rating,
    String text,
  ) async {
    return await remoteDataSource.addReview(productId, rating, text);
  }

  @override
  Future<List<ProductEntity>> getMyProducts() async {
    return await remoteDataSource.getMyProducts();
  }

  @override
  Future<Map<String, dynamic>> getStats() async {
    return await remoteDataSource.getStats();
  }

  @override
  Future<List<ProductEntity>> getPendingProducts() async {
    return await remoteDataSource.getPendingProducts();
  }

  @override
  Future<void> verifyProduct(String id) async {
    return await remoteDataSource.verifyProduct(id);
  }

  @override
  Future<void> denyProduct(String id) async {
    return await remoteDataSource.denyProduct(id);
  }
}
