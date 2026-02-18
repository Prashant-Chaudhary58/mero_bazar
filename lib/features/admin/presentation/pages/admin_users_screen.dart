import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/admin_provider.dart';
import 'package:mero_bazar/features/admin/presentation/pages/admin_edit_user_screen.dart';
import 'package:mero_bazar/core/services/api_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AdminProvider>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminEditUserScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4B7321),
        child: const Icon(Icons.add),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text("Error: ${provider.error}"));
          }

          if (provider.users.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.builder(
            itemCount: provider.users.length,
            itemBuilder: (context, index) {
              final user = provider.users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                      user.image != null && user.image != 'no-photo.jpg'
                      ? NetworkImage(
                          ApiService.getImageUrl(user.image, 'users'),
                        )
                      : null,
                  child: (user.image == null || user.image == 'no-photo.jpg')
                      ? Text(user.fullName[0].toUpperCase())
                      : null,
                ),
                title: Text(user.fullName),
                subtitle: Text("${user.role} • ${user.phone}"),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Text("Edit")),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminEditUserScreen(user: user),
                        ),
                      );
                    } else if (value == 'delete') {
                      _confirmDelete(context, user.id!);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AdminProvider>().deleteUser(userId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
