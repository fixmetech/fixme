import 'package:fixme/data/repositories/user_repository.dart';
import 'package:fixme/models/home_profile.dart';
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

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    loadUserData();
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
        userHomeProfiles.value =
            (userData['homeProfiles'] as List<dynamic>?)
                ?.map((homeData) => HomeProfile.fromMap(homeData))
                .toList() ??
            [
              HomeProfile(
                id: '1',
                name: 'My Home',
                address: '123 Main Street, Apartment 4B',
                city: 'Colombo',
                postalCode: '10100',
                homeType: 'Apartment',
                imageUrl: '',
                isDefault: true,
                area: '1200 sq ft',
                phone: '+94 77 123 4567',
              ),
              HomeProfile(
                id: '2',
                name: 'Parent\'s House',
                address: '456 Oak Avenue',
                city: 'Kandy',
                postalCode: '20000',
                homeType: 'House',
                imageUrl: '',
                isDefault: false,
                area: '2000 sq ft',
                phone: '+94 81 234 5678',
              ),
              HomeProfile(
                id: '3',
                name: 'Office Space',
                address: '789 Business District',
                city: 'Colombo',
                postalCode: '10300',
                homeType: 'Office',
                imageUrl: '',
                isDefault: false,
                area: '800 sq ft',
                phone: '+94 11 345 6789',
              ),
            ];
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

  /// Refresh user data
  Future<void> refreshUserData() async {
    await loadUserData();
  }

  /// Set a home as default
  void setDefaultHome(String homeId) {
    for (var home in userHomeProfiles) {
      home.isDefault = home.id == homeId;
    }
    userHomeProfiles.refresh(); // Notify observers
  }

  /// Add a new home profile
  void addHomeProfile(HomeProfile home) {
    userHomeProfiles.add(home);
  }

  /// Update an existing home profile
  void updateHomeProfile(HomeProfile updatedHome) {
    final index = userHomeProfiles.indexWhere(
      (home) => home.id == updatedHome.id,
    );
    if (index != -1) {
      userHomeProfiles[index] = updatedHome;
      userHomeProfiles.refresh(); // Notify observers
    }
  }

  /// Delete a home profile
  void deleteHomeProfile(String homeId) {
    final homeToDelete = userHomeProfiles.firstWhere(
      (home) => home.id == homeId,
    );
    userHomeProfiles.removeWhere((home) => home.id == homeId);

    // If deleted home was default, set first home as default
    if (homeToDelete.isDefault && userHomeProfiles.isNotEmpty) {
      userHomeProfiles.first.isDefault = true;
      userHomeProfiles.refresh(); // Notify observers
    }
  }
}
