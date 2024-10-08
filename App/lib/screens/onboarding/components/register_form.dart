import 'package:aquaware/constants.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;

  final UserService _userService = UserService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com");

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  Future<void> _register(BuildContext context) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    final errorMessage = await _userService.signup(
      _emailController.text,
      _passwordController.text,
      _confirmPasswordController.text,
      _firstNameController.text,
      _lastNameController.text,
    );

    if (errorMessage == null) {
      setState(() {
        check.fire();
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isShowLoading = false;
          confetti.fire();
        });
        _userService.login(_emailController.text, _passwordController.text);
        Navigator.pushReplacementNamed(context, '/homepage');
      });
    } else {
      setState(() {
        error.fire();
        isShowLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _googleSignup() async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // The user canceled the sign-in
      }

      final googleAuth = await googleUser.authentication;
      final googleToken = googleAuth.idToken;

      // Send the token to your backend
      final errorMessage = await _userService.googleSignup(googleToken);

      if (errorMessage == null) {
        setState(() {
          check.fire();
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
            confetti.fire();
          });
          _userService.login(_emailController.text, _passwordController.text);
          Navigator.pushReplacementNamed(context, '/homepage');
        });
      } else {
        setState(() {
          error.fire();
          isShowLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox(
          height: screenHeight * 0.45,
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
                            "First Name",
                            style: TextStyle(color: ColorProvider.textDark),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: _firstNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "First name is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text(
                            "Last Name",
                            style: TextStyle(color: ColorProvider.textDark),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: _lastNameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Last name is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text(
                            "Email",
                            style: TextStyle(color: ColorProvider.textDark),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text(
                            "Password",
                            style: TextStyle(color: ColorProvider.textDark),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password is required";
                                }
                                return null;
                              },
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Confirm Password",
                            style: TextStyle(color: ColorProvider.textDark),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 16),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please confirm your password";
                                }
                                if (value != _passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
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
                    if (_formKey.currentState!.validate()) {
                      _register(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
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
                    color: ColorProvider.textLight,
                  ),
                  label: const Text(
                    "Register",
                    style: TextStyle(color: ColorProvider.textLight),
                  ),
                ),
              ),
              SignInButton(
                Buttons.Google,
                text: "Sign up with Google",
                onPressed: _googleSignup,
              )
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
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
