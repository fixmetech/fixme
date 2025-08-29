import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends GetxController {
  static EditProfileScreen get instance => Get.find();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  
  final profileController = Get.find<ProfileController>();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void loadUserData() {
    // Split full name into first and last name
    final nameParts = profileController.fullName.value.split(' ');
    firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';
    lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    emailController.text = profileController.email.value;
    phoneController.text = profileController.phone.value;
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    await profileController.updateProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      newEmail: emailController.text.trim(),
      newPhone: phoneController.text.trim(),
    );

    Get.back(); // Return to profile screen
  }
}

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final editController = Get.put(EditProfileScreen());
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: editController.formKey,
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Obx(() => CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: profileController.profileImageUrl.value.isNotEmpty
                          ? NetworkImage(profileController.profileImageUrl.value)
                          : const AssetImage('assets/images/car.png') as ImageProvider,
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[800],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          onPressed: () {
                            // TODO: Implement image picker
                            Get.snackbar('Info', 'Image picker functionality will be added');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // First Name Field
              TextFormField(
                controller: editController.firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Last Name Field
              TextFormField(
                controller: editController.lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: editController.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: editController.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.trim().length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: profileController.isLoading.value 
                      ? null 
                      : editController.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: profileController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
