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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      Get.snackbar(
        AppLocalizations.of(context)!.errorTitle,
        AppLocalizations.of(context)!.emailPasswordEmpty,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      AppLocalizations.of(context)!.signingInTitle,
      AppLocalizations.of(context)!.signingInMessage,
      snackPosition: SnackPosition.BOTTOM,
    );

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

      Get.snackbar(
        AppLocalizations.of(context)!.successTitle,
        AppLocalizations.of(context)!.signInSuccessMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/homepage'); // Navigate to the homepage
    } else {
      Get.snackbar(
        AppLocalizations.of(context)!.errorTitle,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> googleSignInMethod(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar(
          AppLocalizations.of(context)!.cancelledTitle,
          AppLocalizations.of(context)!.googleSignInCancelledMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      final errorMessage = await userService.googleLogin(idToken!);

      if (errorMessage == null) {
        Get.snackbar(
          AppLocalizations.of(context)!.successTitle,
          AppLocalizations.of(context)!.googleSignInSuccessMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed('/homepage'); // Navigate to the homepage
      } else {
        Get.snackbar(
          AppLocalizations.of(context)!.errorTitle,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(context)!.errorTitle,
        AppLocalizations.of(context)!.googleSignInErrorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
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
          title: Text(AppLocalizations.of(context)!.forgotPasswordTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.forgotPasswordMessage,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.emailFieldLabel,
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
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.sendCode),
              onPressed: () async {
                Get.snackbar(
                  AppLocalizations.of(context)!.pleaseWaitTitle,
                  AppLocalizations.of(context)!.codeBeingSentMessage,
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
                    AppLocalizations.of(context)!.errorTitle,
                    AppLocalizations.of(context)!.forgotPasswordErrorMessage,
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
          title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.resetPasswordMessage,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.resetCodeFieldLabel,
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
                    labelText:
                        AppLocalizations.of(context)!.newPasswordFieldLabel,
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
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.resetPasswordButton),
              onPressed: () async {
                if (codeController.text.isEmpty ||
                    newPasswordController.text.isEmpty) {
                  Get.snackbar(
                    AppLocalizations.of(context)!.errorTitle,
                    AppLocalizations.of(context)!.resetPasswordEmptyFieldsError,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }

                Get.snackbar(
                  AppLocalizations.of(context)!.pleaseWaitTitle,
                  AppLocalizations.of(context)!.resettingPasswordMessage,
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
                  final loginErrorMessage = await userService.login(
                    email,
                    newPasswordController.text,
                  );

                  if (loginErrorMessage == null) {
                    Navigator.of(context).pop();
                    Get.snackbar(
                      AppLocalizations.of(context)!.successTitle,
                      AppLocalizations.of(context)!.resetPasswordSuccessMessage,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                    Get.offNamed('/homepage');
                  } else {
                    Get.snackbar(
                      AppLocalizations.of(context)!.loginFailedTitle,
                      AppLocalizations.of(context)!.loginFailedMessage,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  Get.snackbar(
                    AppLocalizations.of(context)!.errorTitle,
                    AppLocalizations.of(context)!.resetPasswordErrorMessage,
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
                    AppLocalizations.of(context)!.welcome,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.welcomeDescription,
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
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          labelText: AppLocalizations.of(context)!.email,
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
                            labelText: AppLocalizations.of(context)!.password,
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
                                Text(AppLocalizations.of(context)!.rememberMe),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                loginController
                                    .showForgotPasswordDialog(context);
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.forgotPassword),
                            ),
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
                          child: Text(AppLocalizations.of(context)!.signIn),
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
                          child:
                              Text(AppLocalizations.of(context)!.createAccount),
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
                    text: AppLocalizations.of(context)!.signInWithGoogle,
                    onPressed: () {
                      loginController.googleSignInMethod(context);
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
