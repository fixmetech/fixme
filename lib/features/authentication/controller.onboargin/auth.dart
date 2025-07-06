import 'package:flutter/material.dart';

class AuthController {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String _otpCode = '';
  bool _isVerifying = false;

  // Getters
  List<TextEditingController> get otpControllers => _otpControllers;
  List<FocusNode> get focusNodes => _focusNodes;
  String get otpCode => _otpCode;
  bool get isVerifying => _isVerifying;

  // Dispose method
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
  }

  // OTP change handler
  void onOtpChanged(String value, int index, BuildContext context, VoidCallback setState) {
    // setState(() {
    //   _otpCode = _otpControllers.map((controller) => controller.text).join();
    // });

    if (value.length == 1 && index < 3) {
      // Move to next field
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move to previous field
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  // Verify OTP
  Future<void> verifyOtp(BuildContext context, VoidCallback setState) async {
    if (_otpCode.length != 4) {
      _showSnackBar(context, 'Please enter a 4-digit OTP code');
      return;
    }

    // setState(() {
    //   _isVerifying = true;
    // });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // setState(() {
    //   _isVerifying = false;
    // });

    // Handle verification result
    if (_otpCode == '1234') { // Mock validation
      _showSnackBar(context, 'OTP verified successfully!', isSuccess: true);
      // Navigate to next screen or complete registration
    } else {
      _showSnackBar(context, 'Invalid OTP. Please try again.');
      clearOtp(context, setState);
    }
  }

  // Clear OTP
  void clearOtp(BuildContext context, VoidCallback setState) {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    // setState(() {
    //   _otpCode = '';
    // });
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  // Show snackbar
  void _showSnackBar(BuildContext context, String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Resend OTP
  void resendOtp(BuildContext context, VoidCallback setState) {
    _showSnackBar(context, 'OTP resent successfully!', isSuccess: true);
    clearOtp(context, setState);
  }

  // Handle text field tap
  void onTextFieldTap(int index) {
    _otpControllers[index].selection = TextSelection(
      baseOffset: 0,
      extentOffset: _otpControllers[index].text.length,
    );
  }
}