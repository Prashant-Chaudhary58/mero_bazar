import 'package:flutter/material.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:geolocator/geolocator.dart';

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

      // Sort by distance if user location is available
      if (lat != null && lng != null) {
        _products.sort((a, b) {
          final latA = a.sellerLat;
          final lngA = a.sellerLng;
          final latB = b.sellerLat;
          final lngB = b.sellerLng;

          if (latA == null || lngA == null) return 1;
          if (latB == null || lngB == null) return -1;

          final distA = Geolocator.distanceBetween(lat, lng, latA, lngA);
          final distB = Geolocator.distanceBetween(lat, lng, latB, lngB);
          return distA.compareTo(distB);
        });
      }

      print("Fetched and sorted ${_products.length} products");
    } catch (e) {
      _error = e.toString();
      print("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
