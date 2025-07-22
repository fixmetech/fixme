import 'package:fixme/features/authentication/controller/onboarding_controller.dart';
import 'package:fixme/features/authentication/screens/widgets/mobile_verification.dart';
import 'package:fixme/features/authentication/screens/widgets/on_boarding_navigation.dart';
import 'package:fixme/features/authentication/screens/widgets/registering_screen.dart';
import 'package:fixme/features/authentication/screens/widgets/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  final int initialPage;

   const OnboardingScreen({
    super.key,
    this.initialPage = 0,
  });

  
  @override
  Widget build(BuildContext context) {

    final controller = Get.put(OnboardingController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.pageController.hasClients) {
        controller.pageController.animateToPage(
          initialPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    return Scaffold(
      // Solution 1: Prevent keyboard from resizing the body
      resizeToAvoidBottomInset: false,

      appBar: AppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            // Only scroll when keyboard is open
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height,
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.updatePageIndicator,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  welcome_screen(),
                  RegisteringScreen(),
                  MobileValidationScreen(),
                ],
              ),
            ),
          ),

          onBoardingNavigation(),
        ],
      ),
    );
  }
}
