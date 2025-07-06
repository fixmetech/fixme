import 'package:fixme/features/authentication/controller.onboargin/auth.dart';
import 'package:fixme/features/authentication/controller.onboargin/onboarding_controller.dart';
import 'package:fixme/features/authentication/screens/widgets/back_button.dart';
import 'package:fixme/utils/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';

class MobileValidationScreen extends StatefulWidget {
  const MobileValidationScreen({super.key});

  @override
  State<MobileValidationScreen> createState() => _MobileValidationScreenState();
}

class _MobileValidationScreenState extends State<MobileValidationScreen> {
  final AuthController _controller = AuthController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dark = FixMeDeviceUtils.isDarkMode(context);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(FixMeSizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FixMeTexts.fixmeTitle(context),
              const SizedBox(height: FixMeSizes.spaceBtwSections),
              // Title
              Text(
                'Please Verify Your Mobile Number',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: dark ? FixMeColors.light : FixMeColors.dark,
                ),
              ),
              const SizedBox(height: FixMeSizes.spaceBtwItems),

              // Subtitle
              Text(
                'Enter the 4-digit code sent to your mobile number',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: dark ? FixMeColors.light : FixMeColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FixMeSizes.spaceBtwSections),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _buildOtpField(index, dark),
                ),
              ),
              const SizedBox(height: FixMeSizes.spaceBtwSections),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _controller.otpCode.length == 4 &&
                          !_controller.isVerifying
                      ? () => _controller.verifyOtp(context, _setState)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dark
                        ? FixMeColors.light
                        : FixMeColors.dark,
                    foregroundColor: dark
                        ? FixMeColors.dark
                        : FixMeColors.light,
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
                  child: _controller.isVerifying
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  dark ? FixMeColors.dark : FixMeColors.light,
                                ),
                              ),
                            ),
                            const SizedBox(width: FixMeSizes.spaceBtwItems),
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
                            color: dark ? FixMeColors.dark : FixMeColors.light,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: FixMeSizes.spaceBtwItems),

              // Resend OTP
              TextButton(
                onPressed: () => _controller.resendOtp(context, _setState),
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: dark ? FixMeColors.light : FixMeColors.dark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backButton(dark: dark),
      ],
    );
  }

  Widget _buildOtpField(int index, bool dark) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: _controller.focusNodes[index].hasFocus
              ? (dark ? FixMeColors.light : FixMeColors.dark)
              : (dark
                    ? FixMeColors.light.withOpacity(0.3)
                    : FixMeColors.dark.withOpacity(0.3)),
          width: _controller.focusNodes[index].hasFocus ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: dark
            ? FixMeColors.dark.withOpacity(0.1)
            : FixMeColors.light.withOpacity(0.1),
      ),
      child: TextField(
        controller: _controller.otpControllers[index],
        focusNode: _controller.focusNodes[index],
        onChanged: (value) =>
            _controller.onOtpChanged(value, index, context, _setState),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
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
        onTap: () => _controller.onTextFieldTap(index),
      ),
    );
  }
}

