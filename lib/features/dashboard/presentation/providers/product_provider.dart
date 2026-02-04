import 'package:flutter/material.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepositoryImpl repository;

  List<ProductEntity> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductProvider(this.repository);

  List<ProductEntity> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts({double? lat, double? lng, double? radius}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await repository.getAllProducts(
        lat: lat,
        lng: lng,
        radius: radius,
      );
      print("Fetched ${_products.length} products");
    } catch (e) {
      _error = e.toString();
      print("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
