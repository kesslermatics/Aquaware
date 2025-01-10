import 'package:aquaware/screens/onboarding/components/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingService extends GetxController {
  static OnboardingService get instance => Get.find();

  final pageController = PageController();
  final currentPageIndex = 0.obs;

  void updatePageIndicator(index) => currentPageIndex.value = index;

  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.offAll(LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(page,
          duration: Durations.medium1, curve: Curves.easeInOut);
    }
  }

  void skipPage() {
    Get.offAll(LoginScreen());
  }
}
