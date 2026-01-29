import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'dart:io';

abstract class ProductRepository {
  Future<List<ProductEntity>> getAllProducts();
  Future<ProductEntity> getProduct(String id);
  Future<ProductEntity> createProduct(ProductEntity product, File? imageFile);
}
