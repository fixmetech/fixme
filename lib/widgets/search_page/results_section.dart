import 'package:flutter/material.dart';

class ResultsSection extends StatelessWidget {
  final String selectedService;
  final String searchQuery;
  final VoidCallback? onResetFilters;

  const ResultsSection({
    Key? key,
    required this.selectedService,
    required this.searchQuery,
    this.onResetFilters,
  }) : super(key: key);

  // Service type to image mapping - easily replaceable with backend data
  static const Map<String, String> serviceImages = {
    'Plumbers': 'assets/images/plumber_new.jpg',
    'Electricians': 'assets/images/electrician_new.jpg',
    'Service': 'assets/images/car_service.jpg',
    'Towing': 'assets/images/towing_car.png',
    'Repair': 'assets/images/car_service.jpg',
    'Gardening': 'assets/images/gardening.jpg',
    'hvac': 'assets/images/hvac.jpg',
    'default': 'assets/images/car_service.jpg',
  };

  // Sample service types for demonstration
  static const List<String> sampleServices = [
    'Plumbers',
    'Electricians', 
    'Service',
    'Towing',
    'Gardening',
  ];

  String _getServiceImage(String serviceType, int index) {
    // When backend is ready, replace this with actual image URL from database
    return serviceImages[serviceType.toLowerCase()] ?? serviceImages['default']!;
  }

  String _getServiceTypeForIndex(int index, String section) {
    // This simulates different service types - replace with actual data from backend
    if (section == 'Featured in FixMe') {
      return sampleServices[index % sampleServices.length];
    } else if (section == 'Top Technicians') {
      return sampleServices[(index + 1) % sampleServices.length];
    } else if (section == 'Previous Services') {
      return sampleServices[(index + 2) % sampleServices.length];
    } else if (section == 'Offers') {
      return sampleServices[(index + 3) % sampleServices.length];
    }
    return 'default';
  }

  @override
  Widget build(BuildContext context) {
    if (selectedService.isEmpty && searchQuery.isEmpty) {
      return _buildDefaultSections();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildDefaultSections() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHorizontalSection('Featured in FixMe'),
          SizedBox(height: 20),
          _buildHorizontalSection('Top Technicians'),
          SizedBox(height: 20),
          _buildHorizontalSection('Previous Services'),
          SizedBox(height: 20),
          _buildHorizontalSection('Offers'),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey[600], size: 20),
            ],
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              _getServiceImage(_getServiceTypeForIndex(index, title), index),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (title == 'Offers')
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Save 20%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${title.split(' ')[0]} Service ${index + 1}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(
                                ' 4.${5 + index}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              Text(
                                ' • Rs.${(index + 1) * 500} Fee',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedService.isNotEmpty ? selectedService : "Search"} results',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: onResetFilters,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              _getServiceImage(selectedService.isNotEmpty ? selectedService : sampleServices[index % sampleServices.length], index),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (index < 3)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Top offer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.favorite_border, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selectedService.isNotEmpty ? selectedService : "Service"} Provider ${index + 1}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(
                                ' 4.${5 + (index % 4)}',
                                style: TextStyle(color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                ' (${(index + 1) * 100}+)',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              Text(
                                ' • ${(index + 1) * 5 + 15} min',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Rs.${(index + 1) * 200 + 300} Visiting Fee',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}