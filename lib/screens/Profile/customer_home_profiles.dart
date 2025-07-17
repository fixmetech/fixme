import 'package:fixme/screens/Profile/customer_profile_home.dart';
import 'package:flutter/material.dart';

class CustomerHomeProfiles extends StatefulWidget {
  const CustomerHomeProfiles({super.key});

  @override
  State<CustomerHomeProfiles> createState() => _CustomerHomeProfilesState();
}

class _CustomerHomeProfilesState extends State<CustomerHomeProfiles> {
  // Sample data for home profiles
  List<HomeProfile> homeProfiles = [
    HomeProfile(
      id: '1',
      name: 'Primary Residence',
      address: '123 Main Street, Colombo 05',
      city: 'Colombo',
      postalCode: '00500',
      homeType: 'Apartment',
      imageUrl: 'assets/home1.jpg',
      isDefault: true,
      bedrooms: 3,
      bathrooms: 2,
      area: '1200 sq ft',
      phone: '+94 77 123 4567',
    ),
    HomeProfile(
      id: '2',
      name: 'Weekend House',
      address: '456 Beach Road, Galle',
      city: 'Galle',
      postalCode: '80000',
      homeType: 'House',
      imageUrl: 'assets/home2.jpg',
      isDefault: false,
      bedrooms: 4,
      bathrooms: 3,
      area: '2000 sq ft',
      phone: '+94 77 987 6543',
    ),
    HomeProfile(
      id: '3',
      name: 'Office Space',
      address: '789 Business District, Kandy',
      city: 'Kandy',
      postalCode: '20000',
      homeType: 'Commercial',
      imageUrl: 'assets/home3.jpg',
      isDefault: false,
      bedrooms: 0,
      bathrooms: 2,
      area: '800 sq ft',
      phone: '+94 77 555 9999',
    ),
  ];

  void _setAsDefault(String homeId) {
    setState(() {
      for (var home in homeProfiles) {
        home.isDefault = home.id == homeId;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Default home updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewDetails(HomeProfile home) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerHomeProfile(),
      ),
    );
  }

  void _editHome(HomeProfile home) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditHomePage(home: home),
      ),
    );
  }

  void _deleteHome(HomeProfile home) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Home'),
          content: Text('Are you sure you want to delete "${home.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  homeProfiles.removeWhere((h) => h.id == home.id);
                  // If deleted home was default, set first home as default
                  if (home.isDefault && homeProfiles.isNotEmpty) {
                    homeProfiles.first.isDefault = true;
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Home deleted successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addNewHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Home Profiles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,

      ),
      body: Column(
        children: [
          Expanded(
            child: homeProfiles.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: homeProfiles.length,
                    itemBuilder: (context, index) {
                      return _buildHomeCard(homeProfiles[index]);
                    },
                  ),
          ),
          _buildAddHomeButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Home Profiles Added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first home profile to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeCard(HomeProfile home) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: home.isDefault 
            ? Border.all(color: Colors.blue[600]!, width: 2)
            : Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Home Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.home,
                color: Colors.blue[600],
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            
            // Home Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          home.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      if (home.isDefault)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${home.homeType} • ${home.city}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    home.address,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Three dots menu
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _viewDetails(home);
                    break;
                  case 'edit':
                    _editHome(home);
                    break;
                  case 'delete':
                    _deleteHome(home);
                    break;
                  case 'default':
                    _setAsDefault(home.id);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (!home.isDefault)
                  PopupMenuItem<String>(
                    value: 'default',
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 18, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text('Set as Default'),
                      ],
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red[600]),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red[600])),
                    ],
                  ),
                ),
              ],
              child: Icon(
                Icons.more_vert,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAddHomeButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _addNewHome,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_home, size: 24),
              SizedBox(width: 8),
              Text(
                'Add New Home',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Profile Model
class HomeProfile {
  final String id;
  final String name;
  final String address;
  final String city;
  final String postalCode;
  final String homeType;
  final String imageUrl;
  bool isDefault;
  final int bedrooms;
  final int bathrooms;
  final String area;
  final String phone;

  HomeProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.homeType,
    required this.imageUrl,
    required this.isDefault,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.phone,
  });
}

// Placeholder pages for navigation
class HomeDetailsPage extends StatelessWidget {
  final HomeProfile home;

  const HomeDetailsPage({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Details'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Home Details Page for ${home.name}'),
      ),
    );
  }
}

class EditHomePage extends StatelessWidget {
  final HomeProfile home;

  const EditHomePage({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Home'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Edit Home Page for ${home.name}'),
      ),
    );
  }
}

class AddHomePage extends StatelessWidget {
  const AddHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Home'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Add New Home Page'),
      ),
    );
  }
}