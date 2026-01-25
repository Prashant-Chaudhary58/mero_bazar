import 'package:flutter/material.dart';
import 'package:mero_bazar/features/profile/presentation/pages/profile_screen.dart';
import 'cart_screen.dart';
import 'favourite_screen.dart';
import 'home_screen.dart';

import 'package:flutter/services.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt;

  final List<Widget> _screens = const [
    HomeScreen(),
    CartScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  Future<void> _handleBackPress() async {
    final now = DateTime.now();
    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 5)) {
      // First press or timeout exceeded
      _lastPressedAt = now;
      // Do nothing visually, just start timer logic
      return;
    }

    // Second press within 5 seconds
    final shouldQuit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quit Mero Bazar?'),
        content: const Text('Do you want to exit the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (shouldQuit == true) {
      SystemNavigator.pop();
    } else {
      // Reset timer so next press is treated as first?
      // User said: "if no is clicked, I should be on the home page ( nothing should happen)"
      // Logic says just stay.
      _lastPressedAt =
          null; // Optional: Require another double tap? Or keep timing window?
      // Usually resetting makes sense so user doesn't accidentally quit on next single tap.
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return;
        }

        // On Home Screen
        await _handleBackPress();
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: (index) {
            setState(() => _selectedIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favourite",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
