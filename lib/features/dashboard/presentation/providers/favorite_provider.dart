import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/features/notifications/presentation/providers/notification_provider.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';

class FavoriteProvider extends ChangeNotifier {
  static const String _boxName = 'favorite_sellers';
  List<UserModel> _favorites = [];

  List<UserModel> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final box = await Hive.openBox<UserModel>(_boxName);
    _favorites = box.values.toList();
    notifyListeners();
  }

  bool isFavorite(String? sellerId) {
    if (sellerId == null) return false;
    return _favorites.any((seller) => seller.id == sellerId);
  }

  Future<void> toggleFavorite(
    UserModel seller, {
    NotificationProvider? notificationProvider,
    UserEntity? currentUser,
  }) async {
    final box = await Hive.openBox<UserModel>(_boxName);
    final index = _favorites.indexWhere((s) => s.id == seller.id);

    if (index != -1) {
      // Remove from favorites
      _favorites.removeAt(index);
      await box.deleteAt(index);
    } else {
      // Add to favorites
      _favorites.add(seller);
      await box.add(seller);

      // Trigger notification
      if (notificationProvider != null && currentUser != null) {
        notificationProvider.sendFavoriteNotification(seller.id!, currentUser);
      }
    }
    notifyListeners();
  }

  Future<void> removeFavorite(String sellerId) async {
    final box = await Hive.openBox<UserModel>(_boxName);
    final index = _favorites.indexWhere((s) => s.id == sellerId);

    if (index != -1) {
      _favorites.removeAt(index);
      await box.deleteAt(index);
      notifyListeners();
    }
  }
}
