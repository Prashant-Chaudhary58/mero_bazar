import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/dashboard_provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:mero_bazar/core/services/auth_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:mero_bazar/core/providers/language_provider.dart';
import 'package:mero_bazar/l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () {
            context.read<DashboardProvider>().setSelectedIndex(0);
          },
        ),
        centerTitle: true,
        title: Text(
          l10n.myAccount,
          style: const TextStyle(
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
                              // Debugging: Print role to console
                              if (user != null) {
                                debugPrint(
                                  "DEBUG PROFILE: User Role = '${user.role}'",
                                );
                              }

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
                                user.role,
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
                              l10n.helloUser(
                                userProvider.user?.fullName ?? 'User',
                              ),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.viewEditProfile,
                              style: const TextStyle(
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
                  title: Text(
                    l10n.myListing,
                    style: const TextStyle(fontWeight: FontWeight.w600),
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

            // Admin Dashboard
            if ((userProvider.user?.role.toLowerCase() == 'admin') ||
                (userProvider.user?.isAdmin == true))
              Material(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    l10n.switchToAdmin,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/admin-dashboard');
                  },
                ),
              ),

            if ((userProvider.user?.role.toLowerCase() == 'admin') ||
                (userProvider.user?.isAdmin == true))
              const SizedBox(height: 10),

            // Language Option
            Material(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  l10n.language,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.watch<LanguageProvider>().locale.languageCode ==
                              'ne'
                          ? "Nepali"
                          : "English",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  ],
                ),
                onTap: () => _showLanguageDialog(context),
              ),
            ),

            const SizedBox(height: 10),

            // Logout Option
            Material(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  l10n.logout,
                  style: const TextStyle(
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
                      title: Text(l10n.logoutConfirmTitle),
                      content: Text(l10n.logoutConfirmMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            l10n.logout,
                            style: const TextStyle(color: Colors.red),
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
                        '/',
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

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final langProvider = context.read<LanguageProvider>();
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("English"),
                trailing: langProvider.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  langProvider.setLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Nepali (नेपाली)"),
                trailing: langProvider.locale.languageCode == 'ne'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  langProvider.setLanguage('ne');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
