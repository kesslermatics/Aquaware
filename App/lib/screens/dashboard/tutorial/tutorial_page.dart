import 'package:aquaware/screens/dashboard/tutorial/tutorial_step_page.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/tutorial_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TutorialService());
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.currentTitle)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              TutorialStepPage(
                title: loc.tutorialWelcomeTitle,
                content: loc.tutorialWelcomeContent,
              ),
              TutorialStepPage(
                title: loc.tutorialAppFeaturesTitle,
                content: loc.tutorialAppFeaturesContent,
              ),
              TutorialStepPage(
                title: loc.tutorialEnvironmentsTitle,
                content: loc.tutorialEnvironmentsContent,
              ),
              TutorialStepPage(
                title: loc.tutorialAddWaterParametersTitle,
                content: loc.tutorialAddWaterParametersContent,
              ),
              TutorialStepPage(
                title: loc.tutorialSubscriptionPlansTitle,
                content: loc.tutorialSubscriptionPlansContent,
              ),
              TutorialStepPage(
                title: loc.tutorialThankYouTitle,
                content: loc.tutorialThankYouContent,
              ),
            ],
          ),
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
              count: controller.totalSteps,
            ),
          ),
          Positioned(
            right: 16.0,
            bottom: MediaQuery.of(context).viewPadding.bottom +
                kBottomNavigationBarHeight,
            child: Obx(() {
              final isLastPage = controller.currentPageIndex.value ==
                  controller.totalSteps - 1;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                onPressed: () {
                  if (isLastPage) {
                    Navigator.pop(context);
                  } else {
                    controller.nextPage();
                  }
                },
                child: Icon(isLastPage ? Icons.check : Icons.arrow_forward),
              );
            }),
          ),
        ],
      ),
    );
  }
}
