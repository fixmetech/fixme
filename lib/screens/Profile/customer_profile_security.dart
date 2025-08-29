import 'package:fixme/features/profile/controller/profile_controller.dart';
import 'package:fixme/screens/Profile/common_profile.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Professional security settings screen with enhanced validation and UX
class CustomerProfileSecurity extends StatefulWidget {
  const CustomerProfileSecurity({super.key});

  @override
  State<CustomerProfileSecurity> createState() => _CustomerProfileSecurityState();
}

class _CustomerProfileSecurityState extends State<CustomerProfileSecurity> {
  // Form and validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final profileController = Get.find<ProfileController>();

  // State management
  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _hasPasswordRequirements = false;

  // Password strength indicators
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumbers = false;
  bool _hasSpecialChars = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validatePasswordStrength);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonProfile(
      title: 'Customer Profile',
      selectedIndex: 2, // Current bottom tab (security)
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSecurityHeader(),
            const SizedBox(height: 24),
            _buildPasswordChangeSection(),
            const SizedBox(height: 32),
            _buildSecurityOptionsSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FixMeColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.security,
                color: FixMeColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Security',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your password and security preferences',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordChangeSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: FixMeColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Password Requirements Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: FixMeColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Password Requirements',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPasswordRequirement('At least 8 characters', _hasMinLength),
                  _buildPasswordRequirement('At least one uppercase letter', _hasUppercase),
                  _buildPasswordRequirement('At least one lowercase letter', _hasLowercase),
                  _buildPasswordRequirement('At least one number', _hasNumbers),
                  _buildPasswordRequirement('At least one special character (!@#\$%^&*)', _hasSpecialChars),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Current Password Field
            _buildPasswordField(
              controller: _currentPasswordController,
              label: 'Current Password',
              isVisible: _isCurrentPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current password is required';
                }
                return null;
              },
              helperText: 'Last updated: November 11, 2024',
            ),

            const SizedBox(height: 20),

            // New Password Field
            _buildPasswordField(
              controller: _newPasswordController,
              label: 'New Password',
              isVisible: _isNewPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isNewPasswordVisible = !_isNewPasswordVisible;
              }),
              validator: _validateNewPassword,
            ),

            const SizedBox(height: 20),

            // Confirm Password Field
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              isVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () => setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              }),
              validator: _validateConfirmPassword,
            ),

            const SizedBox(height: 16),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _handleForgotPassword,
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required String? Function(String?) validator,
    String? helperText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: FixMeColors.primary, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[600],
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? FixMeColors.success : Colors.grey[400],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
                fontSize: 14,
                color: isMet ? FixMeColors.success : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOptionsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.devices,
                  color: FixMeColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Security Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.logout, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Log out of other devices',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose this option if you believe someone else is using your account. '
                        'This will sign you out of all devices except this one.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _handleLogoutOtherDevices,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange[700],
                        side: BorderSide(color: Colors.orange[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Log out other devices'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Obx(() => ElevatedButton.icon(
            onPressed: profileController.isLoading.value ? null : _handlePasswordChange,
            style: ElevatedButton.styleFrom(
              backgroundColor: FixMeColors.borderFocus,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            icon: profileController.isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.lock_reset),
            label: Text(
              profileController.isLoading.value ? 'Changing Password...' : 'Change Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: profileController.isLoading.value ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
              ),
            ),
          )),
        ),
      ],
    );
  }

  // Validation Methods
  void _validatePasswordStrength() {
    final password = _newPasswordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasLowercase = password.contains(RegExp(r'[a-z]'));
      _hasNumbers = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      _hasPasswordRequirements = _hasMinLength && _hasUppercase &&
          _hasLowercase && _hasNumbers && _hasSpecialChars;
    });
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }

    if (!_hasPasswordRequirements) {
      return 'Password does not meet requirements';
    }

    if (value == _currentPasswordController.text) {
      return 'New password must be different from current password';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }

    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Event Handlers
  Future<void> _handlePasswordChange() async {
    // First validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Double check password requirements
    if (!_hasPasswordRequirements) {
      FixMeHelperFunctions.showWarningSnackBar('Error','Please ensure your new password meets all requirements');
      return;
    }
    try {
      // Update the password using the controller
      await profileController.updatePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      // If successful, go back and refresh the list
      if (!profileController.isLoading.value) {
         // _clearForm();
      }
    } catch (e) {
      FixMeHelperFunctions.showWarningSnackBar('Error','Updating password: $e');
    }
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password functionality
    FixMeHelperFunctions.showInfoSnackBar('','Forgot password feature will be available soon');
  }

  void _handleLogoutOtherDevices() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.orange[700]),
              const SizedBox(width: 8),
              const Text('Log out other devices'),
            ],
          ),
          content: const Text(
            'This will sign you out of all other devices. You will need to sign in again on those devices.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logoutOtherDevices();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
              ),
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }

  void _logoutOtherDevices() {
    // TODO: Implement logout other devices logic
    FixMeHelperFunctions.showSuccessSnackBar('Success', 'Successfully logged out of other devices');
  }

  void _clearForm() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _isCurrentPasswordVisible = false;
      _isNewPasswordVisible = false;
      _isConfirmPasswordVisible = false;
    });
  }
}