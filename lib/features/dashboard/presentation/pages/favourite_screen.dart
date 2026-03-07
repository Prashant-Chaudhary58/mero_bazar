import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/favorite_provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () {
            context.read<DashboardProvider>().setSelectedIndex(0);
          },
        ),
        title: const Text(
          "Favorite Sellers",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No favorite sellers yet",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final seller = provider.favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        (seller.image != null && seller.image != 'no-photo.jpg')
                        ? CachedNetworkImageProvider(
                            ApiService.getImageUrl(seller.image!, 'buyer'),
                          ) // assuming images are in profile
                        : const AssetImage('assets/images/logo.jpg')
                              as ImageProvider,
                  ),
                  title: Text(
                    seller.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    seller.phone,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => provider.removeFavorite(seller.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
