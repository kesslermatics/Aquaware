import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';
import 'components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  bool isRegisterDialogShown = false; // Add this line
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: const RiveAnimation.asset(
              'assets/RiveAssets/small_lake_on_a_rainy_day.riv',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
              child: SizedBox(), // Optional: Add a slight color overlay
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 240),
            top: isSignInDialogShown || isRegisterDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "Welcome to Aquaware",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Monitor and predict your aquarium's water parameters with ease.",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 70.0),
                      child: AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;
                          Future.delayed(Duration(milliseconds: 2), () {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                            customSigninDialog(context, onClosed: (_) {
                              setState(() {
                                isSignInDialogShown = false;
                              });
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
