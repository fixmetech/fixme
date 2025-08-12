import 'dart:io';
import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Import your home page - replace with your actual home page import
// import 'home_page.dart';

class CustomerAddHome extends StatefulWidget {
  const CustomerAddHome({super.key});

  @override
  State<CustomerAddHome> createState() => _CustomerAddHomeState();
}

class _CustomerAddHomeState extends State<CustomerAddHome> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final profileController = Get.find<ProfileController>();

  // Controllers
  final _homenameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _areaController = TextEditingController();
  final _landmarkController = TextEditingController();

  String _selectedHomeType = 'House';
  bool _isDefault = false;
  File? _homeImage;

  final List<String> _homeTypes = [
    'House',
    'Apartment',
    'Condominium',
    'Villa',
    'Office',
    'Shop',
    'Other'
  ];

  @override
  void dispose() {
    _homenameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedImage != null) {
        setState(() {
          _homeImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      FixMeHelperFunctions.showWarningSnackBar('Error', 'Error picking image: $e');
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final newHome = HomeProfile(
        name: _homenameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        homeType: _selectedHomeType,
        imageUrl: '', // For now, we'll handle image uploads later
        isDefault: _isDefault,
        area: _areaController.text.trim(),
        phone: _phoneController.text.trim(),
        landmark: _landmarkController.text.trim().isEmpty 
            ? null 
            : _landmarkController.text.trim(),
      );

      await profileController.addHomeProfile(newHome);
      
      // If successful, go back and refresh the list
      if (!profileController.isLoading.value) {
        FixMeHelperFunctions.showSuccessSnackBar('Saved','Home profile saved successfully!' );
        print('11');
        _navigateToHome();
        print('12');
        profileController.loadUserHomes();
      }

    } catch (e) {
      FixMeHelperFunctions.showWarningSnackBar('Error', 'Error saving profile: $e');
    }
  }

  void _navigateToHome() {
    Get.back();
  }

  void _onClosePressed() {
    if (_hasUnsavedChanges()) {
      _showDiscardDialog();
    } else {
      _navigateToHome();
    }
  }

  bool _hasUnsavedChanges() {
    return _homenameController.text.isNotEmpty ||
        _addressController.text.isNotEmpty ||
        _cityController.text.isNotEmpty ||
        _postalCodeController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _areaController.text.isNotEmpty ||
        _landmarkController.text.isNotEmpty ||
        _homeImage != null ||
        _selectedHomeType != _homeTypes.first ||
        _isDefault != false;
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Discard Changes?'),
          content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToHome();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.home_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Add New Home Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: _onClosePressed,
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'Close',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.blue.shade600) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildHomeTypeSelector() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedHomeType,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.home, color: Colors.blue.shade600),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: _homeTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedHomeType = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a home type';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultSwitch() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Set as your primary home address',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isDefault,
            onChanged: (bool value) {
              setState(() {
                _isDefault = value;
              });
            },
            activeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Home Image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _homeImage != null ? Colors.blue.shade600 : Colors.grey.shade300,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade50,
              ),
              child: _homeImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    Image.file(
                      _homeImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                          onPressed: _pickImage,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to select home image',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG up to 10MB',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: profileController.isLoading.value ? null : _onClosePressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: profileController.isLoading.value ? null : _saveForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
              child: profileController.isLoading.value
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : const Text(
                'Save Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: _buildHeader(),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _homenameController,
                          label: 'Home Name',
                          hint: 'Enter your home name',
                          prefixIcon: Icons.home,
                        ),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          hint: 'Enter your complete address',
                          prefixIcon: Icons.location_on,
                          maxLines: 2,
                        ),
                        _buildTextField(
                          controller: _cityController,
                          label: 'City',
                          hint: 'Enter your city',
                          prefixIcon: Icons.location_city,
                        ),
                        _buildTextField(
                          controller: _postalCodeController,
                          label: 'Postal Code',
                          hint: 'Enter your postal code',
                          prefixIcon: Icons.local_post_office,
                        ),
                        _buildTextField(
                          controller: _areaController,
                          label: 'Area',
                          hint: 'Enter area/neighborhood',
                          prefixIcon: Icons.map,
                        ),
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: 'Enter phone number for this location',
                          prefixIcon: Icons.phone,
                        ),
                        _buildTextField(
                          controller: _landmarkController,
                          label: 'Landmark (Optional)',
                          hint: 'Enter nearby landmark',
                          prefixIcon: Icons.place,
                        ),
                        _buildHomeTypeSelector(),
                        _buildDefaultSwitch(),
                        _buildImagePicker(),
                        Obx(() => _buildActionButtons()),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}