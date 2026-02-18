import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/product_provider.dart';
import 'package:mero_bazar/core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchProductsWithLocation();
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
                const HomeSearchWidget(),
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
                    children: const [
                      CategoryWidget(title: "All", isSelected: true),
                      CategoryWidget(title: "Vegetables (तरकारी)"),
                      CategoryWidget(title: "Fruits (फलफूल)"),
                    ],
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

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (context, index) {
                        final product = provider.products[index];
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
                          child: ProductCardWidget(
                            name: product.name,
                            image: product.image ?? '',
                            rating: 0.0,
                            price: product.price.toInt(),
                            distance:
                                (_userLat != null &&
                                    _userLng != null &&
                                    product.sellerLat != null &&
                                    product.sellerLng != null)
                                ? "${(Geolocator.distanceBetween(_userLat!, _userLng!, product.sellerLat!, product.sellerLng!) / 1000).toStringAsFixed(1)} km"
                                : null,
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
