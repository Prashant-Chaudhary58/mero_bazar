import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/dashboard/data/repositories/product_repository_impl.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/product_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:mero_bazar/core/services/location_service.dart';
import 'package:mero_bazar/features/dashboard/domain/entities/review_entity.dart';
import 'package:geolocator/geolocator.dart';

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

  String _selectedCategory = "Vegetables";
  final List<String> _categories = ["Vegetables", "Fruits", "Grains", "Others"];

  bool _isEditable = false;
  bool _isNew = false;
  File? _selectedImage;
  String? _assetImage;
  double? _sellerLat;
  double? _sellerLng;
  String? _sellerPhone;
  final ImagePicker _picker = ImagePicker();

  // Ratings
  List<ReviewEntity> _reviews = [];
  double _averageRating = 0.0;
  int _numOfReviews = 0;
  bool _isLoadingReviews = false;
  String? _productId;
  String? _distance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve arguments safely
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _isEditable = args?['isEditable'] ?? false;
    _isNew = args?['isNew'] ?? false;
    _assetImage = args?['image'] ?? "assets/images/logo.jpg";
    _sellerLat = args?['sellerLat'];
    _sellerLng = args?['sellerLng'];
    _sellerPhone = args?['sellerPhone'];
    _productId = args?['id'];

    // Initialize controllers with passed data or defaults
    if (_isNew) {
      _titleController = TextEditingController();
      _priceController = TextEditingController();
      _descriptionController = TextEditingController();
      _quantityController = TextEditingController();
    } else {
      _titleController = TextEditingController(
        text: args?['name'] ?? "No Name",
      );
      _priceController = TextEditingController(
        text: args?['price'] != null ? "Rs. ${args!['price']}/kg" : "Rs. 0/kg",
      );

      _descriptionController = TextEditingController(
        text: args?['description'] ?? "No description available.",
      );
      _quantityController = TextEditingController(
        text: args?['quantity']?.toString() ?? "Out of Stock",
      );

      if (args?['category'] != null &&
          _categories.contains(args!['category'])) {
        _selectedCategory = args['category'];
      }

      // Trigger distance calculation
      _calculateDistance();
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

  Future<void> _visitFarm() async {
    if (_sellerLat != null && _sellerLng != null) {
      await LocationService.launchMaps(_sellerLat!, _sellerLng!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seller location not available")),
      );
    }
  }

  Future<void> _contactSeller() async {
    if (_sellerPhone != null && _sellerPhone!.isNotEmpty) {
      await LocationService.launchDialer(_sellerPhone!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seller phone number not available")),
      );
    }
  }

  Future<void> _calculateDistance() async {
    if (_sellerLat == null || _sellerLng == null) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    try {
      Position userPosition = await Geolocator.getCurrentPosition();
      double distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        _sellerLat!,
        _sellerLng!,
      );

      setState(() {
        if (distanceInMeters < 1000) {
          _distance = "${distanceInMeters.toStringAsFixed(0)} m";
        } else {
          _distance = "${(distanceInMeters / 1000).toStringAsFixed(1)} km";
        }
      });
    } catch (e) {
      print("Error calculating distance: $e");
    }
  }

  Future<void> _fetchReviews() async {
    if (_productId == null) return;
    setState(() => _isLoadingReviews = true);

    try {
      final repo = context.read<ProductRepositoryImpl>();
      final reviews = await repo.getReviews(_productId!);
      setState(() {
        _reviews = reviews;
        _isLoadingReviews = false;
      });
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() => _isLoadingReviews = false);
    }
  }

  Future<void> _showAddReviewDialog() async {
    final TextEditingController reviewController = TextEditingController();
    int selectedRating = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Rate Product"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: reviewController,
                    decoration: const InputDecoration(
                      hintText: "Write a review...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (reviewController.text.isEmpty) return;
                    Navigator.pop(context);
                    await _addReview(selectedRating, reviewController.text);
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addReview(int rating, String text) async {
    if (_productId == null) return;

    try {
      final repo = context.read<ProductRepositoryImpl>();
      await repo.addReview(_productId!, rating, text);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Review submitted!")));
      _fetchReviews();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to submit review: $e")));
    }
  }

  Future<void> _confirmDelete() async {
    final curContext = context;
    showDialog(
      context: curContext,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteProduct();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct() async {
    if (_productId == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final repo = context.read<ProductRepositoryImpl>();
      await repo.deleteProduct(_productId!);

      if (!mounted) return;
      Navigator.pop(context); // Pop loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product deleted successfully"),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context); // Pop screen
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pop loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
    }
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
      category: _selectedCategory,
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
            if (_isEditable) ...[
              IconButton(
                icon: const Icon(Icons.save, color: Colors.green),
                onPressed: _saveChanges,
                tooltip: "Save Changes",
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: _confirmDelete,
                tooltip: "Delete Product",
              ),
            ] else
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

                    // Category Dropdown
                    if (_isEditable)
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: "Category",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category, color: Colors.green),
                        ),
                        items: _categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                      )
                    else
                      Row(
                        children: [
                          const Icon(
                            Icons.category,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Category: $_selectedCategory",
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
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            "$_averageRating ($_numOfReviews reviews)",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _showAddReviewDialog,
                            icon: const Icon(Icons.edit),
                            label: const Text("Write a Review"),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (!_isEditable) ...[
                      if (_isLoadingReviews)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (_reviews.isNotEmpty) ...[
                        const Text(
                          "Reviews",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _reviews.length > 3 ? 3 : _reviews.length,
                          itemBuilder: (context, index) {
                            final review = _reviews[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Text(review.userName?[0] ?? "U"),
                              ),
                              title: Text(review.userName ?? "Anonymous"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        starIndex < review.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 14,
                                        color: Colors.amber,
                                      );
                                    }),
                                  ),
                                  Text(review.text),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
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
                    const SizedBox(height: 10),
                    if (_distance != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$_distance away",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    if (!_isEditable)
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _visitFarm,
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
                              onPressed: _contactSeller,
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
