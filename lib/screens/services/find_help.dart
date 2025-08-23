import 'package:fixme/data/repositories/technicians_repository.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  Set<Marker> _markers = {};

  final technicianRepository = Get.put(TechniciansRepository());
  final mapControllerInstance = Get.put(MapController());

  // Search states
  SearchState _searchState = SearchState.initial;
  Map<String, dynamic>? _foundTechnician;
  Map<String, dynamic>? _nearestTechnician;
  bool _showCenterMarker = true;
  Set<Polyline> _polylines = {};

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
    final position = await mapControllerInstance.getCurrentLocation();
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
      mapControllerInstance.currentAddress.value = "Location not available";
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapControllerInstance.setMapController(controller);
  }

  void _startSearching() async {
    setState(() {
      _searchState = SearchState.searching;
      _showCenterMarker = false; // Hide center marker when searching starts
    });

    _dragController.animateTo(
      0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    // Remove all markers
    _markers.clear();

    // Add user location marker to the map
    await _addUserLocationMarker();

    // Add technician markers when starting search
    await _addTechnicianMarkers();

    // Find nearest technician and draw route
    await _selectNearestTechnicianAndDrawRoute();

    setState(() {
      _searchState = SearchState.found;
      _foundTechnician =
          {
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
      debugPrint('Current position is null, cannot add markers');
      return;
    }

    try {
      // Don't clear all markers if we have user location marker
      _markers.removeWhere(
        (marker) => marker.markerId.value.startsWith('technician_'),
      );

      // Fetch nearby technicians
      List<Marker> technicianMarkers = await mapControllerInstance
          .addTechnicianMarkers("vehicles");
      setState(() {
        _markers.addAll(technicianMarkers);
      });
    } catch (e) {
      debugPrint('Error adding technician markers: $e');
      // Handle error gracefully - maybe show a snackbar or keep existing markers
    }
  }

  Future<void> _addUserLocationMarker() async {
    if (_selectedLocation == null) return;

    try {
      // Create user location marker
      BitmapDescriptor userIcon;
      userIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );

      final userMarker = Marker(
        markerId: const MarkerId('user_location'),
        position: _selectedLocation!,
        icon: userIcon,
        infoWindow: const InfoWindow(
          title: 'Selected Location',
          snippet: 'You are here',
        ),
      );

      setState(() {
        _markers.add(userMarker);
      });
    } catch (e) {
      debugPrint('Error adding user location marker: $e');
    }
  }

  Future<void> _selectNearestTechnicianAndDrawRoute() async {
    if (_selectedLocation == null ||
        mapControllerInstance.nearByTechnicians.isEmpty) {
      debugPrint(
        'Cannot select nearest technician: no current position or technicians',
      );
      return;
    }

    try {
      // Find the nearest technician
      Map<String, dynamic>? nearest;
      double minDistance = double.infinity;

      for (var technician in mapControllerInstance.nearByTechnicians) {
        if (technician['location'] != null) {
          final techLocation = technician['location'] as LatLng;
          final distance = mapControllerInstance.calculateDistance(
            _selectedLocation!,
            techLocation,
          );

          if (distance < minDistance) {
            minDistance = distance;
            nearest = technician;
          }
        }
      }

      if (nearest != null) {
        _nearestTechnician = nearest;

        // Add a special marker for the selected technician
        await _addSelectedTechnicianMarker(
          nearest['location'] as LatLng,
          nearest,
        );

        // Draw route to nearest technician
        await _drawRouteToTechnician(nearest['location'] as LatLng);

        // Focus camera to show both user and technician
        await _focusCameraOnRoute(
          _selectedLocation!,
          nearest['location'] as LatLng,
        );
      }
    } catch (e) {
      debugPrint('Error selecting nearest technician: $e');
    }
  }

  Future<void> _addSelectedTechnicianMarker(
    LatLng technicianLocation,
    Map<String, dynamic> technicianData,
  ) async {
    try {
      // Create a special marker for the selected technician
      BitmapDescriptor selectedIcon;
      selectedIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );

      final selectedMarker = Marker(
        markerId: const MarkerId('selected_technician'),
        position: technicianLocation,
        icon: selectedIcon,
        infoWindow: InfoWindow(
          title: technicianData['name'] ?? 'Selected Technician',
          snippet:
              'Nearest technician - ${mapControllerInstance.formatDistance(mapControllerInstance.calculateDistance(_currentPosition!, technicianLocation))}',
        ),
      );

      setState(() {
        // Remove any existing selected technician marker
        _markers.removeWhere(
          (marker) => marker.markerId.value == 'selected_technician',
        );
        _markers.add(selectedMarker);
      });
    } catch (e) {
      debugPrint('Error adding selected technician marker: $e');
    }
  }

  Future<void> _drawRouteToTechnician(LatLng technicianLocation) async {
    if (_selectedLocation == null) return;

    try {
      // Get route points from Google Directions API
      final routePoints = await mapControllerInstance.getDirections(
        _selectedLocation!,
        technicianLocation,
      );

      final polyline = Polyline(
        polylineId: const PolylineId('route_to_technician'),
        points: routePoints,
        color: Colors.blue[900]!,
        width: 5,
      );

      setState(() {
        _polylines.clear();
        _polylines.add(polyline);
      });
    } catch (e) {
      debugPrint('Error drawing route: $e');
    }
  }

  Future<void> _focusCameraOnRoute(LatLng start, LatLng end) async {
    try {
      // Calculate bounds to include both points
      final double minLat = start.latitude < end.latitude
          ? start.latitude
          : end.latitude;
      final double maxLat = start.latitude > end.latitude
          ? start.latitude
          : end.latitude;
      final double minLng = start.longitude < end.longitude
          ? start.longitude
          : end.longitude;
      final double maxLng = start.longitude > end.longitude
          ? start.longitude
          : end.longitude;

      final bounds = LatLngBounds(
        southwest: LatLng(minLat - 0.001, minLng - 0.001),
        northeast: LatLng(maxLat + 0.001, maxLng + 0.001),
      );

      await mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100.0),
      );
    } catch (e) {
      debugPrint('Error focusing camera on route: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    debugPrint(
      'Getting address for position: ${position.latitude}, ${position.longitude}',
    );

    try {
      final address = await mapControllerInstance.getAddressFromLatLng(
        position,
      );
      debugPrint('Address received: $address');
    } catch (e) {
      debugPrint('Error getting address: $e');
      // Fallback to coordinates
      mapControllerInstance.currentAddress.value = mapControllerInstance
          .getSimpleAddress(position);
    }
  }

  void _resetSearch() async {
    setState(() {
      _searchState = SearchState.initial;
      _foundTechnician = null;
      _nearestTechnician = null;
      _showCenterMarker = true; // Show center marker again
      _polylines.clear(); // Clear route lines

      // Clear technician, user, and selected markers when resetting
      _markers.removeWhere(
        (marker) =>
            marker.markerId.value.startsWith('technician_') ||
            marker.markerId.value == 'user_location' ||
            marker.markerId.value == 'selected_technician',
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
                Obx(
                  () => GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15.5,
                    ),
                    markers: {..._markers, ...mapControllerInstance.markers},
                    polylines: _polylines,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    onCameraMove: (position) {
                      setState(() {
                        _selectedLocation = position.target;
                      });
                    },
                    onCameraIdle: () {
                      if (_selectedLocation != null &&
                          _searchState == SearchState.initial) {
                        _getAddressFromLatLng(_selectedLocation!);
                      }
                    },
                  ),
                ),

                // Location button
                Positioned(
                  bottom: FixMeSizes.bottomNavHeight + 190,
                  right: 16,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: () async {
                      await mapControllerInstance.moveToCurrentLocation();
                    },
                    child: const Icon(Icons.my_location, color: Colors.blue),
                  ),
                ),

                // Center marker - only show in initial state
                if (_showCenterMarker)
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
          Obx(
            () => Text(
              mapControllerInstance.currentAddress.value.isEmpty
                  ? "Loading address..."
                  : "📍 ${mapControllerInstance.currentAddress.value}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: mapControllerInstance.isLoading.value
                    ? null
                    : _startSearching,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: mapControllerInstance.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Find Technician",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
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
