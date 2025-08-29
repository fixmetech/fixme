import 'package:flutter/material.dart';
import '../widgets/search_page/filter_section.dart';
import '../widgets/search_page/results_section.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  final String category;

  const SearchResultsScreen({
    Key? key,
    required this.searchQuery,
    required this.category,
  }) : super(key: key);

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<String> selectedFilters = [];
  Map<String, String> filterValues = {};
  VoidCallback? _resetFiltersCallback;

  void _onFiltersChanged(List<String> filters, Map<String, String> values) {
    setState(() {
      selectedFilters = filters;
      filterValues = values;
    });
  }

  void _resetFilters() {
    setState(() {
      selectedFilters.clear();
      filterValues.clear();
    });
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
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              SizedBox(width: 12),
              Icon(Icons.search, color: Colors.grey[500], size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.searchQuery,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
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
          // Filter section
          FilterSection(
            onFiltersChanged: _onFiltersChanged,
            onSetResetCallback: _setResetCallback,
          ),
          
          SizedBox(height: 8),
          
          // Results section - Now properly receives all filter data
          Expanded(
            child: ResultsSection(
              selectedService: widget.category,
              searchQuery: widget.searchQuery,
              selectedFilters: selectedFilters,
              filterValues: filterValues,
              onResetFilters: _resetFilters,
            ),
          ),
        ],
      ),
    );
  }
}