import 'package:flutter/material.dart';

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
    required this.selectedFilters,
    required this.filterValues,
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

  // Check if filters are active
  bool get _hasActiveFilters {
    return selectedFilters.isNotEmpty || 
           selectedService.isNotEmpty || 
           searchQuery.isNotEmpty;
  }

  // Get filtered results count (simulated)
  int get _filteredResultsCount {
    if (!_hasActiveFilters) return 0;
    
    // Simulate filtering logic - in real app, this would come from backend
    int baseCount = 25;
    
    // Adjust count based on filters
    if (selectedFilters.contains('Highly Rated')) {
      baseCount = (baseCount * 0.6).round();
    }
    if (selectedFilters.contains('Price')) {
      baseCount = (baseCount * 0.8).round();
    }
    if (selectedFilters.contains('Rating')) {
      baseCount = (baseCount * 0.7).round();
    }
    if (selectedFilters.contains('Distance')) {
      baseCount = (baseCount * 0.9).round();
    }
    if (selectedFilters.contains('Language')) {
      baseCount = (baseCount * 0.75).round();
    }
    
    return baseCount < 1 ? 1 : baseCount;
  }

  String _getResultsHeaderText() {
    if (selectedService.isNotEmpty && searchQuery.isNotEmpty) {
      return '$selectedService - "$searchQuery"';
    } else if (selectedService.isNotEmpty) {
      return selectedService;
    } else if (searchQuery.isNotEmpty) {
      return '"$searchQuery"';
    } else {
      return 'Filtered';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasActiveFilters) {
      return _buildFilteredResults();
    } else {
      return _buildDefaultSections();
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
Widget _buildFilteredResults() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Results header with count and reset button
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getResultsHeaderText()} results',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${_filteredResultsCount} services found',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (onResetFilters != null)
              GestureDetector(
                onTap: onResetFilters,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: Colors.grey[700], size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Reset',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      
      SizedBox(height: 16),
      
      // Filtered results list
      Expanded(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemCount: _filteredResultsCount > 10 ? 10 : _filteredResultsCount,
          itemBuilder: (context, index) {
            return _buildResultCard(index);
          },
        ),
      ),
    ],
  );
}

  Widget _buildResultCard(int index) {
    // Simulate filtered data based on applied filters
    bool isHighlyRated = selectedFilters.contains('Highly Rated') ? true : (index % 3 == 0);
    double rating = selectedFilters.contains('Rating') 
        ? (4.5 + (index % 6) * 0.1) 
        : (4.0 + (index % 10) * 0.1);
    
    // Simulate pricing based on price filter
    int basePrice = 500 + (index * 200);
    if (selectedFilters.contains('Price')) {
      String? priceFilter = filterValues['Price'];
      if (priceFilter != null && priceFilter.contains('1000')) {
        basePrice = 300 + (index * 100); // Lower prices for price filter
      }
    }
    
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
                    _getServiceImage(
                      selectedService.isNotEmpty 
                          ? selectedService 
                          : sampleServices[index % sampleServices.length], 
                      index
                    ),
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
                if (isHighlyRated || index < 3)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHighlyRated ? Colors.orange : Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isHighlyRated ? 'Highly Rated' : 'Top offer',
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
                      ' ${rating.toStringAsFixed(1)}',
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    Text(
                      ' (${(index + 1) * 100}+)',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    if (selectedFilters.contains('Distance')) ...[
                      Text(
                        ' • ${filterValues['Distance'] ?? 'Within 10 km'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ] else ...[
                      Text(
                        ' • ${(index + 1) * 5 + 15} min',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Rs.$basePrice Visiting Fee',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    if (selectedFilters.contains('Language')) ...[
                      Text(
                        ' • ${filterValues['Language'] ?? 'English'}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ],
                ),
                if (selectedFilters.contains('Date') || selectedFilters.contains('Time')) ...[
                  SizedBox(height: 4),
                  Row(
                    children: [
                      if (selectedFilters.contains('Date'))
                        Text(
                          'Available: ${filterValues['Date'] ?? 'Today'}',
                          style: TextStyle(color: Colors.green[600], fontSize: 14),
                        ),
                      if (selectedFilters.contains('Time'))
                        Text(
                          ' at ${filterValues['Time'] ?? '10:00 AM'}',
                          style: TextStyle(color: Colors.green[600], fontSize: 14),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}