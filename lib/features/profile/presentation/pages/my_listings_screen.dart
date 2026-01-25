import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  List<ProductEntity> _myProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final repo = context.read<ProductRepositoryImpl>();
      final currentUser = context.read<UserProvider>().user;

      if (currentUser == null) return;

      final allProducts = await repo.getAllProducts();
      // Filter products by current seller ID
      // Assuming product.seller matches user.id (which is _id from backend)
      // Note: Backend might populate seller as an object or send ID string.
      // ProductModel logic: seller: json['seller'] is Map ? json['seller']['_id'] : json['seller']
      // So product.seller should be the ID string.

      final myProducts = allProducts
          .where((p) => p.seller == currentUser.id)
          .toList();

      if (mounted) {
        setState(() {
          _myProducts = myProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load listings: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "My Listing",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _myProducts.isEmpty
          ? const Center(child: Text("No products found. Add one!"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: _myProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75, // Adjust based on card height
                ),
                itemBuilder: (context, index) {
                  final item = _myProducts[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/product-details',
                        arguments: {
                          'name': item.name,
                          'price': "Rs. ${item.price}",
                          'description': item.description,
                          'quantity': item.quantity,
                          'image': item.image, // Pass server filename
                          'isEditable': true,
                          // Pass other details if needed
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Section
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child:
                                    (item.image != null &&
                                        item.image != 'no-photo.jpg')
                                    ? Image.network(
                                        // Use the standard product image path or role-based check?
                                        // Images uploaded via 'add product' go to /uploads/products/
                                        "http://172.18.118.197:5001/uploads/products/${item.image}",
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      )
                                    : Image.asset(
                                        "assets/images/logo.jpg",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),

                          // Details Section
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Rs. ${item.price}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Re-fetch after coming back from add product
          Navigator.pushNamed(
            context,
            '/product-details',
            arguments: {'isEditable': true, 'isNew': true},
          ).then((_) => _fetchProducts());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
