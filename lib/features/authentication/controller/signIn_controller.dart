import 'package:fixme/data/repositories/authentication_repository.dart';
import 'package:fixme/mainScreen.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/utils/helper/network_manager.dart';
import 'package:fixme/utils/loader/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  // Form fields and states
  final hidePassword = true.obs;
  final isVerifying = false.obs;

  final identifierController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString otpCode = ''.obs;

  @override
  void onClose() {
    identifierController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Sign in user and request OTP
  Future<void> signIn(BuildContext context) async {
    try {
      FullScreenLoader.showLoader(
        context: context,
        text: 'Signing you in...',
        lottieAsset: 'assets/animations/loader1.json',
      );

      final isConnected = await NetworkManager.instance.isConnectedToInternet();
      if (!isConnected) {
        FullScreenLoader.hideLoader(context);
        FixMeHelperFunctions.showWarningSnackBar(
          'Network Error',
          'Please check your internet connection and try again.',
        );
        return;
      }

      final identifier = identifierController.text.trim();
      final password = passwordController.text.trim();

      String? emailToUse;

      if (FixMeHelperFunctions.isValidEmail(identifier)) {
        emailToUse = identifier;
      } else if (FixMeHelperFunctions.isValidPhoneNumber(identifier)) {
        emailToUse = await AuthenticationRepository.instance.getEmailByPhone(
          identifier,
        );
        if (emailToUse == null) {
          FullScreenLoader.hideLoader(context);
          FixMeHelperFunctions.showErrorSnackBar(
            'Invalid Phone Number',
            'No account found for this phone number.',
          );
          return;
        }
      } else {
        FullScreenLoader.hideLoader(context);
        FixMeHelperFunctions.showErrorSnackBar(
          'Invalid Input',
          'Please enter a valid email or phone number.',
        );
        return;
      }

      // Now login with email + password
      final isSuccess = await AuthenticationRepository.instance.signInWithEmailAndPassword(
        emailToUse,
        password,
      );

      FullScreenLoader.hideLoader(context);
      if (isSuccess) {
        Get.offAll(() => MainScreen());
      }
    } catch (e) {
      FullScreenLoader.hideLoader(context);
      FixMeHelperFunctions.showErrorSnackBar('Error', e.toString());
    }
  }

  void clearForm() {
    identifierController.clear();
    passwordController.clear();
  }
}
