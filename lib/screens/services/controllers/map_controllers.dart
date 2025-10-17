import 'dart:convert';
import 'package:fixme/data/repositories/technicians_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapController extends GetxController {
  static MapController get instance => Get.find();

  // Observable properties
  final isLoading = false.obs;
  final currentPosition = Rxn<LatLng>();
  final userSelectedPosition = Rxn<LatLng>();
  final currentAddress = 'Getting your location...'.obs;
  final markers = <Marker>{}.obs;
  final nearByTechnicians = <Map<String, dynamic>>[].obs;

  // Private properties
  GoogleMapController? _mapController;
  String? _cachedAddress;
  final technicianRepository = Get.put(TechniciansRepository());

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  /// Initialize the map controller
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Check if environment is properly configured
  bool isEnvironmentConfigured() {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    return apiKey != null && apiKey.isNotEmpty;
  }

  /// Get the current location of the user with optional address loading
  Future<LatLng?> getCurrentLocation({bool loadAddress = false}) async {
    try {
      isLoading.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are denied');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final latLng = LatLng(position.latitude, position.longitude);
      currentPosition.value = latLng;

      // Optionally load address immediately
      if (loadAddress) {
        await getAddressFromLatLng(latLng);
      }

      return latLng;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      currentAddress.value = "Location not available";
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Move camera to current location with zoom
  Future<void> moveToCurrentLocation({double zoom = 18.0}) async {
    if (_mapController == null) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          zoom,
        ),
      );
    } catch (e) {
      debugPrint('Error moving to current location: $e');
    }
  }

  /// Get address from coordinates using Google Geocoding API
  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      currentAddress.value = "Loading address...";

      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('Google API key not found in environment variables');
        _cachedAddress = 'API key not configured';
        currentAddress.value = _cachedAddress!;
        return _cachedAddress!;
      }

      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

      debugPrint('Making geocoding request to: $url');

      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(const Duration(seconds: 10));

      debugPrint('Geocoding response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Geocoding response data: ${data["status"]}');

        if (data["status"] == "OK") {
          final results = data["results"] as List;
          if (results.isNotEmpty) {
            final address =
                results.first["formatted_address"] ?? 'Address not found';
            debugPrint('Address found: $address');
            _cachedAddress = address;
            currentAddress.value = address;
            return address;
          } else {
            debugPrint('No results found in geocoding response');
            _cachedAddress = 'No address found';
            currentAddress.value = _cachedAddress!;
            return _cachedAddress!;
          }
        } else {
          debugPrint(
            'Geocoding API error: ${data["status"]} - ${data["error_message"] ?? "Unknown error"}',
          );
          _cachedAddress = 'Geocoding error: ${data["status"]}';
          currentAddress.value = _cachedAddress!;
          return _cachedAddress!;
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode} - ${response.body}');
        _cachedAddress = 'Network error: ${response.statusCode}';
        currentAddress.value = _cachedAddress!;
        return _cachedAddress!;
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      _cachedAddress = 'Error loading address';
      currentAddress.value = _cachedAddress!;
      return _cachedAddress!;
    }
  }

  /// Get simple coordinates-based address as fallback
  String getSimpleAddress(LatLng position) {
    return 'Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
  }

  /// Get cached address or simple coordinates
  String getCachedOrSimpleAddress(LatLng position) {
    return _cachedAddress ?? getSimpleAddress(position);
  }

  /// Move camera to specific location
  Future<void> moveToLocation(LatLng location, {double zoom = 15.0}) async {
    if (_mapController == null) return;

    try {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, zoom),
      );
    } catch (e) {
      debugPrint('Error moving to location: $e');
    }
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Calculate distance between two points
  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Format distance in a human-readable format
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  /// Return Nearby Technician Markers to the map
  Future<List<Marker>> addTechnicianMarkers(String? serviceCategory) async {
    try {
      isLoading.value = true;

      // Load custom technician icon (fallback to default if fails)
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

      // Fetch nearby technicians
      final technicians = await technicianRepository
          .getNearbyTechnicians(currentPosition, 10000, serviceCategory);

      // Process technician data and add LatLng objects
      for (var tech in technicians) {
        if (tech['location'] != null) {
          final loc = tech['location'];
          tech['location'] = LatLng(loc['lat'], loc['lng']);
        }
      }

      // Update observable
      nearByTechnicians.value = technicians;

      // Convert to markers
      final newMarkers = technicians.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> tech = entry.value;

        final latLng = tech['location'] as LatLng;

        return Marker(
          markerId: MarkerId('technician_${tech['id'] ?? index}'),
          position: latLng,
          icon: technicianIcon,
          consumeTapEvents: false,
          onTap: () {
            debugPrint(
              "Tapped technician: ${tech['id']} "
              "Category: ${tech['serviceCategory']} "
              "Distance: ${tech['distance']}m",
            );
          },
        );
      }).toList();

      debugPrint('Adding ${newMarkers.length} technician markers to the map');

      // Update observable markers
      markers.clear();
      markers.addAll(newMarkers);

      return newMarkers;
    } catch (e) {
      debugPrint('Error adding technician markers: $e');
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Job Request to Nearest Technician
  Future<void> requestJobToNearestTechnician() async {
    if (nearByTechnicians.isEmpty) {
      debugPrint('No nearby technicians available');
      return;
    }
    Map<String, dynamic> nearestTechnician = nearByTechnicians.first;

    // Send job request (this is just a placeholder, implement your own logic)
    debugPrint('Requesting job to nearest technician: ${nearestTechnician['id']}');
  }

  /// Clear all markers
  void clearMarkers() {
    markers.clear();
  }

  /// Add a single marker
  void addMarker(Marker marker) {
    markers.add(marker);
  }

  /// Remove markers by type
  void removeMarkersByType(String type) {
    markers.removeWhere((marker) => marker.markerId.value.startsWith(type));
  }

  /// Get directions between two points (basic implementation)
  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('Google API key not found, returning straight line');
        return [origin, destination];
      }

      final url = "https://maps.googleapis.com/maps/api/directions/json?"
          "origin=${origin.latitude},${origin.longitude}&"
          "destination=${destination.latitude},${destination.longitude}&"
          "key=$apiKey";

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "OK") {
          final routes = data["routes"] as List;
          if (routes.isNotEmpty) {
            final polylinePoints = routes[0]["overview_polyline"]["points"];
            return _decodePolyline(polylinePoints);
          }
        }
      }
      
      // Fallback to straight line
      return [origin, destination];
    } catch (e) {
      debugPrint('Error getting directions: $e');
      return [origin, destination];
    }
  }

  /// Decode polyline points from Google Directions API
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  void onClose() {
    _mapController = null;
    super.onClose();
  }
}
