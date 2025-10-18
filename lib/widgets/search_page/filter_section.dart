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
  Map<String, String> filterValues = {};

  // State variables for sliders
  double priceRange = 200; // Updated to match backend range
  double ratingValue = 2.0; // Updated to match backend 2.0-5.0 range
  double distanceRange = 10;
  double experienceValue = 1; // New for experience filter

  @override
  void initState() {
    super.initState();
    widget.onSetResetCallback(resetFilters);
  }

  final List<String> filters = [
    'Visiting Fee',
    'Price',
    'Language',
    'Rating',
    'Distance',
    'Experience',
    'Availability',
    'Highly Rated',
  ];

  void _toggleFilter(String filter) {
    setState(() {
      if (filter == 'Visiting Fee') {
        _showVisitingFeePopup();
      } else if (filter == 'Price') {
        _showPriceRangePopup();
      } else if (filter == 'Language') {
        _showLanguagePopup();
      } else if (filter == 'Rating') {
        _showRatingPopup();
      } else if (filter == 'Distance') {
        _showDistancePopup();
      } else if (filter == 'Experience') {
        _showExperiencePopup();
      } else if (filter == 'Availability') {
        if (selectedFilters.contains(filter)) {
          selectedFilters.remove(filter);
        } else {
          selectedFilters.add(filter);
        }
        widget.onFiltersChanged(selectedFilters, filterValues);
      } else if (filter == 'Highly Rated') {
        if (selectedFilters.contains(filter)) {
          selectedFilters.remove(filter);
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
              _buildHandle(),
              SizedBox(height: 16),
              Text(
                'Visiting Fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFeeOption('Under Rs.50', 'Rs.0', 'Rs.50'),
                    _buildFeeOption('Rs.50 - Rs.100', 'Rs.50', 'Rs.100'),
                    _buildFeeOption('Rs.100 - Rs.150', 'Rs.100', 'Rs.150'),
                    _buildFeeOption('Rs.150+', 'Rs.150', 'Rs.200'),
                  ],
                ),
              ),
              _buildBottomButtons('Visiting Fee'),
            ],
          ),
        );
      },
    );
  }

  void _showPriceRangePopup() {
    double tempPriceRange = priceRange;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildHandle(),
                  SizedBox(height: 16),
                  Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          'Up to Rs.${tempPriceRange.toInt()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Rs.0', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Expanded(
                              child: Slider(
                                value: tempPriceRange,
                                min: 0,
                                max: 200, // Updated to match backend range
                                divisions: 20,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey[300],
                                onChanged: (value) {
                                  setModalState(() {
                                    tempPriceRange = value;
                                  });
                                },
                              ),
                            ),
                            Text('Rs.200', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  _buildBottomButtonsWithActions(
                    'Price',
                    onApply: () {
                      setState(() {
                        priceRange = tempPriceRange;
                        // Create a new map to ensure change detection
                        Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
                        newFilterValues['Price'] = 'Up to Rs.${tempPriceRange.toInt()}';
                        filterValues = newFilterValues;
                        
                        if (!selectedFilters.contains('Price')) {
                          selectedFilters = List<String>.from(selectedFilters)..add('Price');
                        }
                      });
                      widget.onFiltersChanged(selectedFilters, filterValues);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      setModalState(() {
                        tempPriceRange = 200; // Updated default
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguagePopup() {
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
              _buildHandle(),
              SizedBox(height: 16),
              Text(
                'Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildLanguageOption('Sinhala'),
                    _buildLanguageOption('English'),
                    _buildLanguageOption('Tamil'),
                  ],
                ),
              ),
              _buildBottomButtons('Language'),
            ],
          ),
        );
      },
    );
  }

  void _showRatingPopup() {
    double tempRating = ratingValue;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildHandle(),
                  SizedBox(height: 16),
                  Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          'Over ${tempRating.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text('2.0+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  2.5+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  3.0+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  3.5+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  4.0+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  4.5+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  5.0', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                        Slider(
                          value: tempRating,
                          min: 2.0, // Updated to match backend
                          max: 5.0,
                          divisions: 6, // 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            setModalState(() {
                              tempRating = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  _buildBottomButtonsWithActions(
                    'Rating',
                    onApply: () {
                      setState(() {
                        ratingValue = tempRating;
                        // Create a new map to ensure change detection
                        Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
                        newFilterValues['Rating'] = 'Over ${tempRating.toStringAsFixed(1)}';
                        filterValues = newFilterValues;
                        
                        if (!selectedFilters.contains('Rating')) {
                          selectedFilters = List<String>.from(selectedFilters)..add('Rating');
                        }
                      });
                      widget.onFiltersChanged(selectedFilters, filterValues);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      setModalState(() {
                        tempRating = 2.0; // Updated default
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDistancePopup() {
    double tempDistance = distanceRange;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildHandle(),
                  SizedBox(height: 16),
                  Text(
                    'Distance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          'Within ${tempDistance.toInt()} km',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text('1km', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Expanded(
                              child: Slider(
                                value: tempDistance,
                                min: 1,
                                max: 50,
                                divisions: 49,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey[300],
                                onChanged: (value) {
                                  setModalState(() {
                                    tempDistance = value;
                                  });
                                },
                              ),
                            ),
                            Text('50km', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  _buildBottomButtonsWithActions(
                    'Distance',
                    onApply: () {
                      setState(() {
                        distanceRange = tempDistance;
                        // Create a new map to ensure change detection
                        Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
                        newFilterValues['Distance'] = 'Within ${tempDistance.toInt()} km';
                        filterValues = newFilterValues;
                        
                        if (!selectedFilters.contains('Distance')) {
                          selectedFilters = List<String>.from(selectedFilters)..add('Distance');
                        }
                      });
                      widget.onFiltersChanged(selectedFilters, filterValues);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      setModalState(() {
                        tempDistance = 10;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showExperiencePopup() {
    double tempExperience = experienceValue;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  _buildHandle(),
                  SizedBox(height: 16),
                  Text(
                    'Experience',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Text(
                          '${tempExperience.toInt()}+ years experience',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text('1yr', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Expanded(
                              child: Slider(
                                value: tempExperience,
                                min: 1,
                                max: 20,
                                divisions: 19,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey[300],
                                onChanged: (value) {
                                  setModalState(() {
                                    tempExperience = value;
                                  });
                                },
                              ),
                            ),
                            Text('20yr', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  _buildBottomButtonsWithActions(
                    'Experience',
                    onApply: () {
                      setState(() {
                        experienceValue = tempExperience;
                        // Create a new map to ensure change detection
                        Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
                        newFilterValues['Experience'] = '${tempExperience.toInt()}+ years';
                        filterValues = newFilterValues;
                        
                        if (!selectedFilters.contains('Experience')) {
                          selectedFilters = List<String>.from(selectedFilters)..add('Experience');
                        }
                      });
                      widget.onFiltersChanged(selectedFilters, filterValues);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      setModalState(() {
                        tempExperience = 1;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortPopup() {
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
              _buildHandle(),
              SizedBox(height: 16),
              Text(
                'Sort',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildSortOption('Rating'),
                    _buildSortOption('Price'),
                    _buildSortOption('Distance'),
                    _buildSortOption('Experience'),
                    _buildSortOption('Recent'),
                    _buildSortOption('Availability'),
                  ],
                ),
              ),
              _buildBottomButtons('Sort'),
            ],
          ),
        );
      },
    );
  }

  // Helper widgets
  Widget _buildHandle() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildFeeOption(String label, String minFee, String maxFee) {
    bool isSelected = filterValues['Visiting Fee'] == label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          // Create a new map to ensure change detection
          Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
          newFilterValues['Visiting Fee'] = label;
          filterValues = newFilterValues;
          
          if (!selectedFilters.contains('Visiting Fee')) {
            selectedFilters = List<String>.from(selectedFilters)..add('Visiting Fee');
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

  Widget _buildLanguageOption(String language) {
    bool isSelected = filterValues['Language'] == language;
    
    return GestureDetector(
      onTap: () {
        // Debug logging
        print('Language filter tapped: $language');
        print('Current filterValues before change: $filterValues');
        
        setState(() {
          // Create a new map to ensure change detection
          Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
          newFilterValues['Language'] = language;
          filterValues = newFilterValues;
          
          // Ensure Language is in selectedFilters
          if (!selectedFilters.contains('Language')) {
            selectedFilters = List<String>.from(selectedFilters)..add('Language');
          }
        });
        
        // Debug logging after state change
        print('Language filter changed to: $language');
        print('Current filterValues after change: $filterValues');
        print('Current selectedFilters: $selectedFilters');
        
        // Trigger the callback immediately
        widget.onFiltersChanged(selectedFilters, filterValues);
        
        // Small delay before closing popup to ensure state is updated
        Future.delayed(Duration(milliseconds: 100), () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
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
              language,
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

  Widget _buildSortOption(String option) {
    bool isSelected = filterValues['Sort'] == option;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          // Create a new map to ensure change detection
          Map<String, String> newFilterValues = Map<String, String>.from(filterValues);
          newFilterValues['Sort'] = option;
          filterValues = newFilterValues;
          
          if (!selectedFilters.contains('Sort')) {
            selectedFilters = List<String>.from(selectedFilters)..add('Sort');
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
              option,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
            if (isSelected)
              Icon(Icons.radio_button_checked, color: Colors.blue, size: 20)
            else
              Icon(Icons.radio_button_unchecked, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(String filterType) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedFilters.remove(filterType);
                  filterValues.remove(filterType);
                });
                widget.onFiltersChanged(selectedFilters, filterValues);
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
    );
  }

  Widget _buildBottomButtonsWithActions(String filterType, {required VoidCallback onApply, required VoidCallback onReset}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onReset,
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
              onPressed: onApply,
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
    );
  }

  void resetFilters() {
    setState(() {
      selectedFilters.clear();
      filterValues.clear();
      priceRange = 200; // Updated default
      ratingValue = 2.0; // Updated default
      distanceRange = 10;
      experienceValue = 1; // New default
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
                  _showSortPopup();
                },
                icon: Icon(Icons.sort, size: 16, color: Colors.grey[700]),
                label: Text(
                  _getFilterDisplayText('Sort'),
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