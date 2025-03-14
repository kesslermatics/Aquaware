import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TutorialService extends GetxController {
  static TutorialService get instance => Get.find();

  final pageController = PageController();
  final currentPageIndex = 0.obs;

  final int totalSteps = 6;

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndex.value < totalSteps - 1) {
      int page = currentPageIndex.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
