import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class HomeSearchWidget extends StatelessWidget {
  const HomeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final user = userProvider.user;
            
            ImageProvider? image;
            if (user?.image != null) {
              if (user!.image!.startsWith('assets')) {
                image = AssetImage(user.image!);
              } 
              // Handle file path logic if needed in future
            }

            return CircleAvatar(
              radius: 20, 
              backgroundColor: Colors.grey,
              backgroundImage: image,
              child: image == null ? const Icon(Icons.person, color: Colors.white) : null,
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
        const Icon(Icons.notifications,
            color: Colors.green, size: 28),
      ],
    );
  }
}
