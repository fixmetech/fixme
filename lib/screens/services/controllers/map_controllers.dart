import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapControllers {
  static GoogleMapController? _mapController;
  static String? _cachedAddress;

  /// Initialize the map controller
  static void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Check if environment is properly configured
  static bool isEnvironmentConfigured() {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    return apiKey != null && apiKey.isNotEmpty;
  }

  /// Get the current location of the user with optional address loading
  static Future<LatLng?> getCurrentLocation({bool loadAddress = false}) async {
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

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      final latLng = LatLng(position.latitude, position.longitude);
      
      // Optionally load address immediately
      if (loadAddress) {
        await getAddressFromLatLng(latLng);
      }
      
      return latLng;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  /// Move camera to current location with zoom
  static Future<void> moveToCurrentLocation({double zoom = 18.0}) async {
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
  static Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        debugPrint('Google API key not found in environment variables');
        _cachedAddress = 'API key not configured';
        return _cachedAddress!;
      }

      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";

      debugPrint('Making geocoding request to: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      debugPrint('Geocoding response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('Geocoding response data: ${data["status"]}');
        
        if (data["status"] == "OK") {
          final results = data["results"] as List;
          if (results.isNotEmpty) {
            final address = results.first["formatted_address"] ?? 'Address not found';
            debugPrint('Address found: $address');
            _cachedAddress = address;
            return address;
          } else {
            debugPrint('No results found in geocoding response');
            _cachedAddress = 'No address found';
            return _cachedAddress!;
          }
        } else {
          debugPrint('Geocoding API error: ${data["status"]} - ${data["error_message"] ?? "Unknown error"}');
          _cachedAddress = 'Geocoding error: ${data["status"]}';
          return _cachedAddress!;
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode} - ${response.body}');
        _cachedAddress = 'Network error: ${response.statusCode}';
        return _cachedAddress!;
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      _cachedAddress = 'Error loading address';
      return _cachedAddress!;
    }
  }

  /// Get simple coordinates-based address as fallback
  static String getSimpleAddress(LatLng position) {
    return 'Location: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
  }

  /// Get cached address or simple coordinates
  static String getCachedOrSimpleAddress(LatLng position) {
    return _cachedAddress ?? getSimpleAddress(position);
  }

  /// Move camera to specific location
  static Future<void> moveToLocation(LatLng location, {double zoom = 15.0}) async {
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
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  static Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Calculate distance between two points
  static double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Format distance in a human-readable format
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  

  /// Dispose the map controller
  static void dispose() {
    _mapController = null;
  }

  

}
