import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // App Logo
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: const AssetImage("assets/images/logo.jpg"),
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Your role",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 30),

            // Seller & Buyer icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset("assets/images/farmer.png"),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Seller",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset("assets/images/buyer.png"),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Buyer",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),

            const Text(
              "Join Us",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),

            const SizedBox(height: 8),

            const Text(
              "Shop Green, Live Green.",
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
