import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access UserProvider globally for the widget
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () {
             // In dashboard tab, this might not do anything or switch tab.
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Builder(
                            builder: (context) {
                              final user = userProvider.user;
                              // Image Logic
                              ImageProvider? image;
                              if (user?.image != null) {
                                if (user!.image!.startsWith('assets')) {
                                  image = AssetImage(user.image!);
                                } else {
                                  image = FileImage(File(user.image!));
                                }
                              } else {
                                 image = const AssetImage("assets/images/logo.jpg"); // Fallback
                              }

                              return CircleAvatar(
                                radius: 35,
                                backgroundImage: image,
                                backgroundColor: Colors.grey.shade200,
                                child: null,
                              );
                            }
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                          )
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
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
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
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                  onTap: () {
                    Navigator.pushNamed(context, '/my-listings');
                  },
                ),
              ),

             if (userProvider.user?.role == 'seller')
               const SizedBox(height: 10),

            // Language Option
            Material(
              color: Colors.white,
              child: ListTile(
                title: const Text(
                  "Language",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                onTap: () {
                  // Handle language selection
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
