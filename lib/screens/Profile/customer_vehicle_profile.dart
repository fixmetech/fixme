import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/screens/Profile/customer_edit_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerVehicleProfile extends StatefulWidget {
  final VehicleProfile vehicleProfile;
  
  const CustomerVehicleProfile({super.key, required this.vehicleProfile});

  @override
  State<CustomerVehicleProfile> createState() => _CustomerVehicleProfileState();
}

class _CustomerVehicleProfileState extends State<CustomerVehicleProfile> {
  static const Color _primaryColor = Color(0xFF1976D2);
  static const Color _accentColor = Color(0xFF42A5F5);
  final profileController = Get.find<ProfileController>();

  // Get vehicle details from the passed vehicle profile
  Map<String, String> get vehicleDetails => {
    'Plate Number': widget.vehicleProfile.plateNumber,
    'Make': widget.vehicleProfile.make,
    'Model': widget.vehicleProfile.model,
    'Year': widget.vehicleProfile.year,
    'Color': widget.vehicleProfile.color,
    'Vehicle Type': widget.vehicleProfile.vehicleType,
    'Fuel Type': widget.vehicleProfile.fuelType,
    'Transmission': widget.vehicleProfile.transmission,
    'Engine Capacity': widget.vehicleProfile.engineCapacity,
    'Mileage': widget.vehicleProfile.mileage,
    'Default Vehicle': widget.vehicleProfile.isDefault ? 'Yes' : 'No',
  };

  String? get _vehicleImageUrl => widget.vehicleProfile.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildVehicleImageSection(),
            const SizedBox(height: 32),
            _buildVehicleDetailsSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Vehicle Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      backgroundColor: _primaryColor,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Vehicle Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _navigateToEditPage,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleImageSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Vehicle Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1.5),
                  image: _vehicleImageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(_vehicleImageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _vehicleImageUrl == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 60,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No vehicle image',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Plate Number', widget.vehicleProfile.plateNumber),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildDetailRow('Make', widget.vehicleProfile.make)),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailRow('Model', widget.vehicleProfile.model)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildDetailRow('Year', widget.vehicleProfile.year)),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailRow('Color', widget.vehicleProfile.color)),
              ],
            ),
            const Divider(height: 24),
            _buildDetailRow('Vehicle Type', widget.vehicleProfile.vehicleType),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildDetailRow('Fuel Type', widget.vehicleProfile.fuelType)),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailRow('Transmission', widget.vehicleProfile.transmission)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildDetailRow('Engine Capacity', widget.vehicleProfile.engineCapacity)),
                const SizedBox(width: 16),
                Expanded(child: _buildDetailRow('Mileage', widget.vehicleProfile.mileage)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // Action methods

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditVehicle(vehicleProfile: widget.vehicleProfile),
      ),
    ).then((_) {
      // Refresh when coming back from edit
      if (mounted) {
        setState(() {
          // The widget will rebuild with updated data from ProfileController
        });
      }
    });
  }
}