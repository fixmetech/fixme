import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final Function(List<String>, Map<String, String>) onFiltersChanged;
  final Function(VoidCallback) onSetResetCallback;

  const FilterSection({
    Key? key,
    required this.onFiltersChanged,
    required this.onSetResetCallback,
  }) : super(key: key);

  @override
  _FilterSectionState createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  List<String> selectedFilters = [];
  Map<String, String> filterValues = {}; // Store selected values for filters like visiting fee

  @override
  void initState() {
    super.initState();
    // Provide the reset callback to parent
    widget.onSetResetCallback(resetFilters);
  }

  final List<String> filters = [
    'Visiting Fee',
    'Date',
    'Time',
    'Price',
    'Language',
    'Rating',
    'Distance',
    'Highly Rated',
  ];

  void _toggleFilter(String filter) {
    setState(() {
      if (filter == 'Visiting Fee') {
        _showVisitingFeePopup();
      } else if (filter == 'Highly Rated') {
        // Handle Highly Rated - toggle only
        if (selectedFilters.contains(filter)) {
          selectedFilters.remove(filter);
        } else {
          selectedFilters.add(filter);
        }
        widget.onFiltersChanged(selectedFilters, filterValues);
      } else {
        // For other filters, just toggle for now
        if (selectedFilters.contains(filter)) {
          selectedFilters.remove(filter);
          filterValues.remove(filter);
        } else {
          selectedFilters.add(filter);
        }
        widget.onFiltersChanged(selectedFilters, filterValues);
      }
    });
  }

  void _showVisitingFeePopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16),
              
              // Title
              Text(
                'Visiting Fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              
              // Fee options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFeeOption('Under Rs.59', 'Rs.39', 'Rs.59'),
                    _buildFeeOption('Rs.59 - Rs.79', 'Rs.59', 'Rs.79'),
                    _buildFeeOption('Rs.79 - Rs.99', 'Rs.79', 'Rs.99'),
                    _buildFeeOption('Rs.99+', 'Rs.99', 'Rs.99+'),
                  ],
                ),
              ),
              
              // Bottom buttons
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Reset',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Apply',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeeOption(String label, String minFee, String maxFee) {
    bool isSelected = filterValues['Visiting Fee'] == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          filterValues['Visiting Fee'] = label;
          if (!selectedFilters.contains('Visiting Fee')) {
            selectedFilters.add('Visiting Fee');
          }
        });
        widget.onFiltersChanged(selectedFilters, filterValues);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }

  void resetFilters() {
    setState(() {
      selectedFilters.clear();
      filterValues.clear();
    });
    widget.onFiltersChanged(selectedFilters, filterValues);
  }

  String _getFilterDisplayText(String filter) {
    if (filterValues.containsKey(filter)) {
      return filterValues[filter]!;
    }
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length + 1, // +1 for sort button
        itemBuilder: (context, index) {
          if (index == filters.length) {
            // Sort button at the end
            return Container(
              margin: EdgeInsets.only(left: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle sort
                },
                icon: Icon(Icons.sort, size: 16, color: Colors.grey[700]),
                label: Text(
                  'Sort',
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            );
          }

          final filter = filters[index];
          final isSelected = selectedFilters.contains(filter);

          return Container(
            margin: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                _getFilterDisplayText(filter),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                _toggleFilter(filter);
              },
              backgroundColor: Colors.grey[100],
              selectedColor: const Color.fromARGB(255, 134, 200, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color.fromARGB(255, 134, 200, 255) : Colors.grey[300]!,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}