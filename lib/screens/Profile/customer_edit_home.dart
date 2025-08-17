import 'dart:io';
import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerEditHome extends StatefulWidget {
  final HomeProfile homeProfile;
  
  const CustomerEditHome({
    super.key,
    required this.homeProfile,
  });

  @override
  State<CustomerEditHome> createState() => _CustomerEditHomeState();
}

class _CustomerEditHomeState extends State<CustomerEditHome> {
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
  void initState() {
    super.initState();
    _initializeWithExistingData();
  }

  void _initializeWithExistingData() {
    // Populate form fields with existing home data
    _homenameController.text = widget.homeProfile.name;
    _addressController.text = widget.homeProfile.address;
    _cityController.text = widget.homeProfile.city;
    _postalCodeController.text = widget.homeProfile.postalCode;
    _phoneController.text = widget.homeProfile.phone;
    _areaController.text = widget.homeProfile.area;
    _landmarkController.text = widget.homeProfile.landmark ?? '';
    _selectedHomeType = widget.homeProfile.homeType;
    _isDefault = widget.homeProfile.isDefault;
  }

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

  Future<void> _updateForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Create updated home profile
      final updatedHome = widget.homeProfile.copyWith(
        name: _homenameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        homeType: _selectedHomeType,
        area: _areaController.text.trim(),
        phone: _phoneController.text.trim(),
        landmark: _landmarkController.text.trim().isEmpty 
            ? null 
            : _landmarkController.text.trim(),
        isDefault: _isDefault,
        // Keep existing image URL if no new image is selected
        imageUrl: widget.homeProfile.imageUrl,
      );

      // Update the home using the controller
      await profileController.updateHomeProfile(updatedHome);
      
      // If successful, go back and refresh the list
      if (!profileController.isLoading.value) {
        _navigateToHome();
        profileController.loadUserHomes();
      }

    } catch (e) {
      FixMeHelperFunctions.showWarningSnackBar('Error','Updating profile: $e');
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pop();
  }

  void _onClosePressed() {
    if (_hasUnsavedChanges()) {
      _showDiscardDialog();
    } else {
      _navigateToHome();
    }
  }

  bool _hasUnsavedChanges() {
    return _homenameController.text != widget.homeProfile.name ||
        _addressController.text != widget.homeProfile.address ||
        _cityController.text != widget.homeProfile.city ||
        _postalCodeController.text != widget.homeProfile.postalCode ||
        _phoneController.text != widget.homeProfile.phone ||
        _areaController.text != widget.homeProfile.area ||
        _landmarkController.text != (widget.homeProfile.landmark ?? '') ||
        _selectedHomeType != widget.homeProfile.homeType ||
        _isDefault != widget.homeProfile.isDefault ||
        _homeImage != null;
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
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _navigateToHome(); // Navigate back
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
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _onClosePressed,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Home Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update your home details',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
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
      margin: const EdgeInsets.only(bottom: 20, top: 10),
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
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // TODO: Implement image picker if needed
              FixMeHelperFunctions.showSnackBar('not yet','Image update coming soon!');
            },
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: _homeImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _homeImage!,
                  fit: BoxFit.cover,
                ),
              )
                  : widget.homeProfile.imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.homeProfile.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Image not available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
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
              onPressed: profileController.isLoading.value ? null : _updateForm,
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
                'Update Profile',
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
                          hint: 'Enter a name for your home',
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
                          hint: 'Enter postal code',
                          prefixIcon: Icons.mail,
                        ),
                        _buildTextField(
                          controller: _areaController,
                          label: 'Area',
                          hint: 'Enter area details',
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
