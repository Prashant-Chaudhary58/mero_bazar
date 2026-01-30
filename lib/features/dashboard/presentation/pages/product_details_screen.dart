import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mero_bazar/core/services/api_service.dart';

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
    _assetImage = args?['image'] ?? "assets/images/logo.jpg";

    // Initialize controllers with passed data or defaults
    if (_isNew) {
      _titleController = TextEditingController();
      _priceController = TextEditingController();
      _descriptionController = TextEditingController();
      _quantityController = TextEditingController();
    } else {
      _titleController = TextEditingController(
        text: args?['name'] ?? "ताजा नेपाली आम 🥭",
      );
      _priceController = TextEditingController(
        text: args?['price'] ?? "Rs. 120/kg",
      );

      const String defaultDescription =
          "प्रजाति: मालदह, दशहरी, कलकत्ते, बम्बै, सिन्धु, अल्फान्सो\n"
          "विशेषता: बारीबाट सिधै, पूर्ण पाकेको, रसिलो-मीठो, सुगन्धित, 200-600 ग्राम, कम रासायनिक, जैविक स्वाद\n"
          "गर्मीयामको राजा – एक टोकाइमै स्वर्ग!";

      _descriptionController = TextEditingController(
        text: args?['description'] ?? defaultDescription,
      );
      _quantityController = TextEditingController(
        text: args?['quantity']?.toString() ?? "500 kg",
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
    final productData = ProductEntity(
      name: _titleController.text,
      description: _descriptionController.text,
      price:
          num.tryParse(
            _priceController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0,
      category: "Vegetables", // TODO: Add Category Dropdown
      quantity: _quantityController.text,
    );

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = context.read<ProductRepositoryImpl>();
      if (_isNew) {
        await repo.createProduct(productData, _selectedImage);
      } else {
        // Handle update if repository supports it
        // For now, only createProduct logic is in the repo
        await repo.createProduct(productData, _selectedImage);
      }

      if (!mounted) return;
      Navigator.pop(context); // Pop loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product saved successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      Navigator.pop(context); // Pop screen
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save product: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _isEditable) {
          print("Auto-saving changes...");
          // Optional: call _saveChanges if needed on back
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
            onPressed: () {
              if (_isEditable) {
                _saveChanges();
              } else {
                Navigator.pop(context);
              }
            },
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
              )
            else
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.green),
                onPressed: () {},
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
                                    : CachedNetworkImage(
                                        imageUrl: ApiService.getImageUrl(
                                          _assetImage,
                                          "products",
                                        ),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 80,
                                                color: Colors.grey,
                                              ),
                                            ),
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
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
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
                    if (_isEditable)
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
                      )
                    else
                      Text(
                        _titleController.text,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Estimated Quantity
                    if (_isEditable)
                      TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: "Estimated Quantity (e.g. 500kg)",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.inventory,
                            color: Colors.green,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      )
                    else
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Available: ${_quantityController.text}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    // Description
                    if (_isEditable)
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      )
                    else
                      Text(
                        _descriptionController.text,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Price and Quantity Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_isEditable)
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Price",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          )
                        else
                          Text(
                            _priceController.text,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        if (!_isEditable)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.green,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (!_isEditable)
                      Row(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 24),
                          SizedBox(width: 8),
                          Text(
                            "4.5",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),

                    if (!_isEditable)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.check, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "100% Eco-Friendly",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),

                    if (!_isEditable)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Visit Farm",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A7C20),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Contact Farmer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
