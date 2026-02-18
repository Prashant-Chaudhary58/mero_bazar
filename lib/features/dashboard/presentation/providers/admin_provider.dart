import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:mero_bazar/features/dashboard/domain/repositories/product_repository.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/features/admin/domain/repositories/admin_repository.dart';

class AdminProvider with ChangeNotifier {
  final ProductRepository productRepository;
  final AdminRepository adminRepository;

  AdminProvider(this.productRepository, this.adminRepository);

  bool _isLoading = false;
  String? _error;
  List<ProductEntity> _pendingProducts = [];
  Map<String, dynamic>? _stats;
  List<UserEntity> _users = []; // Changed type from UserModel to UserEntity
  List<ProductEntity> _products = []; // Added _products list

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ProductEntity> get pendingProducts => _pendingProducts;
  Map<String, dynamic>? get stats => _stats;
  List<UserEntity> get users => _users; // Changed getter type
  List<ProductEntity> get products => _products; // Added products getter

  Future<void> fetchStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await productRepository.getStats();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPendingProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pendingProducts = await productRepository.getPendingProducts();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await adminRepository.getAllProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(
    String id,
    ProductEntity product,
    File? imageFile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await productRepository.updateProduct(id, product, imageFile);
      await fetchAllProducts(); // Refresh list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await adminRepository.getUsers();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(
    UserEntity user,
    String password,
    File? imageFile,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await adminRepository.createUser(user, password, imageFile);
      await fetchUsers(); // Refresh list
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editUser(
    String id,
    UserEntity user,
    File? imageFile, {
    String? password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await adminRepository.updateUser(id, user, imageFile, password: password);
      await fetchUsers(); // Refresh list
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await adminRepository.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyProduct(String id) async {
    try {
      await productRepository.verifyProduct(id);
      _pendingProducts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> denyProduct(String id) async {
    try {
      await productRepository.denyProduct(id);
      _pendingProducts.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await productRepository.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
