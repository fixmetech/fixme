import 'dart:io';
import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAddVehicle extends StatefulWidget {
  const CustomerAddVehicle({super.key});

  @override
  State<CustomerAddVehicle> createState() => _CustomerAddVehicleState();
}

class _CustomerAddVehicleState extends State<CustomerAddVehicle> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final profileController = Get.find<ProfileController>();

  // Controllers
  final _plateNumberController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _fuelTypeController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _engineCapacityController = TextEditingController();
  final _mileageController = TextEditingController();

  String _selectedVehicleType = 'Car';
  String _selectedFuelType = 'Petrol';
  String _selectedTransmission = 'Manual';
  bool _isDefault = false;
  File? _vehicleImage;

  final List<String> _vehicleTypes = [
    'Car',
    'Motorcycle',
    'SUV',
    'Truck',
    'Van',
    'Bus',
    'Other',
  ];

  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'CNG',
    'LPG',
  ];

  final List<String> _transmissionTypes = ['Manual', 'Automatic', 'CVT'];

  @override
  void dispose() {
    _plateNumberController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _fuelTypeController.dispose();
    _transmissionController.dispose();
    _engineCapacityController.dispose();
    _mileageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Generate a unique ID (in a real app, this would come from the backend)
      final vehicleId = DateTime.now().millisecondsSinceEpoch.toString();

      final newVehicle = VehicleProfile(
        id: vehicleId,
        plateNumber: _plateNumberController.text.trim(),
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        year: _yearController.text.trim(),
        color: _colorController.text.trim(),
        vehicleType: _selectedVehicleType,
        fuelType: _selectedFuelType,
        transmission: _selectedTransmission,
        engineCapacity: _engineCapacityController.text.trim(),
        mileage: _mileageController.text.trim(),
        isDefault: _isDefault,
        imageUrl: '', // For now, we'll handle image uploads later
      );

      // Add the vehicle using the controller
      await profileController.addVehicleProfile(newVehicle);

      // If successful, go back and refresh the list
      if (!profileController.isLoading.value) {
        _showSnackBar('Vehicle profile saved successfully!');
        _navigateBack();
        // Refresh the vehicle list
        profileController.loadUserVehicles();
      }
    } catch (e) {
      _showSnackBar('Error saving profile: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _navigateBack() {
    Navigator.of(context).pop();
  }

  void _onClosePressed() {
    if (_hasUnsavedChanges()) {
      _showDiscardDialog();
    } else {
      _navigateBack();
    }
  }

  bool _hasUnsavedChanges() {
    return _plateNumberController.text.isNotEmpty ||
        _makeController.text.isNotEmpty ||
        _modelController.text.isNotEmpty ||
        _yearController.text.isNotEmpty ||
        _colorController.text.isNotEmpty ||
        _engineCapacityController.text.isNotEmpty ||
        _mileageController.text.isNotEmpty ||
        _vehicleImage != null ||
        _selectedVehicleType != _vehicleTypes.first ||
        _selectedFuelType != _fuelTypes.first ||
        _selectedTransmission != _transmissionTypes.first ||
        _isDefault != false;
  }

  void _showDiscardDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Discard Changes?'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to discard them?',
          ),
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
                _navigateBack(); // Navigate back
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
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Vehicle Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add your vehicle details',
                  style: TextStyle(fontSize: 14, color:Colors.white,),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _onClosePressed,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white),
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
      margin: const EdgeInsets.only(
        bottom: FixMeSizes.spaceBtwItems,
        top: FixMeSizes.spaceBtwItems,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.blue.shade600)
              : null,
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData prefixIcon,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon, color: Colors.blue.shade600),
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
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
                  'Default Vehicle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'Set as your primary vehicle',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
            'Vehicle Image',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // TODO: Implement image picker
              _showSnackBar('Image upload coming soon!');
            },
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: _vehicleImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_vehicleImage!, fit: BoxFit.cover),
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
                          'Tap to select vehicle image',
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
              onPressed: profileController.isLoading.value
                  ? null
                  : _onClosePressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: profileController.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
            Container(margin: const EdgeInsets.all(16), child: _buildHeader()),
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
                          controller: _plateNumberController,
                          label: 'Plate Number',
                          hint: 'Enter vehicle plate number',
                          prefixIcon: Icons.confirmation_number,
                        ),
                        _buildTextField(
                          controller: _makeController,
                          label: 'Make',
                          hint: 'Enter vehicle make (e.g., Toyota)',
                          prefixIcon: Icons.business,
                        ),
                        _buildTextField(
                          controller: _modelController,
                          label: 'Model',
                          hint: 'Enter vehicle model (e.g., Camry)',
                          prefixIcon: Icons.directions_car,
                        ),
                        _buildTextField(
                          controller: _yearController,
                          label: 'Year',
                          hint: 'Enter manufacturing year',
                          prefixIcon: Icons.calendar_today,
                          keyboardType: TextInputType.number,
                        ),
                        _buildTextField(
                          controller: _colorController,
                          label: 'Color',
                          hint: 'Enter vehicle color',
                          prefixIcon: Icons.palette,
                        ),
                        _buildDropdownField(
                          label: 'Vehicle Type',
                          value: _selectedVehicleType,
                          items: _vehicleTypes,
                          prefixIcon: Icons.directions_car,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedVehicleType = newValue!;
                            });
                          },
                        ),
                        _buildDropdownField(
                          label: 'Fuel Type',
                          value: _selectedFuelType,
                          items: _fuelTypes,
                          prefixIcon: Icons.local_gas_station,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFuelType = newValue!;
                            });
                          },
                        ),
                        _buildDropdownField(
                          label: 'Transmission',
                          value: _selectedTransmission,
                          items: _transmissionTypes,
                          prefixIcon: Icons.settings,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTransmission = newValue!;
                            });
                          },
                        ),
                        _buildTextField(
                          controller: _engineCapacityController,
                          label: 'Engine Capacity',
                          hint: 'Enter engine capacity (e.g., 2.0L)',
                          prefixIcon: Icons.engineering,
                        ),
                        _buildTextField(
                          controller: _mileageController,
                          label: 'Mileage',
                          hint: 'Enter vehicle mileage (km)',
                          prefixIcon: Icons.speed,
                          keyboardType: TextInputType.number,
                        ),
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
