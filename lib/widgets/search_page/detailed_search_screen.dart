import 'package:flutter/material.dart';
import '../../screens/search_results_screen.dart';
import '../../services/search_service.dart';

class DetailedSearchScreen extends StatefulWidget {
  @override
  _DetailedSearchScreenState createState() => _DetailedSearchScreenState();
}

class _DetailedSearchScreenState extends State<DetailedSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _recentSearches = [];
  bool _isLoadingRecentSearches = false;
  bool _isSearching = false;
  
  // Mock user ID - replace with actual user ID from authentication
  String get currentUserId => 'test-user-123';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadRecentSearches();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      _loadRecentSearches();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadRecentSearches() async {
    setState(() {
      _isLoadingRecentSearches = true;
    });

    try {
      final category = _getSelectedCategory();
      final response = await SearchService.getRecentSearches(
        userId: currentUserId,
        category: category,
        limit: 5,
      );

      if (response['success'] == true) {
        setState(() {
          _recentSearches = List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      } else {
        // Fallback to static data if API fails
        setState(() {
          _recentSearches = [
            {'query': 'AC Repair', 'category': 'All'},
            {'query': 'Plumbing', 'category': 'All'},
            {'query': 'Electrician', 'category': 'All'},
            {'query': 'Car Service', 'category': 'All'},
            {'query': 'Towing', 'category': 'All'},
          ];
        });
      }
    } catch (e) {
      print('Error loading recent searches: $e');
      // Fallback to static data
      setState(() {
        _recentSearches = [
          {'query': 'AC Repair', 'category': 'All'},
          {'query': 'Plumbing', 'category': 'All'},
          {'query': 'Electrician', 'category': 'All'},
          {'query': 'Car Service', 'category': 'All'},
          {'query': 'Towing', 'category': 'All'},
        ];
      });
    } finally {
      setState(() {
        _isLoadingRecentSearches = false;
      });
    }
  }

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final category = _getSelectedCategory();
      Map<String, dynamic> response;

      // Choose the appropriate search method based on category
      switch (category) {
        case 'All':
          response = await SearchService.searchAll(
            query: query,
            userId: currentUserId,
          );
          break;
        case 'Technicians':
          response = await SearchService.searchTechniciansWithHistory(
            query: query,
            userId: currentUserId,
          );
          break;
        case 'Service Centers':
          response = await SearchService.searchServiceCentersWithHistory(
            query: query,
            userId: currentUserId,
          );
          break;
        case 'Towing':
          response = await SearchService.searchTowingServices(
            query: query,
            userId: currentUserId,
          );
          break;
        default:
          response = await SearchService.searchAll(
            query: query,
            userId: currentUserId,
          );
      }

      setState(() {
        _isSearching = false;
      });

      if (response['success'] == true) {
        // Refresh recent searches after successful search
        _loadRecentSearches();
        
        // Navigate to search results
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(
              searchQuery: query,
              category: category,
            ),
          ),
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Search failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterByCategory(String categoryName) async {
    // For category filtering, search only within technicians for that specialization
    // Pass empty query but set the category filter for technician specializations
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          searchQuery: '', // Empty search query for browsing
          category: 'Technicians', // Always filter technicians for category selection
          specializationFilter: categoryName.toLowerCase(), // The specific specialization
        ),
      ),
    );
  }

  void _removeRecentSearch(String searchId) async {
    try {
      final response = await SearchService.deleteSearchHistoryItem(
        userId: currentUserId,
        searchId: searchId,
      );

      if (response['success'] == true) {
        _loadRecentSearches(); // Refresh the list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search removed from history'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove search'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing search: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getSelectedCategory() {
    switch (_tabController.index) {
      case 0:
        return 'All';
      case 1:
        return 'Technicians';
      case 2:
        return 'Service Centers';
      case 3:
        return 'Towing';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.black87),
                onChanged: (value) {
                  // Handle search input changes if needed
                },
                onSubmitted: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search FixMe Services',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon: _isSearching 
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          // Tab bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue[600],
              indicatorWeight: 2,
              labelColor: Colors.blue[600],
              unselectedLabelColor: Colors.grey[600],
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Technicians'),
                Tab(text: 'Service Centers'),
                Tab(text: 'Towing'),
              ],
            ),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllTab(),
                _buildTechniciansTab(),
                _buildServiceCentersTab(),
                _buildTowingTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSection(),
        ],
      ),
    );
  }

  Widget _buildTechniciansTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSection(),
          _buildTopCategoriesSection(),
        ],
      ),
    );
  }

  Widget _buildServiceCentersTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSection(),
          _buildTopSearchesSection([
            'Car Service',
            'Bike Service',
            'AC Service',
            'Washing Machine',
            'Refrigerator',
            'TV Repair',
          ]),
        ],
      ),
    );
  }

  Widget _buildTowingTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRecentSection(),
          _buildTopSearchesSection([
            'Emergency Towing',
            'Car Breakdown',
            'Roadside Assistance',
            'Vehicle Recovery',
            'Accident Towing',
            'Bike Towing',
          ]),
        ],
      ),
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Recent',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_isLoadingRecentSearches)
          Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_recentSearches.isEmpty)
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No recent searches',
              style: TextStyle(color: Colors.grey[500]),
            ),
          )
        else
          ..._recentSearches.map((search) => _buildSearchItem(
            search['query']?.toString() ?? search.toString(), 
            Icons.history,
            searchId: search['id']?.toString(),
          )),
      ],
    );
  }

  Widget _buildTopCategoriesSection() {
    final categories = [
      {'name': 'ELECTRICIANS', 'icon': Icons.electrical_services},
      {'name': 'PLUMBERS', 'icon': Icons.plumbing},
      {'name': 'HVAC', 'icon': Icons.air},
      {'name': 'PAINTERS', 'icon': Icons.format_paint},
      {'name': 'CARPENTERS', 'icon': Icons.construction},
      {'name': 'GARDENERS', 'icon': Icons.local_florist},
      {'name': 'CLEANERS', 'icon': Icons.cleaning_services},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Top categories',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...categories.map((category) => _buildCategoryItem(
          category['name'] as String,
          category['icon'] as IconData,
        )),
      ],
    );
  }

  Widget _buildTopSearchesSection(List<String> searches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Top searches',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...searches.map((search) => _buildSearchItem(search, Icons.history, searchId: null)),
      ],
    );
  }

  Widget _buildSearchItem(String text, IconData icon, {String? searchId}) {
    return InkWell(
      onTap: () => _performSearch(text),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[500], size: 20),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
            if (searchId != null && icon == Icons.history)
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey[400], size: 18),
                onPressed: () => _removeRecentSearch(searchId),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    return InkWell(
      onTap: () => _filterByCategory(name),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCategoryColor(name),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 16),
            Text(
              name,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ELECTRICIANS':
        return Colors.amber[600]!;
      case 'PLUMBERS':
        return Colors.blue[600]!;
      case 'HVAC':
        return Colors.cyan[600]!;
      case 'PAINTERS':
        return Colors.purple[600]!;
      case 'CARPENTERS':
        return Colors.brown[600]!;
      case 'GARDENERS':
        return Colors.green[600]!;
      case 'CLEANERS':
        return Colors.teal[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}