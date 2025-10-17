import 'package:flutter/material.dart';
import '../../features/technician_profile/screens/technician_profile.dart';
import '../../services/search_service.dart';

class ResultsSection extends StatefulWidget {
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

  @override
  _ResultsSectionState createState() => _ResultsSectionState();
}

class _ResultsSectionState extends State<ResultsSection> {
  bool _isLoading = false;
  List<dynamic> _searchResults = [];
  Map<String, List<dynamic>> _sectionResults = {};
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(ResultsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reload data if filters, search query, or service changed
    if (oldWidget.selectedService != widget.selectedService ||
        oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedFilters.length != widget.selectedFilters.length ||
        oldWidget.filterValues.length != widget.filterValues.length) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_hasActiveFilters) {
      await _performSearch();
    } else {
      await _loadFeaturedSections();
    }
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Convert filter values to the format expected by the API
      Map<String, dynamic> apiFilters = {};
      
      widget.filterValues.forEach((key, value) {
        switch (key) {
          case 'Price':
            apiFilters['priceRange'] = value;
            break;
          case 'Rating':
            apiFilters['rating'] = value;
            break;
          case 'Distance':
            apiFilters['distance'] = value;
            break;
          case 'Language':
            apiFilters['language'] = value;
            break;
          case 'Visiting Fee':
            apiFilters['visitingFee'] = value;
            break;
        }
      });

      if (widget.selectedFilters.contains('Highly Rated')) {
        apiFilters['highlyRated'] = 'true';
      }

      final result = await SearchService.searchTechnicians(
        query: widget.searchQuery.isEmpty ? null : widget.searchQuery,
        category: widget.selectedService.isEmpty ? null : widget.selectedService,
        filters: apiFilters,
        page: 1,
        limit: 20,
        sort: widget.filterValues['Sort'] ?? 'rating',
      );

      if (result['success']) {
        setState(() {
          _searchResults = result['data'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to search';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFeaturedSections() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load different sections
      final sections = [
        'featured',
        'top',
        'nearby', 
        'offers'
      ];

      Map<String, List<dynamic>> sectionData = {};

      for (String section in sections) {
        final result = await SearchService.getFeaturedResults(
          type: 'technician',
          section: section,
        );

        if (result['success']) {
          sectionData[section] = result['data'] ?? [];
        } else {
          sectionData[section] = [];
        }
      }

      setState(() {
        _sectionResults = sectionData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

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

  String _getServiceImage(String serviceType) {
    return serviceImages[serviceType.toLowerCase()] ?? serviceImages['default']!;
  }

  // Check if filters are active
  bool get _hasActiveFilters {
    return widget.selectedFilters.isNotEmpty || 
           widget.selectedService.isNotEmpty || 
           widget.searchQuery.isNotEmpty;
  }

  String _getResultsHeaderText() {
    if (widget.selectedService.isNotEmpty && widget.searchQuery.isNotEmpty) {
      return '${widget.selectedService} - "${widget.searchQuery}"';
    } else if (widget.selectedService.isNotEmpty) {
      return widget.selectedService;
    } else if (widget.searchQuery.isNotEmpty) {
      return '"${widget.searchQuery}"';
    } else {
      return 'Filtered';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_hasActiveFilters) {
      return _buildFilteredResults(context);
    } else {
      return _buildDefaultSections(context);
    }
  }

  Widget _buildDefaultSections(BuildContext context) {
    if (_sectionResults.isEmpty) {
      return Center(
        child: Text('No data available'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHorizontalSection(context, 'Featured in FixMe', _sectionResults['featured'] ?? []),
          SizedBox(height: 20),
          _buildHorizontalSection(context, 'Top Technicians', _sectionResults['top'] ?? []),
          SizedBox(height: 20),
          _buildHorizontalSection(context, 'Nearby Services', _sectionResults['nearby'] ?? []),
          SizedBox(height: 20),
          _buildHorizontalSection(context, 'Special Offers', _sectionResults['offers'] ?? []),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection(BuildContext context, String title, List<dynamic> data) {
    if (data.isEmpty) {
      return Container(); // Hide empty sections
    }

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
            itemCount: data.length > 5 ? 5 : data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _buildHorizontalCard(context, item, title.contains('Offers'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard(BuildContext context, dynamic item, bool hasOffer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TechnicianProfile(
              technicianId: item['id'] ?? 'kcdESLLauEJ1UY3bvpkw',
            ),
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
                    child: item['profilePictureUrl'] != null
                        ? Image.network(
                            item['profilePictureUrl'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackImage(item['serviceCategory'] ?? 'Service');
                            },
                          )
                        : _buildFallbackImage(item['serviceCategory'] ?? 'Service'),
                  ),
                  if (hasOffer)
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'Technician',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(
                        ' ${(item['rating'] ?? 4.5).toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        ' • Rs.${item['visitingFee'] ?? 500} Fee',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage(String serviceCategory) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Image.asset(
        _getServiceImage(serviceCategory),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            color: Colors.grey[400],
            size: 40,
          );
        },
      ),
    );
  }

  Widget _buildFilteredResults(BuildContext context) {
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
                      '${_searchResults.length} services found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onResetFilters != null)
                GestureDetector(
                  onTap: widget.onResetFilters,
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
          child: _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters or search query',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return _buildResultCard(_searchResults[index], context);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildResultCard(dynamic item, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TechnicianProfile(
              technicianId: item['id'] ?? 'kcdESLLauEJ1UY3bvpkw',
            ),
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
                    child: item['profilePictureUrl'] != null
                        ? Image.network(
                            item['profilePictureUrl'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildFallbackImage(item['serviceCategory'] ?? 'Service');
                            },
                          )
                        : _buildFallbackImage(item['serviceCategory'] ?? 'Service'),
                  ),
                  if ((item['rating'] ?? 0) >= 4.5)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Highly Rated',
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
                    item['name'] ?? 'Technician',
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
                        ' ${(item['rating'] ?? 4.5).toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                      ),
                      Text(
                        ' (${item['totalJobs'] ?? 100}+ jobs)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        ' • ${item['distance'] ?? 10} km',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Rs.${item['visitingFee'] ?? 500} Visiting Fee',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      if (item['languages'] != null && (item['languages'] as List).isNotEmpty) ...[
                        Text(
                          ' • ${(item['languages'] as List).join(', ')}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                  if (item['isAvailable'] == true) ...[
                    SizedBox(height: 4),
                    Text(
                      'Available now',
                      style: TextStyle(color: Colors.green[600], fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
