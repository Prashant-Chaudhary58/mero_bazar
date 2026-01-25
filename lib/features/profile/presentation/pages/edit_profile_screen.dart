import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:mero_bazar/core/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _districtController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _altPhoneController;
  
  String? _selectedProvince;
  String? _imagePath;

  final List<String> _provinces = [
    "Koshi",
    "Madhesh",
    "Bagmati",
    "Gandaki",
    "Lumbini",
    "Karnali",
    "Sudurpashchim"
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _fullNameController = TextEditingController(text: user?.fullName);
    _emailController = TextEditingController(text: user?.email);
    _dobController = TextEditingController(text: user?.dob);
    _districtController = TextEditingController(text: user?.district);
    _cityController = TextEditingController(text: user?.city);
    _addressController = TextEditingController(text: user?.address);
    _altPhoneController = TextEditingController(text: user?.altPhone);
    _selectedProvince = user?.province;
    _imagePath = user?.image;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _districtController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _altPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _saveProfile() {
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.user;

    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(
        fullName: _fullNameController.text,
        email: _emailController.text,
        dob: _dobController.text,
        province: _selectedProvince,
        district: _districtController.text,
        city: _cityController.text,
        address: _addressController.text,
        altPhone: _altPhoneController.text,
        image: _imagePath,
      );

      userProvider.updateUser(updatedUser);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                image: _imagePath!.startsWith('assets') 
                                  ? AssetImage(_imagePath!) as ImageProvider
                                  : FileImage(File(_imagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imagePath == null
                          ? const Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
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
            _buildTextField("Date of Birth", _dobController),
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
                  hint: const Text("Province", style: TextStyle(color: Colors.grey)),
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
            const SizedBox(height: 16),
            _buildTextField("Alternative Phone Number (Optional)", _altPhoneController),
            
            const SizedBox(height: 30),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {

                    },
                    style: OutlinedButton.styleFrom(
                       foregroundColor: Colors.green,
                       side: const BorderSide(color: Colors.green),
                       padding: const EdgeInsets.symmetric(vertical: 14),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8),
                       )
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
                       )
                    ),
                    child: const Text(
                      "Save", 
                      style: TextStyle(color: Colors.white)
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

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFEEEBEB),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
