import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FindHelp extends StatefulWidget {
  const FindHelp({super.key});

  @override
  State<FindHelp> createState() => _FindHelpState();
}

class _FindHelpState extends State<FindHelp> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  bool _isSearching = false;
  LatLng? _selectedLocation;
  String _currentAddress = "-";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _startSearching() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isSearching = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Technicians found near your location.")),
      );
    });
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY']; // Replace with your actual key
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
      } else {
        debugPrint("Failed to fetch address");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
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

                Positioned(
                  bottom: 200, // adjust as needed
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

                /// 📍 Marker at center of screen
                const Center(
                  child: Icon(Icons.man_2, size: 45, color: Colors.blueGrey),
                ),

                // 💡 Floating back button
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

                // Floating bottom sheet
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
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
                        Text(
                          _currentAddress.isEmpty
                              ? "Loading address..."
                              : "Location: $_currentAddress",
                          style: const TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 16),
                        _isSearching
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _startSearching,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[400],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Find Technician",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
