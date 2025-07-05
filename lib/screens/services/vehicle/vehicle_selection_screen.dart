import 'package:flutter/material.dart';

class VehicleSelectionScreen extends StatefulWidget {
  final VehicleProfile? currentSelectedVehicle;
  final Function(VehicleProfile) onVehicleSelected;

  const VehicleSelectionScreen({
    super.key,
    this.currentSelectedVehicle,
    required this.onVehicleSelected,
  });

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  late VehicleProfile? selectedVehicle;

  // Sample data for vehicle profiles (same as your first code)
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

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.currentSelectedVehicle ?? 
        vehicleProfiles.firstWhere((v) => v.isDefault, orElse: () => vehicleProfiles.first);
  }

  void _selectVehicle(VehicleProfile vehicle) {
    setState(() {
      selectedVehicle = vehicle;
    });
  }

  void _confirmSelection() {
    if (selectedVehicle != null) {
      widget.onVehicleSelected(selectedVehicle!);
      Navigator.pop(context);
    }
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Select Vehicle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue[300],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose the vehicle for your service request',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: vehicleProfiles.length,
              itemBuilder: (context, index) {
                return _buildVehicleSelectionCard(vehicleProfiles[index]);
              },
            ),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildVehicleSelectionCard(VehicleProfile vehicle) {
    bool isSelected = selectedVehicle?.id == vehicle.id;
    
    return GestureDetector(
      onTap: () => _selectVehicle(vehicle),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Vehicle Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getVehicleIcon(vehicle.vehicleType),
                  color: isSelected ? Colors.blue[600] : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
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
                              color: isSelected ? Colors.blue[800] : Colors.grey[800],
                            ),
                          ),
                        ),
                        if (vehicle.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
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
                    const SizedBox(height: 4),
                    Text(
                      'Model: ${vehicle.make} ${vehicle.model}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
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
              
              // Selection indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue[600]! : Colors.grey[400]!,
                    width: 2,
                  ),
                  color: isSelected ? Colors.blue[600] : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: selectedVehicle != null ? _confirmSelection : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[300],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: const Text(
            'Confirm Selection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Vehicle Profile Model (same as your first code)
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