import 'package:fixme/features/authentication/controller/onboarding_controller.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:flutter/material.dart';

class nextButton extends StatelessWidget {
  const nextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = FixMeDeviceUtils.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(FixMeSizes.defaultSpace),
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
          side: BorderSide.none,
          shape: const CircleBorder(),
          backgroundColor: dark ? FixMeColors.light : FixMeColors.dark,
        ),
        child: Icon(
          Icons.arrow_forward_ios,
          color: dark ? FixMeColors.dark : FixMeColors.light,
        ),
      ),
    );
  }
}
