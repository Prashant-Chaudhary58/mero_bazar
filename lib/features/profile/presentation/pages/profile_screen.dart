import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/core/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mero_bazar/core/services/api_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () {
          },
        ),
        centerTitle: true,
        title: const Text(
          "My Account",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Profile Card
            Material(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Builder(
                            builder: (context) {
                              final user = userProvider.user;

                              if (user?.image == null ||
                                  user?.image == 'no-photo.jpg') {
                                return const CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(
                                    "assets/images/logo.jpg",
                                  ),
                                  backgroundColor: Colors.transparent,
                                );
                              }

                              if (user!.image!.startsWith('assets')) {
                                return CircleAvatar(
                                  radius: 35,
                                  backgroundImage: AssetImage(user.image!),
                                  backgroundColor: Colors.transparent,
                                );
                              }

                              if (user.image!.startsWith('/data') ||
                                  user.image!.startsWith('/storage')) {
                                return CircleAvatar(
                                  radius: 35,
                                  backgroundImage: FileImage(File(user.image!)),
                                  backgroundColor: Colors.transparent,
                                );
                              }

                              // Server Image
                              final imageUrl = ApiService.getImageUrl(
                                user.image,
                                user.role ?? 'buyer',
                              );

                              return CachedNetworkImage(
                                imageUrl: imageUrl,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: imageProvider,
                                      backgroundColor: Colors.transparent,
                                    ),
                                placeholder: (context, url) => CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                        "assets/images/logo.jpg",
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                              );
                            },
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, ${userProvider.user?.fullName ?? 'User'}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "view & edit your profile",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // My Listings Option (Only for Sellers)
            if (userProvider.user?.role == 'seller')
              Material(
                color: Colors.white,
                child: ListTile(
                  title: const Text(
                    "My Listing",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/my-listings');
                  },
                ),
              ),

            if (userProvider.user?.role == 'seller') const SizedBox(height: 10),

            // Language Option
            Material(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  "Language",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
                onTap: () {
                  // Handle language selection
                },
              ),
            ),

            const SizedBox(height: 10),

            // Logout Option
            Material(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                leading: const Icon(Icons.logout, color: Colors.red),
                onTap: () async {
                  // Logout Logic
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    await AuthService.clearSession();
                    if (context.mounted) {
                      context.read<UserProvider>().clearUser();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
