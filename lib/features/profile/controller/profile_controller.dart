import 'package:fixme/data/repositories/user_repository.dart';
import 'package:fixme/models/home_profile.dart';
import 'package:fixme/models/vehicle_profile.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // Observable user data
  final fullName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final profileImageUrl = ''.obs;
  final isLoading = false.obs;

  final userHomeProfiles = <HomeProfile>[].obs;
  final homeCount = 0.obs;

  final userVehicleProfiles = <VehicleProfile>[].obs;
  final vehicleCount = 0.obs;

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    // loadUserHomes(); // Let the UI call this when needed
  }

  /// Load user data from Firestore
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final userData = await userRepository.getCurrentUserData();
      if (userData != null) {
        // Update observable values
        final firstName = userData['firstName'] ?? '';
        final lastName = userData['lastName'] ?? '';
        fullName.value = '$firstName $lastName'.trim();
        email.value = userData['email'] ?? '';
        phone.value = userData['phone'] ?? '';
        profileImageUrl.value = userData['profileImage'] ?? '';
      }
    } catch (e) {
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to load user data',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? newEmail,
    String? newPhone,
    String? profileImage,
  }) async {
    try {
      isLoading.value = true;

      final updateData = <String, dynamic>{};

      if (firstName != null) updateData['firstName'] = firstName;
      if (lastName != null) updateData['lastName'] = lastName;
      if (newEmail != null) updateData['email'] = newEmail;
      if (newPhone != null) updateData['phone'] = newPhone;
      if (profileImage != null) updateData['profileImage'] = profileImage;

      if (updateData.isNotEmpty) {
        updateData['updatedAt'] = DateTime.now().toIso8601String();

        final success = await userRepository.updateUserData(updateData);

        if (success) {
          // Reload data to update UI
          await loadUserData();
          FixMeHelperFunctions.showSuccessSnackBar(
            'Success',
            'Profile updated successfully',
          );
        } else {
          FixMeHelperFunctions.showErrorSnackBar(
            'Error',
            'Failed to update profile',
          );
        }
      }
    } catch (e) {
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to update profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update password 
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      final success = await userRepository.updatePassword(currentPassword, newPassword );
      if (success) {
        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Password updated successfully',
        );
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to update password',
        );
      }
    } catch (e) {
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to update password',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh user data
  Future<void> refreshUserData() async {
    await loadUserData();
  }

  /// Load user's homes
  Future<void> loadUserHomes() async {
    try {
      isLoading.value = true;
      print('Starting to load user homes from backend...');

      final homes = await userRepository.getUserProperties('homes');
      print('Received homes data: $homes');

      if (homes['success'] == true && homes['data'] != null) {
        // Parse the data from API
        final List<dynamic> homeData = homes['data'] as List<dynamic>;
        userHomeProfiles.value = homeData
            .map((data) => HomeProfile.fromMap(data as Map<String, dynamic>))
            .toList();
        homeCount.value = homes['count'] ?? userHomeProfiles.length;
        print(
          'Successfully loaded ${userHomeProfiles.length} homes from backend',
        );
      } else {
        // No data from backend - clear the list
        userHomeProfiles.clear();
        homeCount.value = 0;
        print('No homes found in backend or API call failed');

        if (homes['message'] != null) {
          FixMeHelperFunctions.showErrorSnackBar(
            'No Homes Found',
            homes['message'],
          );
        }
      }
    } catch (e) {
      print('Error loading user homes: $e');
      // Clear data on error
      userHomeProfiles.clear();
      homeCount.value = 0;
      FixMeHelperFunctions.showErrorSnackBar(
        'Connection Error',
        'Failed to load homes from server. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load user's vehicles
  Future<void> loadUserVehicles() async {
    try {
      isLoading.value = true;
      print('Starting to load user vehicles from backend...');

      final vehicles = await userRepository.getUserProperties('vehicles');
      print('Received vehicles data: $vehicles');

      if (vehicles['success'] == true && vehicles['data'] != null) {
        // Parse the data from API
        final List<dynamic> vehicleData = vehicles['data'] as List<dynamic>;
        userVehicleProfiles.value = vehicleData
            .map((data) => VehicleProfile.fromMap(data as Map<String, dynamic>))
            .toList();
        vehicleCount.value = vehicles['count'] ?? userVehicleProfiles.length;
        print(
          'Successfully loaded ${userVehicleProfiles.length} vehicles from backend',
        );
      } else {
        // No data from backend - clear the list
        userVehicleProfiles.clear();
        vehicleCount.value = 0;
        print('No vehicles found in backend or API call failed');

        if (vehicles['message'] != null) {
          FixMeHelperFunctions.showErrorSnackBar(
            'No Vehicles Found',
            vehicles['message'],
          );
        }
      }
    } catch (e) {
      print('Error loading user vehicles: $e');
      // Clear data on error
      userVehicleProfiles.clear();
      vehicleCount.value = 0;
      FixMeHelperFunctions.showErrorSnackBar(
        'Connection Error',
        'Failed to load vehicles from server. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Set a home as default
  void setDefaultHome(String homeId) {
    for (var home in userHomeProfiles) {
      home.isDefault = home.id == homeId;
    }
    userHomeProfiles.refresh(); // Notify observers
  }

  /// Add a new home profile
  Future<void> addHomeProfile(HomeProfile home) async {
    try {
      isLoading.value = true;
      print('Adding new home profile to backend...');

      final propertyData = home.toMap();
      final isAdded = await userRepository.addUserProperty(
        propertyData,
        'homes',
      );

      if (isAdded) {
        // Add to local list and update UI
        userHomeProfiles.add(home);
        homeCount.value = userHomeProfiles.length;
        userHomeProfiles.refresh(); // Notify observers

        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Home added successfully!',
        );
        print('Home added successfully to backend and local list');
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to add home. Please try again.',
        );
        print('Failed to add home to backend');
      }
    } catch (e) {
      print('Error adding home: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Connection Error',
        'Failed to add home. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing home profile
  Future<void> updateHomeProfile(HomeProfile updatedHome) async {
    try {
      isLoading.value = true;
      print('Updating home profile in backend...');

      if (updatedHome.id == null || updatedHome.id!.isEmpty) {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Invalid home ID for update',
        );
        return;
      }

      final propertyData = updatedHome.toMap();
      final isUpdated = await userRepository.editUserProperty(
        updatedHome.id!,
        propertyData,
        'homes',
      );

      if (isUpdated) {
        // Update local list
        final index = userHomeProfiles.indexWhere(
          (home) => home.id == updatedHome.id,
        );
        if (index != -1) {
          userHomeProfiles[index] = updatedHome;
          userHomeProfiles.refresh(); // Notify observers
          
          FixMeHelperFunctions.showSuccessSnackBar(
            'Success',
            'Home updated successfully!',
          );
          print('Home updated successfully in backend and local list');
        } else {
          FixMeHelperFunctions.showErrorSnackBar(
            'Error',
            'Home not found for update',
          );
        }
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to update home. Please try again.',
        );
        print('Failed to update home in backend');
      }
    } catch (e) {
      print('Error updating home: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Connection Error',
        'Failed to update home. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a home profile
  void deleteHomeProfile(String? homeId) async {
    if (homeId == null || homeId == "") {
      FixMeHelperFunctions.showErrorSnackBar('Error', 'Home ID cannot be null');
      return;
    }
    final homeToDelete = userHomeProfiles.firstWhere(
      (home) => home.id == homeId,
    );
    try {
      final isDeleted = await userRepository.deleteUserProperty(
        homeId,
        'homes',
      );
      if (isDeleted) {
        userHomeProfiles.removeWhere((home) => home.id == homeId);
        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Home deleted successfully!',
        );
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to delete home. Please try again later1.',
        );
      }
    } catch (e) {
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to delete home. Please try again later2.',
      );
    }

    // If deleted home was default, set first home as default
    if (homeToDelete.isDefault && userHomeProfiles.isNotEmpty) {
      userHomeProfiles.first.isDefault = true;
      userHomeProfiles.refresh(); // Notify observers
    }
    homeCount.value = userHomeProfiles.length;
  }

  /// Get a specific home by ID
  HomeProfile? getHomeById(String homeId) {
    try {
      return userHomeProfiles.firstWhere((home) => home.id == homeId);
    } catch (e) {
      return null;
    }
  }

  /// Get the default home
  HomeProfile? getDefaultHome() {
    try {
      return userHomeProfiles.firstWhere((home) => home.isDefault);
    } catch (e) {
      return userHomeProfiles.isNotEmpty ? userHomeProfiles.first : null;
    }
  }

  /// Set a vehicle as default
  void setDefaultVehicle(String vehicleId) {
    for (var vehicle in userVehicleProfiles) {
      vehicle.isDefault = vehicle.id == vehicleId;
    }
    userVehicleProfiles.refresh(); // Notify observers
  }

  /// Add a new vehicle profile
  Future<void> addVehicleProfile(VehicleProfile vehicle) async {
    try {
      isLoading.value = true;
      print('Adding new vehicle profile to backend...');

      final propertyData = vehicle.toMap();
      final isAdded = await userRepository.addUserProperty(
        propertyData,
        'vehicles',
      );

      if (isAdded) {
        // Add to local list and update UI
        userVehicleProfiles.add(vehicle);
        vehicleCount.value = userVehicleProfiles.length;
        userVehicleProfiles.refresh(); // Notify observers

        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Vehicle added successfully!',
        );
        print('Vehicle added successfully to backend and local list');
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to add vehicle. Please try again.',
        );
        print('Failed to add vehicle to backend');
      }
    } catch (e) {
      print('Error adding vehicle: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Connection Error',
        'Failed to add vehicle. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update an existing vehicle profile
  Future<void> updateVehicleProfile(VehicleProfile updatedVehicle) async {
    try {
      isLoading.value = true;
      print('Updating vehicle profile in backend...');

      if (updatedVehicle.id.isEmpty) {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Invalid vehicle ID for update',
        );
        return;
      }

      final propertyData = updatedVehicle.toMap();
      final isUpdated = await userRepository.editUserProperty(
        updatedVehicle.id,
        propertyData,
        'vehicles',
      );

      if (isUpdated) {
        // Update local list
        final index = userVehicleProfiles.indexWhere(
          (vehicle) => vehicle.id == updatedVehicle.id,
        );
        if (index != -1) {
          userVehicleProfiles[index] = updatedVehicle;
          userVehicleProfiles.refresh(); // Notify observers
          
          FixMeHelperFunctions.showSuccessSnackBar(
            'Success',
            'Vehicle updated successfully!',
          );
          print('Vehicle updated successfully in backend and local list');
        } else {
          FixMeHelperFunctions.showErrorSnackBar(
            'Error',
            'Vehicle not found for update',
          );
        }
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to update vehicle. Please try again.',
        );
        print('Failed to update vehicle in backend');
      }
    } catch (e) {
      print('Error updating vehicle: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Connection Error',
        'Failed to update vehicle. Please check your internet connection.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete a vehicle profile
  Future<void> deleteVehicleProfile(String vehicleId) async {
    if (vehicleId.isEmpty) {
      FixMeHelperFunctions.showErrorSnackBar('Error', 'Vehicle ID cannot be empty');
      return;
    }
    
    final vehicleToDelete = userVehicleProfiles.firstWhere(
      (vehicle) => vehicle.id == vehicleId,
    );
    
    try {
      final isDeleted = await userRepository.deleteUserProperty(
        vehicleId,
        'vehicles',
      );
      if (isDeleted) {
        userVehicleProfiles.removeWhere((vehicle) => vehicle.id == vehicleId);
        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Vehicle deleted successfully!',
        );
      } else {
        FixMeHelperFunctions.showErrorSnackBar(
          'Error',
          'Failed to delete vehicle. Please try again.',
        );
      }
    } catch (e) {
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to delete vehicle. Please try again.',
      );
    }

    // If deleted vehicle was default, set first vehicle as default
    if (vehicleToDelete.isDefault && userVehicleProfiles.isNotEmpty) {
      userVehicleProfiles.first.isDefault = true;
      userVehicleProfiles.refresh(); // Notify observers
    }
    vehicleCount.value = userVehicleProfiles.length;
  }

  /// Get a specific vehicle by ID
  VehicleProfile? getVehicleById(String vehicleId) {
    try {
      return userVehicleProfiles.firstWhere(
        (vehicle) => vehicle.id == vehicleId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get the default vehicle
  VehicleProfile? getDefaultVehicle() {
    try {
      return userVehicleProfiles.firstWhere((vehicle) => vehicle.isDefault);
    } catch (e) {
      return userVehicleProfiles.isNotEmpty ? userVehicleProfiles.first : null;
    }
  }
}
