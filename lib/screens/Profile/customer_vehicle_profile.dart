import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/screens/Profile/customer_edit_vehicle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerVehicleProfile extends StatefulWidget {
  final VehicleProfile vehicleProfile;
  
  const CustomerVehicleProfile({super.key, required this.vehicleProfile});

  @override
  State<CustomerVehicleProfile> createState() => _CustomerVehicleProfileState();
}

class _CustomerVehicleProfileState extends State<CustomerVehicleProfile> {
  static const Color _primaryColor = Color(0xFF2563EB);
  static const Color _primaryLight = Color(0xFF60A5FA);
  static const Color _surface = Color(0xFFFAFBFC);
  static const Color _cardColor = Colors.white;
  
  final profileController = Get.find<ProfileController>();

  String? get _vehicleImageUrl => widget.vehicleProfile.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildVehicleImageCard(),
                  const SizedBox(height: 20),
                  _buildVehicleDetailsCard(),
                  const SizedBox(height: 20),
                  _buildEditButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 90.0,
      floating: false,
      pinned: true,
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Vehicle Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_primaryColor, _primaryLight],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleImageCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
                image: _vehicleImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(_vehicleImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _vehicleImageUrl == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _primaryLight.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.directions_car_outlined,
                            size: 48,
                            color: _primaryLight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No vehicle image',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.vehicleProfile.make} ${widget.vehicleProfile.model}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.vehicleProfile.plateNumber,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDetailsCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid() {
    final details = [
      {'label': 'Year', 'value': widget.vehicleProfile.year},
      {'label': 'Color', 'value': widget.vehicleProfile.color},
      {'label': 'Vehicle Type', 'value': widget.vehicleProfile.vehicleType},
      {'label': 'Fuel Type', 'value': widget.vehicleProfile.fuelType},
      {'label': 'Transmission', 'value': widget.vehicleProfile.transmission},
      {'label': 'Engine Capacity', 'value': widget.vehicleProfile.engineCapacity},
      {'label': 'Mileage', 'value': widget.vehicleProfile.mileage},
      {'label': 'Default Vehicle', 'value': widget.vehicleProfile.isDefault ? 'Yes' : 'No'},
    ];

    return Column(
      children: [
        for (int i = 0; i < details.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: i < details.length - 2 ? 20.0 : 0),
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    details[i]['label']!,
                    details[i]['value']!,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: i + 1 < details.length
                      ? _buildDetailItem(
                          details[i + 1]['label']!,
                          details[i + 1]['value']!,
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryLight],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _navigateToEditPage,
          child: const Center(
            child: Text(
              'Edit Vehicle',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditVehicle(vehicleProfile: widget.vehicleProfile),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          // The widget will rebuild with updated data from ProfileController
        });
      }
    });
  }
}