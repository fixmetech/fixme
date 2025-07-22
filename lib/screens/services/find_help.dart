import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:fixme/screens/services/controllers/map_controllers.dart';
import 'package:fixme/screens/services/found_technician.dart';

class FindHelp extends StatefulWidget {
  const FindHelp({super.key});

  @override
  State<FindHelp> createState() => _FindHelpState();
}

class _FindHelpState extends State<FindHelp> with TickerProviderStateMixin {
  late GoogleMapController mapController;
  late AnimationController _animationController;
  LatLng? _currentPosition;
  LatLng? _selectedLocation;
  String _currentAddress = "Getting your location...";
  Set<Marker> _markers = {};

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
    debugPrint('Getting current location...');
    final position = await MapControllers.getCurrentLocation();
    if (position != null) {
      debugPrint(
        'Location obtained: ${position.latitude}, ${position.longitude}',
      );
      setState(() {
        _currentPosition = position;
      });
      // Load address immediately after getting location
      _getAddressFromLatLng(position);
      // Add technician markers after location is available
      _addTechnicianMarkers();
    } else {
      debugPrint('Failed to get current location');
      setState(() {
        _currentAddress = "Location not available";
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    MapControllers.setMapController(controller);
  }

  void _startSearching() async {
    setState(() {
      _searchState = SearchState.searching;
    });

    _dragController.animateTo(
      0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Add technician markers when starting search
    await _addTechnicianMarkers();

    // Simulate searching process
    await Future.delayed(const Duration(seconds: 10));

    setState(() {
      _searchState = SearchState.found;
      _foundTechnician = {
        'name': 'Abishek Korala',
        'rating': 4.8,
        'experience': '3 years',
        'specialization': 'Car Repair & Maintenance',
        'distance': '2.8 km away',
        'phone': '+94743383502',
        'image': 'https://via.placeholder.com/80',
        'estimatedArrival': '15-20 minutes',
        'price': '\$45-65',
        'completedJobs': 245,
      };
    });

    // Auto-expand the bottom sheet when technician is found
    _dragController.animateTo(
      0.6,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _addTechnicianMarkers() async {
    if (_currentPosition == null) {
      debugPrint('Cannot add markers: current position is null');
      return;
    }

    debugPrint(
      'Adding technician markers around: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
    );

    final baseLat = _currentPosition!.latitude;
    final baseLng = _currentPosition!.longitude;

    // Use simpler fallback icon for now
    BitmapDescriptor technicianIcon;
    try {
      technicianIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(14, 14)),
        'assets/images/manpointer1.png',
      );
      debugPrint('Successfully loaded custom technician icon');
    } catch (e) {
      debugPrint('Failed to load custom icon, using fallback: $e');
      technicianIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      );
    }

    // Technician data with closer locations (within ~200-500 meters)
    List<Map<String, dynamic>> technicians = [
      {
        'location': LatLng(baseLat + 0.0008, baseLng + 0.0005), // ~100m away
      },
      {
        'location': LatLng(baseLat - 0.0006, baseLng + 0.0009), // ~150m away
      },
      {
        'location': LatLng(baseLat + 0.0012, baseLng - 0.0008), // ~200m away
      },
      {
        'location': LatLng(baseLat - 0.0015, baseLng - 0.0010), // ~300m away
      },
      {
        'location': LatLng(baseLat - 0.0005, baseLng + 0.0018), // ~400m away
      },
    ];

    final newMarkers = technicians.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> tech = entry.value;
      return Marker(
        markerId: MarkerId('technician_$index'),
        position: tech['location'],
        icon: technicianIcon,
        consumeTapEvents: false, 
        onTap: () {}, 
      );
    }).toList();

    debugPrint('Adding ${newMarkers.length} technician markers to the map');

    setState(() {
      _markers.addAll(newMarkers);
    });

    debugPrint('Total markers on map: ${_markers.length}');
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    debugPrint(
      'Getting address for position: ${position.latitude}, ${position.longitude}',
    );
    // Show loading state
    setState(() {
      _currentAddress = "Loading address...";
    });

    try {
      final address = await MapControllers.getAddressFromLatLng(position);
      debugPrint('Address received: $address');
      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      debugPrint('Error getting address: $e');
      // Fallback to coordinates
      setState(() {
        _currentAddress = MapControllers.getSimpleAddress(position);
      });
    }
  }

  void _resetSearch() async {
    setState(() {
      _searchState = SearchState.initial;
      _foundTechnician = null;
      // Clear technician markers when resetting
      _markers.removeWhere(
        (marker) => marker.markerId.value.startsWith('technician_'),
      );
    });
    _dragController.animateTo(
      0.25,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    // Re-add markers after clearing
    await _addTechnicianMarkers();
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
                  child: lottie.Lottie.asset(
                    'assets/animations/mapload.json',
                    repeat: true,
                    animate: true,
                    fit: BoxFit.contain,
                    frameRate: lottie.FrameRate.max, // For smooth animation
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
                  markers: _markers,
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
                      await MapControllers.moveToCurrentLocation();
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
                            color: Colors.black.withValues(alpha: 0.1),
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
        return _foundTechnician != null 
          ? FoundTechnician(
              technician: _foundTechnician!,
              onFindAnother: _resetSearch,
              onCall: () {
                // Handle call functionality
              },
            )
          : const SizedBox();
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
            child: lottie.Lottie.asset(
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
}

enum SearchState { initial, searching, found }
