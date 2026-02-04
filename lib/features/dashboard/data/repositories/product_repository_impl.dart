import 'dart:io';
import '../../domain/entities/product_entity.dart';
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
}
