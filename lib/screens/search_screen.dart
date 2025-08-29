import 'package:flutter/material.dart';
import '../widgets/search_page/address_button.dart';
import '../widgets/search_page/search_bar_widget.dart';
import '../widgets/search_page/service_categories.dart';
import '../widgets/search_page/filter_section.dart';
import '../widgets/search_page/results_section.dart';

class SearchPage extends StatefulWidget {
  @override
  const SearchPage({super.key});
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
    // Here you can implement additional filtering logic if needed
    // The ResultsSection will handle the display logic
  }

  void _resetFilters() {
    setState(() {
      selectedService = '';
      searchQuery = '';
      selectedFilters.clear();
      filterValues.clear();
    });
    
    // Call the reset callback if available to reset FilterSection state
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
      body: SafeArea(
        child: Column(
          children: [
            // Top section with address
            Padding(
              padding: EdgeInsets.all(16.0),
              child: AddressButton(),
            ),
            
            // Search bar - now navigates to detailed search
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBarWidget(onSearchChanged: _onSearchChanged),
            ),
            
            SizedBox(height: 16),
            
            // Service categories
            ServiceCategories(
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
            
            // Results section - Now properly receives all filter data
            Expanded(
              child: ResultsSection(
                selectedService: selectedService,
                searchQuery: searchQuery,
                selectedFilters: selectedFilters,
                filterValues: filterValues,
                onResetFilters: _resetFilters,
              ),
            ),
          ],
        ),
      ),
    );
  }
}