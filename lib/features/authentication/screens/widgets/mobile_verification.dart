import 'package:fixme/features/authentication/controller/signup_controller.dart';
import 'package:fixme/features/authentication/screens/widgets/back_button.dart';
import 'package:fixme/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:get/get.dart';

class MobileValidationScreen extends StatefulWidget {
  const MobileValidationScreen({super.key});

  @override
  State<MobileValidationScreen> createState() => _MobileValidationScreenState();
}

class _MobileValidationScreenState extends State<MobileValidationScreen> {
  void _setState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dark = FixMeDeviceUtils.isDarkMode(context);
    final controller = Get.find<SignupController>();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(FixMeSizes.defaultSpace),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FixMeTexts.fixmeTitle(context),
                  const SizedBox(height: FixMeSizes.spaceBtwSections),
              
                  Text(
                    'Please Verify Your Mobile Number',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: dark ? FixMeColors.light : FixMeColors.dark,
                        ),
                  ),
                  const SizedBox(height: FixMeSizes.spaceBtwItems),
              
                  Text(
                    'Enter the 6-digit code sent to your mobile number',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: dark ? FixMeColors.light : FixMeColors.dark,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FixMeSizes.spaceBtwSections),
              
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => _buildOtpField(index, dark),
                      ),
                    ),
                  ),
                  const SizedBox(height: FixMeSizes.spaceBtwSections),
              
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.otpCode.value.length == 6 &&
                                !controller.isVerifying.value
                            ? () => controller.startVerifyOtp(context)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              dark ? FixMeColors.light : FixMeColors.dark,
                          foregroundColor:
                              dark ? FixMeColors.dark : FixMeColors.light,
                          disabledBackgroundColor: dark
                              ? FixMeColors.light.withOpacity(0.3)
                              : FixMeColors.dark.withOpacity(0.3),
                          disabledForegroundColor: dark
                              ? FixMeColors.dark.withOpacity(0.5)
                              : FixMeColors.light.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(
                            vertical: FixMeSizes.buttonPaddingVertical,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isVerifying.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      width: FixMeSizes.spaceBtwItems),
                                  Text(
                                    'Verifying...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: dark
                                          ? FixMeColors.dark
                                          : FixMeColors.light,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'Verify OTP',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: dark
                                      ? FixMeColors.dark
                                      : FixMeColors.light,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: FixMeSizes.spaceBtwItems),
              
                  Obx(
                    () => TextButton(
                      onPressed: controller.isVerifying.value
                          ? null
                          : () => controller.resendOtp(context, _setState),
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: dark ? FixMeColors.light : FixMeColors.dark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backButton(dark: dark),
        ],
      ),
    );
  }

  Widget _buildOtpField(int index, bool dark) {
    final controller = Get.find<SignupController>();
    return Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.focusNodes[index].hasFocus
                ? (dark ? FixMeColors.light : FixMeColors.dark)
                : (dark
                    ? FixMeColors.light.withOpacity(0.3)
                    : FixMeColors.dark.withOpacity(0.3)),
            width: controller.focusNodes[index].hasFocus ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: dark
              ? FixMeColors.dark.withOpacity(0.1)
              : FixMeColors.light.withOpacity(0.1),
        ),
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          onChanged: (value) {
            controller.onOtpChanged(value, index, context, _setState);
            controller.otpCode.value =
                controller.otpControllers.map((c) => c.text).join();
          },
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: dark ? FixMeColors.light : FixMeColors.dark,
          ),
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          onTap: () => controller.onTextFieldTap(index),
        ),
    );
  }
}
