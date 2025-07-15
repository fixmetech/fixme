import 'package:fixme/data/repositories/authentication_repository.dart';
import 'package:fixme/features/authentication/controller/onboarding_controller.dart';
import 'package:fixme/features/authentication/screens/on_boarding.dart';
import 'package:fixme/mainScreen.dart';
import 'package:fixme/utils/helper/helper_functions.dart';
import 'package:fixme/utils/helper/network_manager.dart';
import 'package:fixme/utils/loader/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Form fields and states
  final formKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  final isVerifying = false.obs;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final RxString otpCode = ''.obs;
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  /// Sign up user and request OTP
  Future<void> signup(BuildContext context) async {
    try {
      if (!validateForm()) return;

      if (!privacyPolicy.value) {
        FixMeHelperFunctions.showWarningSnackBar(
          'Privacy Policy',
          'Please accept the privacy policy to continue.',
        );
        return;
      }

      FullScreenLoader.showLoader(
        context: context,
        text: 'Creating your account...',
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

      final phone = phoneNumberController.text.trim();
      await AuthenticationRepository.instance.verifyPhone(phone);
      FullScreenLoader.hideLoader(context);
      OnboardingController.instance.nextPage();
    } catch (e) {
      FullScreenLoader.hideLoader(context);
      FixMeHelperFunctions.showErrorSnackBar('Error', e.toString());
    }
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  void clearForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneNumberController.clear();
  }

  /// Start OTP verification
  Future<void> startVerifyOtp(BuildContext context) async {
    try {
      isVerifying.value = true;

      FullScreenLoader.showLoader(
        context: context,
        text: 'Verifying OTP...',
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

      // Update the reactive OTP code
      otpCode.value = otpControllers.map((c) => c.text).join();

      await AuthenticationRepository.instance.verifyOtp(context, () {
        update();
      });
      FullScreenLoader.hideLoader(context);

      Get.offAll(MainScreen());
    } catch (e) {
      FullScreenLoader.hideLoader(context);
      FixMeHelperFunctions.showErrorSnackBar('Error', e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  /// OTP input change handler
  void onOtpChanged(
    String value,
    int index,
    BuildContext context,
    VoidCallback setState,
  ) {
    otpCode.value = otpControllers.map((c) => c.text).join();
    setState();

    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  /// Clear all OTP input fields
  void clearOtp(BuildContext context, VoidCallback setState) {
    for (var controller in otpControllers) {
      controller.clear();
    }
    otpCode.value = '';
    setState();
    FocusScope.of(context).requestFocus(focusNodes[0]);
  }

  /// Select all text when tapping OTP field
  void onTextFieldTap(int index) {
    otpControllers[index].selection = TextSelection(
      baseOffset: 0,
      extentOffset: otpControllers[index].text.length,
    );
  }

  /// Resend OTP
  Future<void> resendOtp(BuildContext context, VoidCallback setState) async {
    try {
      clearOtp(context, setState);

      FullScreenLoader.showLoader(
        context: context,
        text: 'Resending OTP...',
        lottieAsset: 'assets/animations/loader1.json',
      );

      final phone = phoneNumberController.text.trim();
      await AuthenticationRepository.instance.verifyPhone(phone);

      FullScreenLoader.hideLoader(context);
      FixMeHelperFunctions.showSuccessSnackBar(
        'OTP Sent',
        'A new OTP has been sent to your phone number.',
      );
    } catch (e) {
      FullScreenLoader.hideLoader(context);
      FixMeHelperFunctions.showErrorSnackBar('Error', e.toString());
    }
  }
}
