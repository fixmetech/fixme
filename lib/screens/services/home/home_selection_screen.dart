import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSelectionScreen extends StatefulWidget {
  final HomeProfile? currentSelectedHome;
  final Function(HomeProfile) onHomeSelected;

  const HomeSelectionScreen({
    super.key,
    this.currentSelectedHome,
    required this.onHomeSelected,
  });

  @override
  State<HomeSelectionScreen> createState() => _HomeSelectionScreenState();
}

class _HomeSelectionScreenState extends State<HomeSelectionScreen> {
  late HomeProfile? selectedHome;
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // Load homes if not already loaded
    _loadHomes();
    // Initialize selected home from widget parameter or ProfileController
    selectedHome =
        widget.currentSelectedHome ?? _profileController.getSelectedHome();
  }

  Future<void> _loadHomes() async {
    if (_profileController.userHomeProfiles.isEmpty) {
      await _profileController.loadUserHomes();
    }
  }

  void _selectHome(HomeProfile home) {
    setState(() {
      selectedHome = home;
    });
    if (selectedHome != null) {
      // Update the ProfileController's selected home
      _profileController.setSelectedHome(selectedHome);
      widget.onHomeSelected(selectedHome!);
    }
  }

  void _confirmSelection() {
    if (selectedHome != null) {
      // Update the ProfileController's selected home
      _profileController.setSelectedHome(selectedHome);
      widget.onHomeSelected(selectedHome!);
      _backToPreviousScreen();
    }
  }

  void _backToPreviousScreen() {
    Navigator.pop(context);
  }

  IconData _getHomeIcon(String homeType) {
    switch (homeType.toLowerCase()) {
      case 'house':
        return Icons.home;
      case 'apartment':
        return Icons.apartment;
      case 'condo':
        return Icons.home_work;
      case 'office':
        return Icons.business;
      case 'shop':
        return Icons.storefront;
      default:
        return Icons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Select Property',
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
              'Choose the property for your service request',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Obx(() {
              final homes = _profileController.userHomeProfiles;

              if (homes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No Properties Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add a property to continue',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: homes.length,
                itemBuilder: (context, index) {
                  return _buildHomeSelectionCard(homes[index]);
                },
              );
            }),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildHomeSelectionCard(HomeProfile home) {
    bool isSelected = selectedHome?.id == home.id;

    return GestureDetector(
      onTap: () => _selectHome(home),
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
              // Home Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getHomeIcon(home.homeType),
                  color: isSelected ? Colors.blue[600] : Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Home Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            home.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.blue[800]
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                        if (home.isDefault)
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
                      home.address,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${home.city}, ${home.postalCode}',
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
          onPressed: selectedHome != null ? _confirmSelection : null,
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
