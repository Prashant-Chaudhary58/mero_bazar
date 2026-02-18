import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mero_bazar/core/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:mero_bazar/core/services/location_service.dart';
import 'package:mero_bazar/features/profile/presentation/pages/map_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _districtController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _altPhoneController;

  String? _selectedProvince;
  String? _imagePath;
  File? _pickedImageFile;
  double? _lat;
  double? _lng;
  bool _isLoadingLocation = false;

  final List<String> _provinces = [
    "Koshi",
    "Madhesh",
    "Bagmati",
    "Gandaki",
    "Lumbini",
    "Karnali",
    "Sudurpashchim",
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _fullNameController = TextEditingController(text: user?.fullName);
    _emailController = TextEditingController(text: user?.email);
    _districtController = TextEditingController(text: user?.district);
    _cityController = TextEditingController(text: user?.city);
    _addressController = TextEditingController(text: user?.address);
    _altPhoneController = TextEditingController(text: user?.altPhone);
    _phoneController = TextEditingController(text: user?.phone);

    // Ensure selected province matches one of the options
    if (user?.province != null && _provinces.contains(user!.province)) {
      _selectedProvince = user!.province;
    } else {
      _selectedProvince = null;
    }

    _lat = user?.lat;
    _lng = user?.lng;
    _imagePath = user?.image;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _altPhoneController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // Show dialog to choose Camera or Gallery
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageSource(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageSource(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageSource(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      // For Android 13+ use photos, else storage
      if (Platform.isAndroid && (await _getAndroidSdk()) >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    }

    if (status.isPermanentlyDenied) {
      if (mounted) _showPermissionSettingsDialog();
      return;
    }

    if (!status.isGranted && !status.isLimited) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission required to access media")),
        );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _pickedImageFile = File(image.path);
        _imagePath = image.path;
      });
    }
  }

  Future<int> _getAndroidSdk() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  Future<void> _getLocation() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Set Farm Location"),
        content: const Text(
          "How would you like to set your location?\n\nIf you are currently at your farm, use 'Current GPS'.\nIf you are elsewhere, use 'Pick on Map'.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _getGPSLocation();
            },
            child: const Text("Current GPS"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _pickLocationManually();
            },
            child: const Text("Pick on Map"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickLocationManually() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MapPickerScreen(initialLat: _lat, initialLng: _lng),
      ),
    );

    if (result != null && result is LatLng) {
      if (!mounted) return;
      setState(() {
        _lat = result.latitude;
        _lng = result.longitude;
        _isLoadingLocation = true;
      });

      try {
        // Add timeout to prevent hanging indefinitely
        await _reverseGeocode(_lat!, _lng!).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            print("Geocoding timed out");
            return;
          },
        );
      } catch (e) {
        print("Error in manual pick: $e");
      }

      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _getGPSLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final position = await LocationService.getCurrentPosition();
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });

      await _reverseGeocode(_lat!, _lng!);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching location: $e")));
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _reverseGeocode(double lat, double lng) async {
    try {
      final placemark = await LocationService.getAddressFromCoordinates(
        lat,
        lng,
      );
      if (placemark != null) {
        setState(() {
          // Auto-fill address fields
          if (placemark.administrativeArea != null &&
              _provinces.contains(placemark.administrativeArea)) {
            _selectedProvince = placemark.administrativeArea;
          }
          _districtController.text = placemark.subAdministrativeArea ?? '';
          _cityController.text = placemark.locality ?? '';
          _addressController.text =
              "${placemark.street ?? ''} ${placemark.name ?? ''}".trim();
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Location updated!")));
      }
    } catch (e) {
      print("Geocoding error: $e");
    }
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text("Please enable permissions in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text("Settings"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProfile() async {
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.user;

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        fullName: _fullNameController.text,
        email: _emailController.text,
        dob: '',
        province: _selectedProvince,
        district: _districtController.text,
        city: _cityController.text,
        address: _addressController.text,
        altPhone: _altPhoneController.text,
        image: _imagePath,
        lat: _lat,
        lng: _lng,
      );
      print("Saving Profile: Lat: $_lat, Lng: $_lng");

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final authRepo = context.read<AuthRepositoryImpl>();
        // Only pass imageFile if a new image was picked
        File? imageFile = _pickedImageFile;

        final resultUser = await authRepo.updateProfile(
          user: updatedUser,
          imageFile: imageFile,
        );

        if (!mounted) return;
        Navigator.pop(context); // Pop loading

        userProvider.updateUser(resultUser);
        Navigator.pop(context); // Pop screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Pop loading
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "My Account",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image Edit
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        image: _imagePath != null
                            ? DecorationImage(
                                image:
                                    (_imagePath!.startsWith('assets')
                                            ? AssetImage(_imagePath!)
                                            : (_imagePath == 'no-photo.jpg'
                                                  ? const AssetImage(
                                                      "assets/images/logo.jpg",
                                                    )
                                                  : (_imagePath!.startsWith(
                                                          '/data',
                                                        ) ||
                                                        _imagePath!.startsWith(
                                                          '/storage',
                                                        ))
                                                  ? FileImage(File(_imagePath!))
                                                  : CachedNetworkImageProvider(
                                                      ApiService.getImageUrl(
                                                        _imagePath!,
                                                        currentUser?.role ??
                                                            'buyer',
                                                      ),
                                                    )))
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imagePath == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Text("Edit", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            _buildTextField("Full Name", _fullNameController),
            const SizedBox(height: 16),
            _buildTextField("Email", _emailController),
            const SizedBox(height: 16),

            // Province Dropdown
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEEEBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedProvince,
                  hint: const Text(
                    "Province",
                    style: TextStyle(color: Colors.grey),
                  ),
                  isExpanded: true,
                  items: _provinces.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProvince = newValue;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),
            _buildTextField("District", _districtController),
            const SizedBox(height: 16),
            _buildTextField("City", _cityController),
            const SizedBox(height: 16),

            _buildTextField("Home Address", _addressController),

            // Set Farm Location Button (Only for Sellers)
            if (currentUser?.role == 'seller' ||
                currentUser?.role == 'farmer') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoadingLocation ? null : _getLocation,
                  icon: _isLoadingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.location_on, color: Colors.white),
                  label: Text(
                    _isLoadingLocation
                        ? "Getting Location..."
                        : "Set Farm Location (Auto-Fill)",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),
            _buildTextField("Phone Number", _phoneController, readOnly: true),

            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green,
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Edit"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7C2E), // Dark Green
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade300 : const Color(0xFFEEEBEB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
