import 'package:flutter/material.dart';
import '../widgets/search_page/address_button.dart';
import '../widgets/search_page/search_bar_widget.dart';
import '../widgets/search_page/filter_section.dart';
import '../widgets/search_page/service_center_results_section.dart';

class ServiceCenterSearchPage extends StatefulWidget {
  @override
  _ServiceCenterSearchPageState createState() => _ServiceCenterSearchPageState();
}

class _ServiceCenterSearchPageState extends State<ServiceCenterSearchPage> {
  String selectedService = '';
  String searchQuery = '';
  List<String> selectedFilters = [];
  Map<String, String> filterValues = {};
  
  // Add a callback to reset filters
  VoidCallback? _resetFiltersCallback;

  void _onServiceSelected(String service) {
    setState(() {
      selectedService = service;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _onFiltersChanged(List<String> filters, Map<String, String> values) {
    setState(() {
      selectedFilters = filters;
      filterValues = values;
    });
    // Here you can implement the actual filtering logic
    // For now, it just updates the state
  }

  void _resetFilters() {
    setState(() {
      selectedService = '';
      selectedFilters.clear();
      filterValues.clear();
    });
    // Call the reset callback if available
    if (_resetFiltersCallback != null) {
      _resetFiltersCallback!();
    }
  }

  void _setResetCallback(VoidCallback callback) {
    _resetFiltersCallback = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Service Centers',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with address
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: AddressButton(),
            ),
            
            // Search bar - now navigates to detailed search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBarWidget(onSearchChanged: _onSearchChanged),
            ),
            
            SizedBox(height: 16),
            
            // Service Center Categories
            ServiceCenterCategories(
              selectedService: selectedService,
              onServiceSelected: _onServiceSelected,
            ),
            
            SizedBox(height: 16),
            
            // Filter section
            FilterSection(
              onFiltersChanged: _onFiltersChanged,
              onSetResetCallback: _setResetCallback,
            ),
            
            SizedBox(height: 16),
            
            // Results section
            Expanded(
              child: ResultsSection(
                selectedService: selectedService,
                searchQuery: searchQuery,
                onResetFilters: _resetFilters,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCenterCategories extends StatelessWidget {
  final String selectedService;
  final Function(String) onServiceSelected;

  const ServiceCenterCategories({
    Key? key,
    required this.selectedService,
    required this.onServiceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final serviceCenterTypes = [
      {'name': 'Car Wash', 'image': 'assets/images/service_center/car_wash.png'},
      {'name': 'Car Repair', 'image': 'assets/images/service_center/service.png'},
      {'name': 'Electronics', 'image': 'assets/images/service_center/electronics.png'},
      {'name': 'Pest Control', 'image': 'assets/images/service_center/pest.png'},
      {'name': 'AC Service', 'image': 'assets/images/service_center/ac.png'},
      {'name': 'Phone Repair', 'image': 'assets/images/service_center/phone.png'},
      {'name': 'Appliances', 'image': 'assets/images/service_center/appliances.png'},
      {'name': 'Computers', 'image': 'assets/images/service_center/computers.png'},
    ];

    return Container(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: serviceCenterTypes.length,
        itemBuilder: (context, index) {
          final service = serviceCenterTypes[index];
          final isSelected = selectedService == service['name'];
          
          return GestureDetector(
            onTap: () => onServiceSelected(service['name'] as String),
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
                        ? Border.all(color:  const Color.fromARGB(255, 97, 183, 253), width: 2)
                        : Border.all(color: const Color.fromARGB(255, 211, 235, 255), width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          service['image'] as String,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback icon if image not found
                            return Icon(
                              _getIconForService(service['name'] as String),
                              color: isSelected ? Colors.white : Colors.grey[600],
                              size: 35,
                            );
                          },
                        ),
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

  IconData _getIconForService(String serviceName) {
    switch (serviceName) {
      case 'Car Wash':
        return Icons.local_car_wash;
      case 'Car Repair':
        return Icons.car_repair;
      case 'Electronics':
        return Icons.electrical_services;
      case 'Pest Control':
        return Icons.pest_control;
      case 'AC Service':
        return Icons.ac_unit;
      case 'Phone Repair':
        return Icons.phone_android;
      case 'Appliances':
        return Icons.kitchen;
      case 'Computers':
        return Icons.computer;
      default:
        return Icons.build;
    }
  }
}