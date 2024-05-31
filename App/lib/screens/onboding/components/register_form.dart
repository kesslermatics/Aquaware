import 'package:aquaware/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rive/rive.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void register(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        // show success
        check.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
        });
      } else {
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 350,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Username",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "User is required";
                                }
                                return null;
                              },
                              onSaved: (email) {},
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                      "assets/icons/username.svg"),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Email",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email is required";
                                }
                                return null;
                              },
                              onSaved: (email) {},
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                      "assets/icons/email.svg"),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Password",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password is required";
                                }
                                return null;
                              },
                              onSaved: (password) {},
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                      "assets/icons/password.svg"),
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Confirm Password",
                            style: TextStyle(color: Colors.black54),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please confirm your password";
                                }
                                return null;
                              },
                              onSaved: (confirmPassword) {},
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                      "assets/icons/password.svg"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 16, left: 16, right: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    register(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightBlue,
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.start,
                  ),
                  label: const Text("Register"),
                ),
              ),
            ],
          ),
        ),
        if (isShowLoading)
          CustomPositioned(
            child: RiveAnimation.asset(
              "assets/RiveAssets/check.riv",
              onInit: (artboard) {
                StateMachineController controller = getRiveController(artboard);
                check = controller.findSMI("Check") as SMITrigger;
                error = controller.findSMI("Error") as SMITrigger;
                reset = controller.findSMI("Reset") as SMITrigger;
              },
            ),
          ),
        if (isShowConfetti)
          CustomPositioned(
            child: Transform.scale(
              scale: 6,
              child: RiveAnimation.asset(
                "assets/RiveAssets/confetti.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  confetti =
                      controller.findSMI("Trigger explosion") as SMITrigger;
                },
              ),
            ),
          ),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
