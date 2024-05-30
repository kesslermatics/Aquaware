import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'register_form.dart';
import 'sign_in_form.dart';

Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Sign up",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 620,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Access to 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SignInForm(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      customRegisterDialog(context, onClosed: onClosed);
                    },
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}

Future<Object?> customRegisterDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: "Register",
    context: context,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        ),
        child: child,
      );
    },
    pageBuilder: (context, _, __) => Center(
      child: Container(
        height: 620,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Join us and enjoy 240+ hours of content. Learn design and code, by building real apps with Flutter and Swift.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const RegisterForm(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      customSigninDialog(context, onClosed: onClosed);
                    },
                    child: const Text("Already have an account? Sign In"),
                  ),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: -48,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ).then(onClosed);
}
