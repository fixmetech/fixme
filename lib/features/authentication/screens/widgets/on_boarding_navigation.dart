import 'package:fixme/features/authentication/controller.onboargin/onboarding_controller.dart';
import 'package:fixme/utils/constants/colors.dart';
import 'package:fixme/utils/constants/size.dart';
import 'package:fixme/utils/device/device_utils.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingNavigation extends StatelessWidget {
  const onBoardingNavigation({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = FixMeDeviceUtils.isDarkMode(context);
    return Positioned(
      bottom: 65,
      left: FixMeSizes.defaultSpace,
    
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(activeDotColor: dark ? FixMeColors.light : FixMeColors.dark, dotHeight: 6),
      ),
    );
  }
}
