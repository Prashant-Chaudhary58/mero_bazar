import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Controllers for editable fields
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  bool _isEditable = false;
  bool _isNew = false;
  File? _selectedImage;
  String? _assetImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve arguments safely
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _isEditable = args?['isEditable'] ?? false;
    _isNew = args?['isNew'] ?? false;
    _assetImage =
        args?['image'] ?? "assets/images/logo.jpg"; // Default fallback

    // Initialize controllers
    if (_isNew) {
      _titleController = TextEditingController();
      _priceController = TextEditingController();
      _descriptionController = TextEditingController();
      _quantityController = TextEditingController();
    } else {
      _titleController = TextEditingController(
        text: args?['name'] ?? "Product Name",
      );
      _priceController = TextEditingController(text: args?['price'] ?? "Rs. 0");
      _descriptionController = TextEditingController(
        text: args?['description'] ?? "Description...",
      );
      _quantityController = TextEditingController(
        text: args?['quantity']?.toString() ?? "0",
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? photo = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  setState(() {
                    _selectedImage = File(photo.path);
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() {
                    _selectedImage = File(image.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Price are required")),
      );
      return;
    }

    // Prepare entity
    final newProduct = ProductEntity(
      name: _titleController.text,
      description: _descriptionController.text,
      price:
          num.tryParse(
            _priceController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0,
      category: "Vegetables", // TODO: Add Category Dropdown
      quantity: _quantityController.text.isNotEmpty
          ? _quantityController.text
          : "0",
    );

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = context.read<ProductRepositoryImpl>();
      await repo.createProduct(newProduct, _selectedImage);

      if (!mounted) return;
      Navigator.pop(context); // Pop loading
      Navigator.pop(context); // Pop screen

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product added successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to add product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isNew
            ? const Text("Add Product", style: TextStyle(color: Colors.black))
            : null,
        centerTitle: true,
        actions: [
          if (_isEditable)
            IconButton(
              icon: const Icon(Icons.save, color: Colors.green),
              onPressed: _saveChanges,
              tooltip: "Save Changes",
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : (_assetImage != null
                            ? (_assetImage!.startsWith('assets')
                                  ? Image.asset(
                                      _assetImage!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.image,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    )
                                  : Image.network(
                                      "http://172.18.118.197:5001/uploads/products/$_assetImage",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ))
                            : const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              )),
                ),
                if (_isEditable)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.green,
                      onPressed: _pickImage,
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditable,
                  ),

                  const SizedBox(height: 16),

                  // Estimated Quantity
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: "Estimated Quantity (e.g. 500)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory, color: Colors.green),
                    ),
                    enabled: _isEditable,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    enabled: _isEditable,
                  ),

                  const SizedBox(height: 20),

                  // Price
                  TextFormField(
                    controller: _priceController,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      labelText: "Price (Rs.)",
                      border: OutlineInputBorder(),
                    ),
                    enabled: _isEditable,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
