import 'package:flutter/material.dart';
import '../../screens/search_results_screen.dart';

class DetailedSearchScreen extends StatefulWidget {
  @override
  _DetailedSearchScreenState createState() => _DetailedSearchScreenState();
}

class _DetailedSearchScreenState extends State<DetailedSearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _recentSearches = ['AC Repair', 'Plumbing', 'Electrician', 'Car Service', 'Towing'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // Add to recent searches if not already present
      if (!_recentSearches.contains(query)) {
        setState(() {
          _recentSearches.insert(0, query);
          if (_recentSearches.length > 10) {
            _recentSearches.removeLast();
          }
        });
      }
      
      // Navigate to search results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(
            searchQuery: query,
            category: _getSelectedCategory(),
          ),
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
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onSubmitted: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Search FixMe Services',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
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
        ..._recentSearches.map((search) => _buildSearchItem(search, Icons.history)),
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
        ...searches.map((search) => _buildSearchItem(search, Icons.history)),
      ],
    );
  }

  Widget _buildSearchItem(String text, IconData icon) {
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
            Text(
              text,
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

  Widget _buildCategoryItem(String name, IconData icon) {
    return InkWell(
      onTap: () => _performSearch(name),
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