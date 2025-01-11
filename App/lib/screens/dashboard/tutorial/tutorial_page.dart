import 'package:aquaware/screens/dashboard/tutorial/tutorial_step_page.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/tutorial_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TutorialService());

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
            children: const [
              TutorialStepPage(
                title: "Welcome to Aquaware",
                content:
                    """Aquaware is your ultimate solution for water monitoring. 
Whether you're managing an aquarium, pond, or any water body, 
Aquaware provides you with powerful tools to track water quality effortlessly.\n
I'm Robert, the creator of Aquaware. 
This app is designed to make water management simple, accessible, and even a bit fun!""",
              ),
              TutorialStepPage(
                title: "What the App Can Do",
                content: """With Aquaware, you can monitor water parameters, 
visualize data in real-time, and get personalized insights.

It's your companion for ensuring the health and quality of your aquatic environments.
Whether you're a hobbyist or a professional, Aquaware makes it easy.""",
              ),
              TutorialStepPage(
                title: "Understanding Environments",
                content:
                    """An environment in Aquaware represents a water body, like an aquarium, pond, or lake. 
You can create an environment by tapping the '+' icon on the dashboard. 

Public environments are also available if shared by others. 
All water values for an environment are stored and visualized for easy monitoring.""",
              ),
              TutorialStepPage(
                title: "Adding Water Parameters",
                content:
                    """To add water parameters, you'll need a microcontroller like an Arduino with a WiFi module and sensors for temperature, pH, or other parameters. 

Simply read the sensor values and upload them. 
For a detailed guide, visit our documentation: 
https://docs.aquaware.cloud/docs/getting-started/adding-water-values""",
              ),
              TutorialStepPage(
                title: "Subscription Plans",
                content:
                    """Aquaware offers three subscription plans tailored to your needs:

**Hobby Plan**:
- Free for personal use.
- Monitor all parameters.
- Upload values every 12 hours.

**Advanced Plan**:
- More precise tracking with uploads every 3 hours.
- Alerts for specific parameters.

**Premium Plan**:
- Upload values every 30 minutes.
- Unlimited environments.
- AI-based fish identification and disease detection.""",
              ),
              TutorialStepPage(
                title: "Thank You!",
                content:
                    """Thank you for choosing Aquaware as your water monitoring solution. 
Your trust and support mean the world to me. 

Aquaware was created to make water management simple, accessible, and effective. 
We're thrilled to have you in our growing community and are here to support you every step of the way.""",
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
