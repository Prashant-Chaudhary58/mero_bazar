import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

void main() {
  late FavoriteProvider provider;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_favorite_test');
    Hive.init(tempDir.path);
    // Register adapter if not already registered (Hive throws if already registered, but in tests it's usually fresh)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    provider = FavoriteProvider();
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('FavoriteProvider Unit Tests', () {
    test('should toggle favorite status', () async {
      final seller = UserModel(
        id: '1',
        fullName: 'Test Seller',
        role: 'seller',
        phone: '1234567890',
      );

      // Wait for initialization (FavoriteProvider calls _loadFavorites in constructor)
      // Since it's async in constructor, we might need a small delay or check
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.isFavorite('1'), false);

      await provider.toggleFavorite(seller);
      expect(provider.isFavorite('1'), true);

      await provider.toggleFavorite(seller);
      expect(provider.isFavorite('1'), false);
    });
  });
}
