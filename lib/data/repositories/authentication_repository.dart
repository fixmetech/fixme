import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:fixme/features/authentication/screens/login.dart';
import 'package:fixme/features/authentication/screens/on_boarding.dart';
import 'package:fixme/mainScreen.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
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
    deviceStorage.read('isLogin') != true
        ? deviceStorage.read('isFirstTime') == true
              ? Get.offAll(() => const OnboardingScreen())
              : Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const MainScreen());
  }

  // isLoggedIn
  bool isLoggedIn() {
    return deviceStorage.read('isLogin') ?? false;
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
  Future<bool> verifyOtpAndCreateAccount(BuildContext context) async {
    try {
      final signupController = Get.find<SignupController>();
      final smsCode = signupController.otpCode.value;

      if (!_isValidOtp(smsCode)) {
        _showInvalidOtpError();
        return false;
      }

      final userCredential = await _signInWithPhone(smsCode);

      if (userCredential.user != null) {
        // Step 2: Link email/password to phone-authenticated user
        final email = signupController.emailController.text.trim();
        final password = signupController.passwordController.text.trim();

        final emailCredential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );

        try {
          await userCredential.user!.linkWithCredential(emailCredential);
        } catch (e) {
          FixMeHelperFunctions.showErrorSnackBar(
            'Linking Failed',
            'Failed to link email and password: $e',
          );
          return false;
        }
        final isSaved = await _saveUserData(
          userCredential.user!,
          signupController,
        );

        if (!isSaved) {
          FixMeHelperFunctions.showErrorSnackBar(
            'Error',
            'Failed to save user data. Please try again.',
          );
          return false;
        }
        _handleSuccessfulLogin();
        return true;
      }

      return false;
    } catch (e) {
      FixMeHelperFunctions.showErrorSnackBar(
        'Verification Failed',
        'Invalid OTP or Internal error. Please try again.',
      );
      return false;
    }
  }

  bool _isValidOtp(String otp) {
    return otp.length == 6;
  }

  void _showInvalidOtpError() {
    FixMeHelperFunctions.showErrorSnackBar(
      'Invalid OTP',
      'Please enter a valid 6-digit OTP.',
    );
  }

  Future<UserCredential> _signInWithPhone(String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<bool> _saveUserData(
    User user,
    SignupController signupController,
  ) async {
    try {
      final userId = user.uid;
      await _firestore.collection('users').doc(userId).set({
        'firstName': signupController.firstNameController.text.trim(),
        'lastName': signupController.lastNameController.text.trim(),
        'email': signupController.emailController.text.trim(),
        'phone': user.phoneNumber ?? '',
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true; // Success
    } catch (e) {
      print('Error saving user data: $e');
      return false; // Failure
    }
  }

  Future<bool> _isEmailAlreadyInUse(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print('Error checking email existence: $e');
      return true; // to be safe
    }
  }

  void _handleSuccessfulLogin() {
    deviceStorage.write('isFirstTime', false);
    deviceStorage.write('isLogin', true);
    FixMeHelperFunctions.showSuccessSnackBar(
      'Success',
      'Phone number verified successfully!',
    );
  }

  // find email by phone number
  Future<String?> getEmailByPhone(String phone) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        print('Email found for phone $phone: ${querySnapshot.docs.first.data()['email']}');
        return querySnapshot.docs.first.data()['email'] as String?;
      }
      return null;
    } catch (e) {
      print('Error fetching email by phone: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to fetch email by phone number. Please try again.',
      );
      return null;
    }
  }

  // Sign in with Email and Password
  Future<bool> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
      // Check if user is successfully authenticated
      if (userCredential.user != null) {
        deviceStorage.write('isLogin', true);
        FixMeHelperFunctions.showSuccessSnackBar(
          'Success',
          'Login successful!',
        );
        return true; // Authentication successful
      } else {
        return false; // Authentication failed
      }
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.message}');
      FixMeHelperFunctions.showErrorSnackBar(
        'Login Failed',
        e.message ?? 'An error occurred during login.',
      );
      return false; // Authentication failed
    } catch (e) {
      print('Error in signInWithEmailAndPassword: $e');
      FixMeHelperFunctions.showErrorSnackBar(
        'Error',
        'Failed to sign in with email and password. Please try again.',
      );
      return false; // Authentication failed
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

