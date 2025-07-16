import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:fixme/features/authentication/screens/login.dart';
import 'package:fixme/features/authentication/screens/on_boarding.dart';
import 'package:fixme/mainScreen.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  String _verificationId = '';

  // call from main.dart app
  @override
  void onReady() {
    // FlutterNativeSplashScreen.remove();
    screenRedirect();
  }

  // Flutter function to show relevant screen
  screenRedirect() async {
    deviceStorage.writeIfNull('isFirstTime', true);
    deviceStorage.writeIfNull('isLogin', false);
    deviceStorage.read('isFirstTime') != true
        ? deviceStorage.read('isLogin') == true
              ? Get.offAll(() => const MainScreen())
              : Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const OnboardingScreen());
  }

  /* -------------------- sign in -------------------- */

  // Sign in with Phone Number
  Future<void> verifyPhone(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto sign-in (on some devices)
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          // Show an error message
          FixMeHelperFunctions.showErrorSnackBar(
            'Verification Failed',
            e.message ?? 'An error occurred during phone verification.',
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save this ID for when the user enters the OTP
          _verificationId = verificationId;
          print('Code sent to $phoneNumber');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      print('Error in verifyPhone: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to send OTP. Please try again.',
      );
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(BuildContext context) async {
    try {
      final signupController = Get.find<SignupController>();
      final smsCode = signupController.otpCode.value;

      if (smsCode.length != 6) {
        FixMeHelperFunctions.showErrorSnackBar(
          'Invalid OTP',
          'Please enter a valid 6-digit OTP.',
        );
        return false;
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        deviceStorage.write('isFirstTime', false);
        deviceStorage.write('isLogin', true);
        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Phone number verified successfully!',
        );
        return true;
      }

      return false;
    } catch (e) {
      print("OTP Verification Failed: $e");
      FixMeHelperFunctions.showErrorSnackBar(
        'Verification Failed',
        'Invalid OTP or Internal error. Please try again.',
      );
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      deviceStorage.write('isLogin', false);
    } catch (e) {
      print('Sign out failed: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Sign Out Failed',
        'An error occurred while signing out. Please try again.',
      );
    }
  }
}
