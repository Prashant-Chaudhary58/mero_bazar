import 'package:dio/dio.dart';
import '../../domain/entities/product_entity.dart';
import '../models/product_model.dart';
import 'dart:io';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts({
    double? lat,
    double? lng,
    double? radius,
  });
  Future<ProductModel> getProduct(String id);
  Future<ProductModel> createProduct(ProductEntity product, File? imageFile);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getAllProducts({
    double? lat,
    double? lng,
    double? radius,
  }) async {
    final queryParams = <String, dynamic>{};
    if (lat != null) queryParams['lat'] = lat;
    if (lng != null) queryParams['lng'] = lng;
    if (radius != null) queryParams['radius'] = radius;

    final response = await dio.get('/products', queryParameters: queryParams);

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load products');
  }

  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await dio.get('/products/$id');

    if (response.statusCode == 200) {
      return ProductModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to load product');
  }

  @override
  Future<ProductModel> createProduct(
    ProductEntity product,
    File? imageFile,
  ) async {
    final Map<String, dynamic> fields = {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'category': product.category,
      'quantity': product.quantity,
    };

    FormData formData = FormData.fromMap(fields);

    if (imageFile != null) {
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ),
      );
    }

    final response = await dio.post('/products', data: formData);

    if (response.statusCode == 201) {
      return ProductModel.fromJson(response.data['data']);
    }
    throw Exception(response.data['error'] ?? 'Failed to create product');
  }
}
