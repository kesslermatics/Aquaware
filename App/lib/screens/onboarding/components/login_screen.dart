import 'package:aquaware/screens/onboarding/components/register_screen.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isRememberMeChecked = false.obs;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "191107134677-vo049j2kfoho5v5hjtfmiug3i2tafdtv.apps.googleusercontent.com",
  );

  final UserService userService = UserService();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late SharedPreferences prefs;

  @override
  void onInit() {
    super.onInit();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('saved_email');
    String? savedPassword = await secureStorage.read(key: 'saved_password');
    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
    }
  }

  Future<void> signIn(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    Get.snackbar("Signing In", "Please wait...",
        snackPosition: SnackPosition.BOTTOM);

    final errorMessage = await userService.login(
      emailController.text,
      passwordController.text,
    );

    if (errorMessage == null) {
      if (isRememberMeChecked.value) {
        await prefs.setString('saved_email', emailController.text);
        await secureStorage.write(
            key: 'saved_password', value: passwordController.text);
      }

      Get.snackbar("Success", "Signed in successfully!",
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamed('/homepage'); // Navigate to the homepage
    } else {
      Get.snackbar("Error", errorMessage, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> googleSignInMethod() async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar("Cancelled", "Google Sign-In was cancelled!",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      final errorMessage = await userService.googleLogin(idToken!);

      if (errorMessage == null) {
        Get.snackbar("Success", "Signed in with Google successfully!",
            snackPosition: SnackPosition.BOTTOM);
        Get.toNamed('/homepage'); // Navigate to the homepage
      } else {
        Get.snackbar("Error", errorMessage,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed: Please try again later!",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> showForgotPasswordDialog(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    final UserService userService = UserService();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Forgot Password'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter your email address to receive a reset code.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Send Code'),
              onPressed: () async {
                // Zeige eine Snackbar an, während der Code gesendet wird
                Get.snackbar(
                  'Please wait',
                  'Code is being sent...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );

                final errorMessage =
                    await userService.forgotPassword(emailController.text);

                if (errorMessage == null) {
                  Navigator.of(context).pop();
                  showResetPasswordDialog(context, emailController.text);
                } else {
                  Get.snackbar(
                    'Error',
                    'Failed to send code. Please check your email address and try again.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showResetPasswordDialog(
      BuildContext context, String email) async {
    final TextEditingController codeController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final UserService userService = UserService();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Reset Password'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the reset code sent to your email and set a new password.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: 'Reset Code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Reset Password'),
              onPressed: () async {
                if (codeController.text.isEmpty ||
                    newPasswordController.text.isEmpty) {
                  Get.snackbar(
                    'Error',
                    'Please provide both the reset code and a new password.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Zeige eine Snackbar an, während das Passwort zurückgesetzt wird
                Get.snackbar(
                  'Please wait',
                  'Resetting your password...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );

                final errorMessage = await userService.resetPassword(
                  email,
                  codeController.text,
                  newPasswordController.text,
                );

                if (errorMessage == null) {
                  // Automatisches Login nach Passwort-Reset
                  final loginErrorMessage = await userService.login(
                    email,
                    newPasswordController.text,
                  );

                  if (loginErrorMessage == null) {
                    Navigator.of(context).pop();
                    Get.snackbar(
                      'Success',
                      'Your password has been reset successfully!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    Get.offNamed('/homepage'); // Redirect to homepage
                  } else {
                    Get.snackbar(
                      'Login Failed',
                      'Your password was reset, but login failed. Please try again.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.snackbar(
                    'Error',
                    'Failed to reset password. Please check the reset code and try again.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Logo and Welcome Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Image(
                    image: AssetImage("assets/images/logo.png"),
                    height: 100,
                  ),
                  Text(
                    "Welcome,",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Explore and manage your water quality effortlessly",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Login Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      // Email Input
                      TextFormField(
                        controller: loginController.emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Password Input with Toggle Visibility
                      Obx(
                        () => TextFormField(
                          controller: loginController.passwordController,
                          obscureText: !loginController.isPasswordVisible.value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(loginController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                loginController.isPasswordVisible.value =
                                    !loginController.isPasswordVisible.value;
                              },
                            ),
                            labelText: "Password",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Remember Me and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Row(
                              children: [
                                Checkbox(
                                  value:
                                      loginController.isRememberMeChecked.value,
                                  onChanged: (value) {
                                    loginController.isRememberMeChecked.value =
                                        value!;
                                  },
                                ),
                                const Text("Remember Me"),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              loginController.showForgotPasswordDialog(context);
                            },
                            child: const Text("Forget Password"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            loginController.signIn(context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Sign In"),
                        ),
                      ),
                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => RegisterScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Create Account"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Divider
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text("Or"),
                  Flexible(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 5,
                      endIndent: 60,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Sign In with Google
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.Google,
                    onPressed: () {
                      loginController.googleSignInMethod();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
