import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';

class FindHelp extends StatefulWidget {
  const FindHelp({super.key});

  @override
  State<FindHelp> createState() => _FindHelpState();
}

class _FindHelpState extends State<FindHelp> with TickerProviderStateMixin {
  late GoogleMapController mapController;
  late AnimationController _animationController;
  LatLng? _currentPosition;
  bool _isSearching = false;
  LatLng? _selectedLocation;
  String _currentAddress = "-";

  // Search states
  SearchState _searchState = SearchState.initial;
  Map<String, dynamic>? _foundTechnician;

  // Draggable sheet controller
  final DraggableScrollableController _dragController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final futures = await Future.wait([
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      Future.delayed(const Duration(seconds: 1)), // Minimum 2 second delay
    ]);

    final position = futures[0] as Position;

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _startSearching() async {
    setState(() {
      _isSearching = true;
      _searchState = SearchState.searching;
    });

    _dragController.animateTo(
      0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Simulate searching process
    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      _searchState = SearchState.found;
      _foundTechnician = {
        'name': 'John Smith',
        'rating': 4.8,
        'experience': '5 years',
        'specialization': 'AC Repair & Maintenance',
        'distance': '0.8 km away',
        'phone': '+1 234 567 8900',
        'image': 'https://via.placeholder.com/80',
        'estimatedArrival': '15-20 minutes',
        'price': '\$45-65',
        'completedJobs': 245,
      };
      _isSearching = false;
    });

    // Auto-expand the bottom sheet when technician is found
    _dragController.animateTo(
      0.6,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "OK") {
          final results = data["results"] as List;
          if (results.isNotEmpty) {
            setState(() {
              _currentAddress = results.first["formatted_address"];
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _resetSearch() {
    setState(() {
      _searchState = SearchState.initial;
      _foundTechnician = null;
      _isSearching = false;
    });
    _dragController.animateTo(
      0.25,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Lottie.asset(
                    'assets/animations/mapload.json',
                    repeat: true,
                    animate: true,
                    fit: BoxFit.contain,
                    frameRate: FrameRate.max, // For smooth animation
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 18,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  onCameraMove: (position) {
                    setState(() {
                      _selectedLocation = position.target;
                    });
                  },
                  onCameraIdle: () {
                    if (_selectedLocation != null) {
                      _getAddressFromLatLng(_selectedLocation!);
                    }
                  },
                ),

                // Location button
                Positioned(
                  bottom: 220,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      final position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );
                      mapController.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(position.latitude, position.longitude),
                        ),
                      );
                    },
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ),

                // Center marker
                const Center(
                  child: Icon(
                    Icons.person_pin_circle,
                    size: 45,
                    color: Colors.red,
                  ),
                ),

                // Back button
                Positioned(
                  top: 48,
                  left: 16,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                ),

                // Draggable Bottom Sheet
                DraggableScrollableSheet(
                  controller: _dragController,
                  initialChildSize: _getInitialSize(),
                  minChildSize: _getMinSize(),
                  maxChildSize: _getMaxSize(),
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            // Drag handle
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            _buildBottomSheetContent(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _buildBottomSheetContent() {
    switch (_searchState) {
      case SearchState.initial:
        return _buildInitialContent();
      case SearchState.searching:
        return _buildSearchingContent();
      case SearchState.found:
        return _buildFoundContent();
    }
  }

  Widget _buildInitialContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Confirm Your Location",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentAddress.isEmpty
                ? "Loading address..."
                : "📍 $_currentAddress",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startSearching,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Find Technician",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Lottie animation instead of CircularProgressIndicator
          SizedBox(
            width: 120,
            height: 120,
            child: Lottie.asset(
              'assets/animations/findPerson.json', // Your Lottie file
              repeat: true,
              animate: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "🔍 Searching for technicians nearby...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Please wait while we find the best technician for you",
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFoundContent() {
    if (_foundTechnician == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  "Technician Found!",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Technician card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        _foundTechnician!['name']
                            .split(' ')
                            .map((n) => n[0])
                            .join(),
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _foundTechnician!['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber[600],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${_foundTechnician!['rating']} • ${_foundTechnician!['completedJobs']} jobs",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _foundTechnician!['specialization'],
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Quick info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoChip(
                      Icons.location_on,
                      _foundTechnician!['distance'],
                    ),
                    _buildInfoChip(
                      Icons.access_time,
                      _foundTechnician!['estimatedArrival'],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetSearch,
                  icon: const Icon(Icons.search),
                  label: const Text("Find Another"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Contact button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle call
              },
              icon: const Icon(Icons.phone),
              label: Text("Call ${_foundTechnician!['phone']}"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for size management
  double _getInitialSize() {
    switch (_searchState) {
      case SearchState.initial:
        return 0.25;
      case SearchState.searching:
        return 0.4; // Fits searching animation and text
      case SearchState.found:
        return 0.6;
    }
  }

  double _getMinSize() {
    switch (_searchState) {
      case SearchState.initial:
        return 0.25;
      case SearchState.searching:
        return 0.35; // Minimum to show searching content properly
      case SearchState.found:
        return 0.3;
    }
  }

  double _getMaxSize() {
    switch (_searchState) {
      case SearchState.initial:
        return 0.3;
      case SearchState.searching:
        return 0.5; // Allow some expansion but not full screen
      case SearchState.found:
        return 0.9;
    }
  }

  List<double> _getSnapSizes() {
    switch (_searchState) {
      case SearchState.initial:
        return [0.25, 0.3];
      case SearchState.searching:
        return [0.35, 0.4, 0.5];
      case SearchState.found:
        return [0.3, 0.6, 0.9];
    }
  }
}

enum SearchState { initial, searching, found }
