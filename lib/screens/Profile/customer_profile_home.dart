import 'package:flutter/material.dart' show AlertDialog, Alignment, AppBar, Border, BorderRadius, BottomNavigationBar, BottomNavigationBarItem, BottomNavigationBarType, BoxDecoration, BoxFit, BuildContext, Card, Center, Color, Colors, Column, Container, CrossAxisAlignment, DecorationImage, Divider, EdgeInsets, ElevatedButton, Expanded, FontWeight, GestureDetector, Icon, IconButton, IconThemeData, Icons, LinearGradient, MainAxisAlignment, MaterialPageRoute, Navigator, NetworkImage, Padding, PreferredSizeWidget, RoundedRectangleBorder, Row, Scaffold, ScaffoldMessenger, SingleChildScrollView, SizedBox, SnackBar, State, StatefulWidget, Text, TextButton, TextDecoration, TextStyle, Widget, showDialog;

import 'customer_profile_home_edit.dart';


class CustomerHomeProfile extends StatefulWidget {
  const CustomerHomeProfile({super.key});

  @override
  State<CustomerHomeProfile> createState() => _CustomerHomeProfileState();
}

class _CustomerHomeProfileState extends State<CustomerHomeProfile> {
  static const Color _primaryColor = Color(0xFF1565C0);
  static const Color _accentColor = Color(0xFF42A5F5);

  // Sample data - in a real app, this would come from a data source
  final Map<String, String> homeDetails = {
    'homeName': 'Sripali',
    'address': '1/A, Colombo, 7',
    'city': 'Colombo',
    'district': 'Colombo',
    'location': 'www.colombo7.com',
  };

  String? _imageUrl; // Placeholder for image URL (null for no image)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildHomeImageSection(),
            const SizedBox(height: 32),
            _buildHomeDetailsGrid(),
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
      backgroundColor: Colors.blue,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
      centerTitle: true,
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Profile tab selected
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _primaryColor,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      onTap: _handleBottomNavigation,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Home Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _showEditDialog,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeImageSection() {
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
                  'Home Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (_imageUrl != null)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: _primaryColor, size: 20),
                        onPressed: _handleImageEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: _showDeleteImageDialog,
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _imageUrl == null ? _handleImageEdit : null,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    image: _imageUrl != null
                        ? DecorationImage(
                      image: NetworkImage(_imageUrl!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _imageUrl == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to add image',
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

  Widget _buildHomeDetailsGrid() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Property Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Home Name (Nick Name)', homeDetails['homeName']!),
            const Divider(height: 24),
            _buildDetailRow('Address', homeDetails['address']!),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildDetailRow('City', homeDetails['city']!),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDetailRow('District', homeDetails['district']!),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildLocationRow(),
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

  Widget _buildLocationRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _openLocation(homeDetails['location']!),
          child: Text(
            homeDetails['location']!,
            style: TextStyle(
              fontSize: 16,
              color: _primaryColor,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // Action methods
  void _handleBottomNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
      // Already on Profile
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Edit Home Details',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('Would you like to edit your home details?'),
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
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CustomerProfileHomeEdit()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  void _handleImageEdit() {
    // Simulate image picking (in a real app, use image_picker package)
    setState(() {
      _imageUrl = 'https://via.placeholder.com/300'; // Placeholder image
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image updated successfully')),
    );
  }

  void _showDeleteImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
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
                  _imageUrl = null;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image deleted successfully')),
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

  void _openLocation(String location) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening location: $location')),
    );
  }
}