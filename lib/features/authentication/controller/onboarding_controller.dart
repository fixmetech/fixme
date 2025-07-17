import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  
  // variables
  final pageController = PageController();
  Rx<int> currentIndex = 0.obs;
  
  // update current index when page scrolls
  void updatePageIndicator(int index) => currentIndex.value = index;
  
  void dotNavigationClick(int index) {
    if(index == 2) return;
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // update current index and jump to the next page
  void nextPage() {
    if (currentIndex.value == 2) {
      // go to login page
      goToLogin();
    } else {
      int page = currentIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // update current index and jump to the previous page
  void previousPage() {
    if (currentIndex.value == 0) {
      // do nothing, already on the first page
      return;
    } else {
      int page = currentIndex.value - 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  // navigate to the login page
  void goToLogin() {
    Get.offNamed('/login');
  }
}