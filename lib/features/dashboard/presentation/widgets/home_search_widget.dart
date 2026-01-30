import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final user = userProvider.user;

            return GestureDetector(
              onTap: () {
                context.read<DashboardProvider>().setSelectedIndex(
                  3,
                ); // Profile tab
              },
              child: _buildProfileAvatar(user),
            );
          },
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Icon(Icons.notifications, color: Colors.green, size: 28),
      ],
    );
  }

  Widget _buildProfileAvatar(dynamic user) {
    const double radius = 20;

    if (user?.image == null || user?.image == 'no-photo.jpg') {
      return const CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      );
    }

    if (user!.image!.startsWith('assets')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(user.image!),
        backgroundColor: Colors.transparent,
      );
    }

    // Server Image with robust caching
    final imageUrl = ApiService.getImageUrl(user.image, user.role ?? 'buyer');

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
        backgroundColor: Colors.transparent,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => const CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}
