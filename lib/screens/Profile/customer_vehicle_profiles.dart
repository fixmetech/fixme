import 'package:flutter/material.dart';
import 'customer_vehicle_profile.dart';

class CustomerVehicleProfiles extends StatefulWidget {
  const CustomerVehicleProfiles({super.key});

  @override
  State<CustomerVehicleProfiles> createState() => _CustomerVehicleProfilesState();
}

class _CustomerVehicleProfilesState extends State<CustomerVehicleProfiles> {
  // Sample data for vehicle profiles
  List<VehicleProfile> vehicleProfiles = [
    VehicleProfile(
      id: '1',
      plateNumber: 'KX-6065',
      make: 'Toyota',
      model: 'Corolla',
      year: '2018',
      color: 'White',
      vehicleType: 'Car',
      isDefault: true,
      fuelType: 'Petrol',
      transmission: 'Manual',
      engineCapacity: '1.5L',
      mileage: '45,000 km',
    ),
    VehicleProfile(
      id: '2',
      plateNumber: 'ABC-1234',
      make: 'Honda',
      model: 'Civic',
      year: '2020',
      color: 'Black',
      vehicleType: 'Car',
      isDefault: false,
      fuelType: 'Petrol',
      transmission: 'Automatic',
      engineCapacity: '1.8L',
      mileage: '25,000 km',
    ),
    VehicleProfile(
      id: '3',
      plateNumber: 'MN-7890',
      make: 'Yamaha',
      model: 'FZ-S',
      year: '2019',
      color: 'Blue',
      vehicleType: 'Motorcycle',
      isDefault: false,
      fuelType: 'Petrol',
      transmission: 'Manual',
      engineCapacity: '150cc',
      mileage: '15,000 km',
    ),
    VehicleProfile(
      id: '4',
      plateNumber: 'XY-5678',
      make: 'Mahindra',
      model: 'Bolero',
      year: '2017',
      color: 'Silver',
      vehicleType: 'SUV',
      isDefault: false,
      fuelType: 'Diesel',
      transmission: 'Manual',
      engineCapacity: '2.5L',
      mileage: '80,000 km',
    ),
  ];

  void _setAsDefault(String vehicleId) {
    setState(() {
      for (var vehicle in vehicleProfiles) {
        vehicle.isDefault = vehicle.id == vehicleId;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Default vehicle updated successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewDetails(VehicleProfile vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerVehicleProfile(),
      ),
    );
  }

  void _editVehicle(VehicleProfile vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditVehiclePage(vehicle: vehicle),
      ),
    );
  }

  void _deleteVehicle(VehicleProfile vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Vehicle'),
          content: Text('Are you sure you want to delete "${vehicle.plateNumber}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  vehicleProfiles.removeWhere((v) => v.id == vehicle.id);
                  // If deleted vehicle was default, set first vehicle as default
                  if (vehicle.isDefault && vehicleProfiles.isNotEmpty) {
                    vehicleProfiles.first.isDefault = true;
                  }
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Vehicle deleted successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _addNewVehicle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVehiclePage(),
      ),
    );
  }

  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'car':
        return Icons.directions_car;
      case 'motorcycle':
        return Icons.two_wheeler;
      case 'suv':
        return Icons.directions_car;
      case 'truck':
        return Icons.local_shipping;
      case 'van':
        return Icons.airport_shuttle;
      default:
        return Icons.directions_car;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Vehicle Profiles',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: vehicleProfiles.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: vehicleProfiles.length,
                    itemBuilder: (context, index) {
                      return _buildVehicleCard(vehicleProfiles[index]);
                    },
                  ),
          ),
          _buildAddVehicleButton(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No Vehicle Profiles Added',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first vehicle profile to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(VehicleProfile vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: vehicle.isDefault 
            ? Border.all(color: Colors.blue[600]!, width: 2)
            : Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Vehicle Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getVehicleIcon(vehicle.vehicleType),
                color: Colors.blue[600],
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            
            // Vehicle Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.plateNumber,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      if (vehicle.isDefault)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Model: ${vehicle.make} ${vehicle.model}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Year: ${vehicle.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            
            // Three dots menu
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _viewDetails(vehicle);
                    break;
                  case 'edit':
                    _editVehicle(vehicle);
                    break;
                  case 'delete':
                    _deleteVehicle(vehicle);
                    break;
                  case 'default':
                    _setAsDefault(vehicle.id);
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 18, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                if (!vehicle.isDefault)
                  PopupMenuItem<String>(
                    value: 'default',
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 18, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text('Set as Default'),
                      ],
                    ),
                  ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red[600]),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red[600])),
                    ],
                  ),
                ),
              ],
              child: Icon(
                Icons.more_vert,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddVehicleButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _addNewVehicle,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 24),
              SizedBox(width: 8),
              Text(
                'Add New Vehicle',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Vehicle Profile Model
class VehicleProfile {
  final String id;
  final String plateNumber;
  final String make;
  final String model;
  final String year;
  final String color;
  final String vehicleType;
  bool isDefault;
  final String fuelType;
  final String transmission;
  final String engineCapacity;
  final String mileage;

  VehicleProfile({
    required this.id,
    required this.plateNumber,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.vehicleType,
    required this.isDefault,
    required this.fuelType,
    required this.transmission,
    required this.engineCapacity,
    required this.mileage,
  });
}

// Placeholder pages for navigation
class VehicleDetailsPage extends StatelessWidget {
  final VehicleProfile vehicle;

  const VehicleDetailsPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Vehicle Details Page for ${vehicle.plateNumber}'),
      ),
    );
  }
}

class EditVehiclePage extends StatelessWidget {
  final VehicleProfile vehicle;

  const EditVehiclePage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Vehicle'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Edit Vehicle Page for ${vehicle.plateNumber}'),
      ),
    );
  }
}

class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Vehicle'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Add New Vehicle Page'),
      ),
    );
  }
}