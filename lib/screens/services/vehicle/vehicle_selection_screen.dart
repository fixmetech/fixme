import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/vehicle_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // Load vehicles if not already loaded
    _loadVehicles();
    // Initialize selected vehicle from widget parameter or ProfileController
    selectedVehicle =
        widget.currentSelectedVehicle ??
        _profileController.getSelectedVehicle();
  }

  Future<void> _loadVehicles() async {
    if (_profileController.userVehicleProfiles.isEmpty) {
      await _profileController.loadUserVehicles();
    }
  }

  void _selectVehicle(VehicleProfile vehicle) {
    setState(() {
      selectedVehicle = vehicle;
    });
    if (selectedVehicle != null) {
      // Update the ProfileController's selected vehicle
      _profileController.setSelectedVehicle(selectedVehicle);
      widget.onVehicleSelected(selectedVehicle!);
    }
  }

  void _confirmSelection() {
    if (selectedVehicle != null) {
      // Update the ProfileController's selected vehicle
      _profileController.setSelectedVehicle(selectedVehicle);
      widget.onVehicleSelected(selectedVehicle!);
      _backToPreviousScreen();
    }
  }

  void _backToPreviousScreen() {
    Navigator.pop(context);
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
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
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Obx(() {
              final vehicles = _profileController.userVehicleProfiles;

              if (vehicles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Vehicles Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a vehicle to continue',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return _buildVehicleSelectionCard(vehicles[index]);
                },
              );
            }),
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
                              color: isSelected
                                  ? Colors.blue[800]
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                        if (vehicle.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
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
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Year: ${vehicle.year}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
