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
                ); 
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _getUserImage(user),
                child: (user?.image == null)
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
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

  ImageProvider? _getUserImage(dynamic user) {
    if (user?.image == null) return null;
    if (user.image.startsWith('assets')) {
      return AssetImage(user.image);
    }
    return CachedNetworkImageProvider(
      ApiService.getImageUrl(user.image, user.role ?? 'buyer'),
    );
  }
}
