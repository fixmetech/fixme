// addresses_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddressesScreen extends StatefulWidget {
  final String? currentAddress;
  
  const AddressesScreen({Key? key, this.currentAddress}) : super(key: key);
  
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Map<String, dynamic>> savedAddresses = [
    {
      'id': '1',
      'label': 'Home',
      'address': '5 Amarathunga Mawatha, Colombo 03',
      'isDefault': true,
    },
    {
      'id': '2',
      'label': 'Office',
      'address': '123 Galle Road, Colombo 04',
      'isDefault': false,
    },
    {
      'id': '3',
      'label': 'Parents House',
      'address': '456 Kandy Road, Kaduwela',
      'isDefault': false,
    },
  ];

  void _selectAddress(Map<String, dynamic> address) {
    Navigator.pop(context, address['address']);
  }

  void _addNewAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          onSave: (newAddress) {
            setState(() {
              savedAddresses.add({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'label': newAddress['label'],
                'address': newAddress['address'],
                'isDefault': false,
              });
            });
          },
        ),
      ),
    );
  }

  void _editAddress(Map<String, dynamic> address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(
          address: address,
          onSave: (updatedAddress) {
            setState(() {
              final index = savedAddresses.indexWhere((a) => a['id'] == address['id']);
              if (index != -1) {
                savedAddresses[index] = {
                  ...savedAddresses[index],
                  'label': updatedAddress['label'],
                  'address': updatedAddress['address'],
                };
              }
            });
          },
        ),
      ),
    );
  }

  void _deleteAddress(String id) {
    setState(() {
      savedAddresses.removeWhere((address) => address['id'] == id);
    });
  }

  void _setAsDefault(String id) {
    setState(() {
      for (var address in savedAddresses) {
        address['isDefault'] = address['id'] == id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Addresses',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Add New Address Button
          Container(
            margin: EdgeInsets.all(16),
            child: InkWell(
              onTap: _addNewAddress,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.blue, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Add New Address',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Saved Addresses List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: savedAddresses.length,
              itemBuilder: (context, index) {
                final address = savedAddresses[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: address['isDefault'] ? Colors.blue : Colors.grey[300]!,
                      width: address['isDefault'] ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _selectAddress(address),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Address Icon
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: address['isDefault'] ? Colors.blue.withOpacity(0.1) : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: address['isDefault'] ? Colors.blue : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          
                          SizedBox(width: 12),
                          
                          // Address Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      address['label'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    if (address['isDefault']) ...[
                                      SizedBox(width: 8),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Default',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  address['address'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // More Options Button
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _editAddress(address);
                                  break;
                                case 'default':
                                  _setAsDefault(address['id']);
                                  break;
                                case 'delete':
                                  _deleteAddress(address['id']);
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 20, color: Colors.grey[600]),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              if (!address['isDefault'])
                                PopupMenuItem(
                                  value: 'default',
                                  child: Row(
                                    children: [
                                      Icon(Icons.star_border, size: 20, color: Colors.grey[600]),
                                      SizedBox(width: 8),
                                      Text('Set as Default'),
                                    ],
                                  ),
                                ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// add_edit_address_screen.dart
class AddEditAddressScreen extends StatefulWidget {
  final Map<String, dynamic>? address;
  final Function(Map<String, String>) onSave;
  
  const AddEditAddressScreen({
    Key? key,
    this.address,
    required this.onSave,
  }) : super(key: key);
  
  @override
  _AddEditAddressScreenState createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelController;
  late TextEditingController _addressController;
  
  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController(text: widget.address?['label'] ?? '');
    _addressController = TextEditingController(text: widget.address?['address'] ?? '');
  }
  
  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    super.dispose();
  }
  
  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'label': _labelController.text,
        'address': _addressController.text,
      });
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.address != null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Edit Address' : 'Add New Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Label Field
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: 'Address Label',
                  hintText: 'e.g., Home, Office, etc.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address label';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Full Address',
                  hintText: 'Enter your complete address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the full address';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Set on Map Button
              OutlinedButton.icon(
                onPressed: () async {
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapLocationPicker(),
                    ),
                  );
                  if (selectedAddress != null) {
                    _addressController.text = selectedAddress;
                  }
                },
                icon: Icon(Icons.map, color: Colors.blue),
                label: Text(
                  'Set on Map',
                  style: TextStyle(color: Colors.blue),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Save Button
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isEditing ? 'Update Address' : 'Save Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Map Location Picker Screen
class MapLocationPicker extends StatefulWidget {
  @override
  _MapLocationPickerState createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  LatLng? _selectedLocation;
  String _currentAddress = "Loading...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _getAddressFromLatLng(_selectedLocation!);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      // You can implement reverse geocoding here
      // For now, just show coordinates
      setState(() {
        _currentAddress = "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
      });
    } catch (e) {
      setState(() {
        _currentAddress = "Address not found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Location',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? Center(child: Text('Unable to get location'))
              : Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 16,
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

                    // Center marker
                    Center(
                      child: Icon(
                        Icons.location_on,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),

                    // My Location button
                    Positioned(
                      bottom: 200,
                      right: 16,
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () async {
                          if (_currentPosition != null) {
                            mapController?.animateCamera(
                              CameraUpdate.newLatLng(_currentPosition!),
                            );
                          }
                        },
                        child: Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ),

                    // Bottom sheet with address
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag handle
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                height: 4,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            Text(
                              'Selected Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.location_on, 
                                     color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _currentAddress,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            
                            // Confirm button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, _currentAddress);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Confirm Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
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