import 'package:fixme/screens/Profile/customer_profile_vehicle_edit.dart';
import 'package:flutter/material.dart';


class CustomerVehicleProfile extends StatefulWidget {
  const CustomerVehicleProfile({super.key});

  @override
  State<CustomerVehicleProfile> createState() => _CustomerVehicleProfileState();
}

class _CustomerVehicleProfileState extends State<CustomerVehicleProfile> {
  static const Color _primaryColor = Color(0xFF1976D2);
  static const Color _accentColor = Color(0xFF42A5F5);

  // Sample data - in a real app, this would come from a data source
  final Map<String, String> vehicleDetails = {
    'Vehicle Type': 'Car',
    'Vehicle Make': 'Toyota',
    'Manufacture Date': 'January 12, 2025',
    'Licence Plate Number': 'ABC1234',
  };

  String? _vehicleImageUrl; // Placeholder for vehicle image URL (null for no image)

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
        'Customer Profile',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Vehicle Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (_vehicleImageUrl != null)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: _primaryColor, size: 20),
                        onPressed: _handleImageEdit,
                        tooltip: 'Edit Image',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: _showDeleteImageDialog,
                        tooltip: 'Delete Image',
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _vehicleImageUrl == null ? _handleImageEdit : null,
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
                        'Tap to add vehicle image',
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
            ...vehicleDetails.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: _buildDetailRow(entry.key, entry.value),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
      ],
    );
  }

  // Action methods

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerProfileVehicleEdit()),
    );
  }

  void _handleImageEdit() {
    // Simulate image picking (in a real app, use image_picker package)
    setState(() {
      _vehicleImageUrl = 'https://via.placeholder.com/300'; // Placeholder image
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vehicle image updated successfully')),
    );
  }

  void _showDeleteImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Delete Vehicle Image'),
          content: const Text('Are you sure you want to delete this vehicle image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: _primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _vehicleImageUrl = null;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vehicle image deleted successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}