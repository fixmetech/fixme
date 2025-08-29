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
  double priceRange = 1000;
  double ratingValue = 4.5;
  double distanceRange = 10;

  @override
  void initState() {
    super.initState();
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
      } else if (filter == 'Date') {
        _showDatePicker();
      } else if (filter == 'Time') {
        _showTimePicker();
      } else if (filter == 'Price') {
        _showPriceRangePopup();
      } else if (filter == 'Language') {
        _showLanguagePopup();
      } else if (filter == 'Rating') {
        _showRatingPopup();
      } else if (filter == 'Distance') {
        _showDistancePopup();
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
                    _buildFeeOption('Under Rs.59', 'Rs.39', 'Rs.59'),
                    _buildFeeOption('Rs.59 - Rs.79', 'Rs.59', 'Rs.79'),
                    _buildFeeOption('Rs.79 - Rs.99', 'Rs.79', 'Rs.99'),
                    _buildFeeOption('Rs.99+', 'Rs.99', 'Rs.99+'),
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

  void _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        filterValues['Date'] = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
        if (!selectedFilters.contains('Date')) {
          selectedFilters.add('Date');
        }
      });
      widget.onFiltersChanged(selectedFilters, filterValues);
    }
  }

  void _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        filterValues['Time'] = pickedTime.format(context);
        if (!selectedFilters.contains('Time')) {
          selectedFilters.add('Time');
        }
      });
      widget.onFiltersChanged(selectedFilters, filterValues);
    }
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
                                max: 5000,
                                divisions: 50,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.grey[300],
                                onChanged: (value) {
                                  setModalState(() {
                                    tempPriceRange = value;
                                  });
                                },
                              ),
                            ),
                            Text('Rs.5000', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
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
                        filterValues['Price'] = 'Up to Rs.${tempPriceRange.toInt()}';
                        if (!selectedFilters.contains('Price')) {
                          selectedFilters.add('Price');
                        }
                      });
                      widget.onFiltersChanged(selectedFilters, filterValues);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      setModalState(() {
                        tempPriceRange = 1000;
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
                            Text('3+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  3.5+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  4+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  4.5+', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            Text('  5', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                          ],
                        ),
                        Slider(
                          value: tempRating,
                          min: 3.0,
                          max: 5.0,
                          divisions: 8,
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
                        filterValues['Rating'] = 'Over ${tempRating.toStringAsFixed(1)}';
                        if (!selectedFilters.contains('Rating')) {
                          selectedFilters.add('Rating');
                        }
                      });
                      widget.onFiltersChanged(selectedFilters, filterValues);
                      Navigator.pop(context);
                    },
                    onReset: () {
                      setModalState(() {
                        tempRating = 4.5;
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
                        filterValues['Distance'] = 'Within ${tempDistance.toInt()} km';
                        if (!selectedFilters.contains('Distance')) {
                          selectedFilters.add('Distance');
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
                    _buildSortOption('Recommended'),
                    _buildSortOption('Rating'),
                    _buildSortOption('Distance'),
                    _buildSortOption('Price'),
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

  Widget _buildLanguageOption(String language) {
    bool isSelected = filterValues['Language'] == language;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          filterValues['Language'] = language;
          if (!selectedFilters.contains('Language')) {
            selectedFilters.add('Language');
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
          filterValues['Sort'] = option;
          if (!selectedFilters.contains('Sort')) {
            selectedFilters.add('Sort');
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
      priceRange = 1000;
      ratingValue = 4.5;
      distanceRange = 10;
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