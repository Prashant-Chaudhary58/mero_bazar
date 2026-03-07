import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/product_provider.dart';
import 'package:mero_bazar/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

import 'package:mero_bazar/features/notifications/presentation/providers/notification_provider.dart';
import '../widgets/category_widget.dart';
import '../widgets/home_banner_widget.dart';
import '../widgets/home_search_widget.dart';
import '../widgets/product_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _userLat;
  double? _userLng;
  String _selectedCategory = "All";
  String _searchQuery = "";

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime? _lastShake;

  final List<Map<String, String>> _categories = [
    {"name": "All", "value": "All"},
    {"name": "Vegetables (तरकारी)", "value": "Vegetables"},
    {"name": "Fruits (फलफूल)", "value": "Fruits"},
    {"name": "Grains (अन्न)", "value": "Grains"},
    {"name": "Others (अन्य)", "value": "Others"},
  ];

  @override
  void initState() {
    super.initState();
    _fetchProductsWithLocation();

    // Listen to accelerometer events for Shake-to-Refresh
    _accelerometerSubscription = accelerometerEvents.listen((
      AccelerometerEvent event,
    ) {
      double gX = event.x / 9.80665;
      double gY = event.y / 9.80665;
      double gZ = event.z / 9.80665;

      // Calculate total G-force
      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      // Threshold around 2.5G usually works well for intentional shakes
      if (gForce > 2.5) {
        final now = DateTime.now();
        if (_lastShake == null ||
            now.difference(_lastShake!) > const Duration(seconds: 2)) {
          _lastShake = now;

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Shake detected! Refreshing marketplace..."),
                duration: Duration(seconds: 2),
              ),
            );
          }
          _fetchProductsWithLocation();
        }
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchProductsWithLocation() async {
    final productProvider = context.read<ProductProvider>();
    double? lat;
    double? lng;

    try {
      final position = await LocationService.getCurrentPosition();
      lat = position.latitude;
      lat = position.latitude;
      lng = position.longitude;

      if (mounted) {
        setState(() {
          _userLat = lat;
          _userLng = lng;
        });
      }
      if (mounted) {
        setState(() {
          _userLat = lat;
          _userLng = lng;
        });
      }
      // to store this location in UserProvider for global access  #for future use
    } catch (e) {
      // Handle permission error or service disabled
      print("Location error in Home: $e");
    }

    productProvider.fetchProducts(lat: lat, lng: lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EE),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchProductsWithLocation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeSearchWidget(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const HomeBannerWidget(),
                const SizedBox(height: 24),
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((cat) {
                      return CategoryWidget(
                        title: cat["name"]!,
                        isSelected: _selectedCategory == cat["value"],
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat["value"]!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                Consumer<ProductProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.error != null) {
                      return Center(child: Text('Error: ${provider.error}'));
                    }

                    if (provider.products.isEmpty) {
                      return const Center(
                        child: Text('No products found nearby'),
                      );
                    }

                    final allProducts = provider.products;
                    final filteredProducts = allProducts.where((p) {
                      final matchesCategory =
                          _selectedCategory == "All" ||
                          p.category == _selectedCategory;
                      final matchesSearch = p.name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );
                      return matchesCategory && matchesSearch;
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: Text('No products found in this category'),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        if (_userLat != null &&
                            _userLng != null &&
                            product.sellerLat != null &&
                            product.sellerLng != null) {
                          final dist =
                              Geolocator.distanceBetween(
                                _userLat!,
                                _userLng!,
                                product.sellerLat!,
                                product.sellerLng!,
                              ) /
                              1000;
                          print(
                            "Distance Debug: Buyer($_userLat, $_userLng) vs Seller(${product.name}: ${product.sellerLat}, ${product.sellerLng}) = $dist km",
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: {
                                'product':
                                    product, // Pass the entire object if possible, or individual fields
                                'id': product.id,
                                'name': product.name,
                                'description': product.description,
                                'category': product.category,
                                'quantity': product.quantity,
                                'image': product.image,
                                'price': product.price.toString(),
                                'isEditable': false,
                                'sellerId': product.seller,
                                'sellerLat': product.sellerLat,
                                'sellerLng': product.sellerLng,
                                'sellerPhone': product.sellerPhone,
                              },
                            );
                          },
                          child: Consumer<FavoriteProvider>(
                            builder: (context, favProvider, _) {
                              return ProductCardWidget(
                                name: product.name,
                                image: product.image ?? '',
                                rating: 0.0,
                                price: product.price.toInt(),
                                isFavorite: favProvider.isFavorite(
                                  product.seller,
                                ),
                                distance:
                                    (_userLat != null &&
                                        _userLng != null &&
                                        product.sellerLat != null &&
                                        product.sellerLng != null)
                                    ? "${(Geolocator.distanceBetween(_userLat!, _userLng!, product.sellerLat!, product.sellerLng!) / 1000).toStringAsFixed(1)} km"
                                    : null,
                                onFavoriteTap: () {
                                  if (product.seller != null) {
                                    favProvider.toggleFavorite(
                                      UserModel(
                                        id: product.seller,
                                        fullName:
                                            product.sellerName ??
                                            "Unknown Seller",
                                        phone: product.sellerPhone ?? "",
                                        image: product.sellerImage,
                                        role: 'seller',
                                      ),
                                      notificationProvider: context
                                          .read<NotificationProvider>(),
                                      currentUser: context
                                          .read<UserProvider>()
                                          .user,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Seller information not available",
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
