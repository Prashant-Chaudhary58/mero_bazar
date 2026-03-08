import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import 'package:mero_bazar/features/profile/presentation/pages/profile_screen.dart';
import 'package:mero_bazar/features/chat/presentation/pages/chat_list_screen.dart';
import 'package:mero_bazar/features/chat/presentation/providers/chat_provider.dart';
import 'favourite_screen.dart';
import 'home_screen.dart';

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:mero_bazar/core/services/sensor_service.dart';
import 'package:mero_bazar/core/services/auth_service.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTime? _lastPressedAt;
  StreamSubscription? _shakeSubscription;

  @override
  void initState() {
    super.initState();
    _initShakeLogout();
  }

  void _initShakeLogout() {
    SensorService.listenToShake(() {
      if (mounted) {
        _onShakeDetected();
      }
    });
  }

  void _onShakeDetected() async {
    // Only trigger if user is logged in
    final userProvider = context.read<UserProvider>();
    if (userProvider.user == null) return;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shake Detected!'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await AuthService.clearSession();
      context.read<UserProvider>().clearUser();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  void dispose() {
    _shakeSubscription?.cancel();
    super.dispose();
  }

  final List<Widget> _screens = [
    HomeScreen(),
    ChatListScreen(),
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

        final dashboardProvider = context.read<DashboardProvider>();
        if (dashboardProvider.selectedIndex != 0) {
          dashboardProvider.setSelectedIndex(0);
          return;
        }

        // On Home Screen
        await _handleBackPress();
      },
      child: Scaffold(
        body: IndexedStack(
          index: context.watch<DashboardProvider>().selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: context.watch<DashboardProvider>().selectedIndex,
          selectedItemColor: Colors.green,
          onTap: (index) {
            context.read<DashboardProvider>().setSelectedIndex(index);
            if (index == 1) {
              // Clear chat badge on tab switch
              context.read<ChatProvider>().clearUnreadCount();
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Consumer<ChatProvider>(
                builder: (context, chatProvider, _) => Badge.count(
                  count: chatProvider.unreadMessagesCount,
                  isLabelVisible: chatProvider.unreadMessagesCount > 0,
                  child: const Icon(Icons.chat),
                ),
              ),
              label: "Chat",
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
