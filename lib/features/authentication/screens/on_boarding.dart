import 'package:fixme/features/authentication/controller.onboargin/onboarding_controller.dart';
import 'package:fixme/features/authentication/screens/widgets/mobile_verification.dart';
import 'package:fixme/features/authentication/screens/widgets/next_button.dart';
import 'package:fixme/features/authentication/screens/widgets/on_boarding_navigation.dart';
import 'package:fixme/features/authentication/screens/widgets/registering_screen.dart';
import 'package:fixme/features/authentication/screens/widgets/welcome_screen.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final controller = Get.put(OnboardingController());
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
               physics: const NeverScrollableScrollPhysics(),
            children: [
              welcome_screen(),
              RegisteringScreen(),
              MobileValidationScreen(),
            ]),
          // dot navigation smooth indicator
          onBoardingNavigation(),

        ],
      ),
    );
  }
}

