import 'package:flutter/material.dart';
import '../../screens/service_center_search_screen.dart';
import '../../services/search_service.dart';

class ServiceCategories extends StatefulWidget {
  final String selectedService;
  final Function(String) onServiceSelected;

  const ServiceCategories({
    Key? key,
    required this.selectedService,
    required this.onServiceSelected,
  }) : super(key: key);

  @override
  _ServiceCategoriesState createState() => _ServiceCategoriesState();
}

class _ServiceCategoriesState extends State<ServiceCategories> {
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      print('Loading categories from API...');
      final result = await SearchService.getServiceCategories(type: 'technician');
      print('API Result: $result');
      
      if (result['success']) {
        setState(() {
          _categories = result['data'] ?? [];
          _isLoading = false;
        });
        print('Categories loaded: ${_categories.length} categories');
      } else {
        print('API call failed, using default categories');
        // Fallback to hardcoded data if API fails
        setState(() {
          _categories = _getDefaultCategories();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      // Fallback to hardcoded data on error
      setState(() {
        _categories = _getDefaultCategories();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getDefaultCategories() {
    return [
      {'name': 'Service', 'image': 'assets/images/service_center.png', 'count': 0},
      {'name': 'Towing', 'image': 'assets/images/towing1.png', 'count': 0},
      {'name': 'Electricians', 'image': 'assets/images/electrician.png', 'count': 0},
      {'name': 'Plumbers', 'image': 'assets/images/plumbing.png', 'count': 0},
      {'name': 'Gardening', 'image': 'assets/images/gardening.png', 'count': 0},
      {'name': 'Repair', 'image': 'assets/images/plumbing.png', 'count': 0},
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 105,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final service = _categories[index];
          final isSelected = widget.selectedService == service['name'];
          
          return GestureDetector(
            onTap: () {
              // Navigate to ServiceCenterSearchPage if "Service" is clicked
              if (service['name'] == 'Service') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceCenterSearchPage(),
                  ),
                );
              } else {
                // For other services, use the existing callback
                widget.onServiceSelected(service['name'] as String);
              }
            },
            child: Container(
              width: 80,
              margin: EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color.fromARGB(255, 134, 200, 255) : const Color.fromARGB(255, 211, 235, 255),
                      borderRadius: BorderRadius.circular(40),
                      border: isSelected 
                        ? Border.all(color: const Color.fromARGB(255, 97, 183, 253), width: 2)
                        : Border.all(color: const Color.fromARGB(255, 211, 235, 255), width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: service['image'] != null && service['image'].startsWith('assets/')
                            ? Image.asset(
                                service['image'] as String,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultIcon(service['name'], isSelected);
                                },
                              )
                            : _buildDefaultIcon(service['name'], isSelected),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    service['name'] as String,
                    style: TextStyle(
                      color: isSelected ?  const Color.fromARGB(255, 97, 183, 253) : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultIcon(String serviceName, bool isSelected) {
    IconData iconData;
    
    switch (serviceName.toLowerCase()) {
      case 'service':
        iconData = Icons.build;
        break;
      case 'towing':
        iconData = Icons.local_shipping;
        break;
      case 'electricians':
        iconData = Icons.electrical_services;
        break;
      case 'plumbers':
        iconData = Icons.plumbing;
        break;
      case 'gardening':
        iconData = Icons.grass;
        break;
      case 'repair':
        iconData = Icons.handyman;
        break;
      default:
        iconData = Icons.build;
    }

    return Icon(
      iconData,
      color: isSelected ? Colors.white : Colors.grey[600],
      size: 35,
    );
  }
}