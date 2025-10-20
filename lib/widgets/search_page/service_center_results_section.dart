import 'package:flutter/material.dart';
import '../../screens/serviceCenterProfile/service_center_profile.dart';
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
    this.selectedFilters = const [],
    this.filterValues = const {},
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

  // Service center type to image mapping
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
    if (_hasActiveFilters()) {
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
          case 'Distance':
            apiFilters['distance'] = value;
            break;
          case 'Rating':
            apiFilters['rating'] = value;
            break;
          case 'Language':
            apiFilters['language'] = value;
            break;
        }
      });

      if (widget.selectedFilters.contains('Open Now')) {
        apiFilters['openNow'] = 'true';
      }
      if (widget.selectedFilters.contains('Special Offers')) {
        apiFilters['hasOffers'] = 'true';
      }

      final result = await SearchService.searchServiceCenters(
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
          _errorMessage = result['message'] ?? 'Failed to search service centers';
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
      // Load different sections for service centers
      final sections = [
        'featured',
        'top',
        'nearby', 
        'offers'
      ];

      Map<String, List<dynamic>> sectionData = {};

      for (String section in sections) {
        final result = await SearchService.getFeaturedResults(
          type: 'service_center',
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

  String _getServiceCenterImage(String serviceCenterType) {
    return serviceCenterImages[serviceCenterType.toLowerCase()] ?? serviceCenterImages['default']!;
  }

  bool _hasActiveFilters() {
    return widget.selectedService.isNotEmpty || 
           widget.searchQuery.isNotEmpty || 
           widget.selectedFilters.isNotEmpty;
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

    if (!_hasActiveFilters()) {
      return _buildDefaultSections();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildDefaultSections() {
    if (_sectionResults.isEmpty) {
      return Center(
        child: Text('No data available'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHorizontalSection('Featured Service Centers', _sectionResults['featured'] ?? []),
          SizedBox(height: 25),
          _buildHorizontalSection('Top Rated Centers', _sectionResults['top'] ?? []),
          SizedBox(height: 25),
          _buildHorizontalSection('Nearby Centers', _sectionResults['nearby'] ?? []),
          SizedBox(height: 25),
          _buildHorizontalSection('Special Offers', _sectionResults['offers'] ?? []),
        ],
      ),
    );
  }

  Widget _buildHorizontalSection(String title, List<dynamic> data) {
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
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: data.length > 5 ? 5 : data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return _buildHorizontalCard(item, title.contains('Offers'));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard(dynamic item, bool hasOffer) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceCenterProfile(serviceCenterId: "qlDkCV4HUFNGoFMX1WAjdfnqPg42"),
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
                    child: _buildServiceCenterImage(item),
                  ),
                  if (hasOffer || item['hasOffer'] == true)
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
                  if ((item['rating'] ?? 0) >= 4.5)
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
                    item['businessName'] ?? 'Service Center',
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
                      Icon(Icons.location_on, color: Colors.grey[600], size: 14),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${item['distance'] ?? 5} km away',
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
                        ' ${(item['rating'] ?? 4.5).toStringAsFixed(1)}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        ' (${item['totalServices'] ?? 150}+)',
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
      ),
    );
  }

  Widget _buildServiceCenterImage(dynamic item) {
    final businessType = item['businessType'] ?? 'default';
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey[200],
      child: Image.asset(
        _getServiceCenterImage(businessType),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.business,
            color: Colors.grey[400],
            size: 40,
          );
        },
      ),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.selectedService.isNotEmpty ? widget.selectedService : "Service"} Centers',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${_searchResults.length} centers found',
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        Expanded(
          child: _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No service centers found',
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
            builder: (context) => ServiceCenterProfile(serviceCenterId: "qlDkCV4HUFNGoFMX1WAjdfnqPg42"),
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
                    child: _buildServiceCenterImage(item),
                  ),
                  if (item['hasOffer'] == true)
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
                    item['businessName'] ?? 'Service Center',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    item['businessType'] ?? 'Service',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['address'] ?? 'Address not available',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
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
                        ' (${item['totalServices'] ?? 100}+ services)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      Text(
                        ' • ${item['distance'] ?? 5} km',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.green,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Open Now',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item['phone'] != null) ...[
                        Text(
                          ' • ${item['phone']}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
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
}