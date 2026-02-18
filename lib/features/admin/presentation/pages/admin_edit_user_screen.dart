import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/data/models/user_model.dart';
import 'package:mero_bazar/features/auth/domain/entities/user_entity.dart';
import 'package:mero_bazar/features/dashboard/presentation/providers/admin_provider.dart';
import 'package:mero_bazar/core/services/api_service.dart';

class AdminEditUserScreen extends StatefulWidget {
  final UserEntity? user;

  const AdminEditUserScreen({super.key, this.user});

  @override
  State<AdminEditUserScreen> createState() => _AdminEditUserScreenState();
}

class _AdminEditUserScreenState extends State<AdminEditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;

  String _role = 'buyer';
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    _passwordController = TextEditingController();
    _addressController = TextEditingController(
      text: widget.user?.address ?? '',
    );
    _cityController = TextEditingController(text: widget.user?.city ?? '');
    _role = widget.user?.role ?? 'buyer';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    final user = UserModel(
      id: widget.user?.id ?? '',
      fullName: _nameController.text,
      phone: _phoneController.text,
      role: _role,
      address: _addressController.text,
      city: _cityController.text,
      // Default or empty for other fields not in form
      district: widget.user?.district ?? '',
      province: widget.user?.province ?? '',
      email: widget.user?.email ?? '',
      image: widget.user?.image ?? 'no-photo.jpg',
    );

    try {
      if (widget.user == null) {
        // Create
        if (_passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password is required for new users")),
          );
          return;
        }
        await context.read<AdminProvider>().addUser(
          user,
          _passwordController.text,
          _imageFile,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User created successfully")),
          );
          Navigator.pop(context);
        }
      } else {
        // Update
        await context.read<AdminProvider>().editUser(
          widget.user!.id!,
          user,
          _imageFile,
          password: _passwordController.text.isNotEmpty
              ? _passwordController.text
              : null,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User updated successfully")),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit User" : "Add User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (isEditing &&
                              widget.user!.image != null &&
                              widget.user!.image != 'no-photo.jpg')
                        ? NetworkImage(
                                ApiService.getImageUrl(
                                  widget.user!.image,
                                  'users',
                                ),
                              )
                              as ImageProvider
                        : null,
                    child:
                        (_imageFile == null &&
                            (!isEditing ||
                                widget.user!.image == null ||
                                widget.user!.image == 'no-photo.jpg'))
                        ? const Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Phone is required" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: isEditing
                      ? "Password (leave empty to keep current)"
                      : "Password",
                  border: const OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _role,
                decoration: const InputDecoration(
                  labelText: "Role",
                  border: OutlineInputBorder(),
                ),
                items: ['buyer', 'seller', 'admin'].map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _role = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: context.watch<AdminProvider>().isLoading
                      ? null
                      : _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B7321),
                    foregroundColor: Colors.white,
                  ),
                  child: context.watch<AdminProvider>().isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? "Update User" : "Create User"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
