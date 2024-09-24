import 'package:aquaware/constants.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isShowLoading = false;
  bool isShowConfetti = false;
  bool _isPasswordVisible = false;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late SharedPreferences _prefs;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;

  final UserService _userService = UserService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "191107134677-01dnm67luaua0bpalbkia3jucktqggoi.apps.googleusercontent.com");

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    _prefs = await SharedPreferences.getInstance();
    String? savedEmail = _prefs.getString('saved_email');
    String? savedPassword = await _secureStorage.read(key: 'saved_password');
    if (savedEmail != null && savedPassword != null) {
      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;
    }
  }

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  Future<void> _signIn(BuildContext context) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    final errorMessage = await _userService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (errorMessage == null) {
      await _prefs.setString('saved_email', _emailController.text);
      await _secureStorage.write(
          key: 'saved_password', value: _passwordController.text);

      setState(() {
        check.fire();
        confetti.fire();
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isShowConfetti = false;
        });

        Navigator.pushReplacementNamed(context, '/homepage');
      });
    } else {
      setState(() {
        error.fire();
        isShowConfetti = false;
        isShowLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _googleSignInMethod() async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // Der Nutzer hat den Login abgebrochen
      }

      final googleAuth = await googleUser.authentication;
      final googleToken = googleAuth.idToken;

      final errorMessage = await _userService.googleLogin(googleToken!);

      if (errorMessage == null) {
        setState(() {
          check.fire();
          confetti.fire();
        });

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowConfetti = false;
          });

          Navigator.pushReplacementNamed(context, '/homepage');
        });
      } else {
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

  Future<void> _showForgotPasswordDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter your email address to reset your password.'),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Resend Password'),
              onPressed: () async {
                final errorMessage =
                    await _userService.forgotPassword(emailController.text);
                Navigator.of(context).pop();
                if (errorMessage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(color: ColorProvider.textDark),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
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
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
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
                        TextButton(
                          onPressed: () {
                            _showForgotPasswordDialog(context);
                          },
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: ColorProvider.primary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signIn(context);
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
                              "Sign In",
                              style: TextStyle(color: ColorProvider.textLight),
                            ),
                          ),
                        ),
                        Center(
                          child: SignInButton(
                            Buttons.Google,
                            onPressed: _googleSignInMethod,
                          ),
                        ),
                      ],
                    ),
                  ),
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
