import 'package:aquaware/screens/onboarding/components/onboarding_page.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingService());

    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnboardingPage(
                imagePath: 'assets/images/onboarding_1.png',
                title: AppLocalizations.of(context)!.welcomeToAquaware,
                paragraph: AppLocalizations.of(context)!.chooseLanguage,
                showLanguageDropdown: true,
              ),
              OnboardingPage(
                imagePath: 'assets/images/onboarding_2.png',
                title: AppLocalizations.of(context)!.smartAndEfficient,
                paragraph: AppLocalizations.of(context)!.uploadParameters,
              ),
              OnboardingPage(
                imagePath: 'assets/images/onboarding_3.png',
                title: AppLocalizations.of(context)!.visualizeAndControl,
                paragraph: AppLocalizations.of(context)!.getStarted,
              ),
            ],
          ),
          // Skip Button
          Positioned(
            top: kToolbarHeight,
            right: 16.0,
            child: TextButton(
              onPressed: () {
                controller.skipPage();
              },
              child: Text(AppLocalizations.of(context)!.skip),
            ),
          ),
          // Dot Indicator
          Positioned(
            bottom: MediaQuery.of(context).viewPadding.bottom +
                kBottomNavigationBarHeight,
            left: 16,
            child: SmoothPageIndicator(
              effect: const ExpandingDotsEffect(
                activeDotColor: ColorProvider.n17,
                dotColor: ColorProvider.n2,
                dotHeight: 6,
              ),
              controller: controller.pageController,
              onDotClicked: controller.dotNavigationClick,
              count: 3,
            ),
          ),
          // Next Button
          Positioned(
            right: 16.0,
            bottom: MediaQuery.of(context).viewPadding.bottom +
                kBottomNavigationBarHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const CircleBorder()),
              onPressed: () {
                controller.nextPage();
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
