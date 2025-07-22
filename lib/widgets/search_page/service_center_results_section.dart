import 'package:flutter/material.dart';
import '../../screens/serviceCenterProfile/service_center_profile.dart';

class ResultsSection extends StatelessWidget {
  final String selectedService;
  final String searchQuery;
  final List<String> selectedFilters;
  final Map<String, String> filterValues;
  final VoidCallback? onResetFilters;

  const ResultsSection({
    Key? key,
    required this.selectedService,
    required this.searchQuery,
    this.selectedFilters = const [],
    this.filterValues = const {},
    this.onResetFilters,
  }) : super(key: key);

  // Service center type to image mapping - easily replaceable with backend data
  static const Map<String, String> serviceCenterImages = {
    'car wash': 'assets/images/service_center/card.jpg',
    'car repair': 'assets/images/service_center/card.jpg',
    'electronics': 'assets/images/service_center/card.jpg',
    'pest control': 'assets/images/service_center/card.jpg',
    'ac service': 'assets/images/service_center/card.jpg',
    'phone repair': 'assets/images/service_center/card.jpg',
    'appliances': 'assets/images/service_center/card.jpg',
    'computers': 'assets/images/service_center/card.jpg',
    'default': 'assets/images/service_center/card.jpg',
  };

  // Sample service center types for demonstration
  static const List<String> sampleServiceCenters = [
    'Car Wash',
    'Car Repair',
    'Electronics',
    'AC Service',
    'Phone Repair',
    'Appliances',
    'Computers',
    'Pest Control',
  ];

  String _getServiceCenterImage(String serviceCenterType, int index) {
    // When backend is ready, replace this with actual image URL from database
    return serviceCenterImages[serviceCenterType.toLowerCase()] ?? serviceCenterImages['default']!;
  }

  String _getServiceCenterTypeForIndex(int index, String section) {
    // This simulates different service center types - replace with actual data from backend
    if (section == 'Featured Service Centers') {
      return sampleServiceCenters[index % sampleServiceCenters.length];
    } else if (section == 'Top Rated Centers') {
      return sampleServiceCenters[(index + 1) % sampleServiceCenters.length];
    } else if (section == 'Recently Visited') {
      return sampleServiceCenters[(index + 2) % sampleServiceCenters.length];
    } else if (section == 'Special Offers') {
      return sampleServiceCenters[(index + 3) % sampleServiceCenters.length];
    }
    return 'default';
  }

  bool _hasActiveFilters() {
    return selectedService.isNotEmpty || 
           searchQuery.isNotEmpty || 
           selectedFilters.isNotEmpty;
  }

  List<Map<String, dynamic>> _getFilteredResults() {
    // Generate sample data for demonstration
    List<Map<String, dynamic>> allResults = List.generate(20, (index) {
      return {
        'id': index,
        'name': '${selectedService.isNotEmpty ? selectedService : "Service"} Center ${index + 1}',
        'type': selectedService.isNotEmpty ? selectedService : sampleServiceCenters[index % sampleServiceCenters.length],
        'distance': (index + 1) * 2 + 1.0 + (index + 2) * 0.1,
        'rating': 4.5 + (index % 4) * 0.1,
        'reviews': (index + 1) * 100,
        'isOpen': index % 2 == 0,
        'hasOffer': index < 5,
        'image': _getServiceCenterImage(selectedService.isNotEmpty ? selectedService : sampleServiceCenters[index % sampleServiceCenters.length], index),
      };
    });

    // Apply filters
    List<Map<String, dynamic>> filteredResults = allResults;

    // Filter by distance
    if (filterValues.containsKey('Distance')) {
      String distanceFilter = filterValues['Distance']!;
      double maxDistance = double.parse(distanceFilter.replaceAll(RegExp(r'[^\d.]'), ''));
      filteredResults = filteredResults.where((result) => result['distance'] <= maxDistance).toList();
    }

    // Filter by rating
    if (filterValues.containsKey('Rating')) {
      String ratingFilter = filterValues['Rating']!;
      double minRating = double.parse(ratingFilter.replaceAll(RegExp(r'[^\d.]'), ''));
      filteredResults = filteredResults.where((result) => result['rating'] >= minRating).toList();
    }

    // Filter by open/closed status
    if (selectedFilters.contains('Open Now')) {
      filteredResults = filteredResults.where((result) => result['isOpen'] == true).toList();
    }

    // Filter by offers
    if (selectedFilters.contains('Special Offers')) {
      filteredResults = filteredResults.where((result) => result['hasOffer'] == true).toList();
    }

    // Sort results
    if (filterValues.containsKey('Sort')) {
      String sortBy = filterValues['Sort']!;
      switch (sortBy) {
        case 'Distance':
          filteredResults.sort((a, b) => a['distance'].compareTo(b['distance']));
          break;
        case 'Rating':
          filteredResults.sort((a, b) => b['rating'].compareTo(a['rating']));
          break;
        case 'Price':
          filteredResults.sort((a, b) => a['id'].compareTo(b['id'])); // Simulate price sorting
          break;
        default: // Recommended
          break;
      }
    }

    return filteredResults;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasActiveFilters()) {
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
          _buildHorizontalSection('Featured Service Centers'),
          SizedBox(height: 25),
          _buildHorizontalSection('Top Rated Centers'),
          SizedBox(height: 25),
          _buildHorizontalSection('Recently Visited'),
          SizedBox(height: 25),
          _buildHorizontalSection('Special Offers'),
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
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceCenterProfile(),
                    ),
                  );
                },
                child: Container(
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
                              _getServiceCenterImage(_getServiceCenterTypeForIndex(index, title), index),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.business,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (title == 'Special Offers')
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
                          if (title == 'Featured Service Centers')
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Featured',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
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
                            '${_getServiceCenterTypeForIndex(index, title)} Center ${index + 1}',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey[600], size: 14),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${(index + 1) * 2 + 3}.${index + 5} km away',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
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
                                ' (${(index + 1) * 150}+)',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.green,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Open Now',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ), // Close Container
              ); // Close InkWell
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    List<Map<String, dynamic>> filteredResults = _getFilteredResults();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filteredResults.length} ${selectedService.isNotEmpty ? selectedService : "Service"} Centers found',
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
            itemCount: filteredResults.length,
            itemBuilder: (context, index) {
              final result = filteredResults[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceCenterProfile(),
                    ),
                  );
                },
                child: Container(
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
                              result['image'],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Icon(
                                    Icons.business,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (result['hasOffer'])
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
                                  'Special Offer',
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
                            result['name'],
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${result['distance'].toStringAsFixed(1)} km away • Downtown Area',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              Text(
                                ' ${result['rating'].toStringAsFixed(1)}',
                                style: TextStyle(color: Colors.black87, fontSize: 14),
                              ),
                              Text(
                                ' (${result['reviews']}+)',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: result['isOpen'] ? Colors.green : Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                result['isOpen'] ? 'Open Now' : 'Closed',
                                style: TextStyle(
                                  color: result['isOpen'] ? Colors.green : Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                result['isOpen'] ? ' • Closes at 8 PM' : ' • Opens at 9 AM',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ), // Close Container
              ); // Close InkWell
            },
          ),
        ),
      ],
    );
  }
}