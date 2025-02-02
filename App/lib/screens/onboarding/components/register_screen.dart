import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isRepeatPasswordVisible = false.obs;
  final isTermsAccepted = false.obs;

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "191107134677-732oj9b8vkpgctrac6bnvs814rscjdt8.apps.googleusercontent.com",
  );

  final UserService userService = UserService();

  Future<void> register(BuildContext context) async {
    if (!isTermsAccepted.value) {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.acceptTerms,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (passwordController.text != repeatPasswordController.text) {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.passwordsDoNotMatch,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final errorMessage = await userService.signup(
      emailController.text,
      passwordController.text,
      repeatPasswordController.text,
      firstNameController.text,
      lastNameController.text,
    );

    if (errorMessage == null) {
      Get.snackbar(
        AppLocalizations.of(context)!.success,
        AppLocalizations.of(context)!.accountCreated,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/homepage'); // Navigate to homepage
    } else {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> googleSignup(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Get.snackbar(
          AppLocalizations.of(context)!.cancelled,
          AppLocalizations.of(context)!.googleSignUpCancelled,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      final errorMessage = await userService.googleSignup(idToken!);

      if (errorMessage == null) {
        Get.snackbar(
          AppLocalizations.of(context)!.success,
          AppLocalizations.of(context)!.googleSignUpSuccess,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed('/homepage'); // Navigate to homepage
      } else {
        Get.snackbar(
          AppLocalizations.of(context)!.error,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.googleSignUpFailed(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _launchUrl(Uri url, BuildContext context) async {
    if (!await launchUrl(url)) {
      Get.snackbar(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.urlLaunchFailed(url.toString()),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorProvider.n14,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.createAccountTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              // Form
              Form(
                child: Column(
                  children: [
                    // First and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: registerController.firstNameController,
                            decoration: InputDecoration(
                              labelText:
                                  AppLocalizations.of(context)!.firstName,
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: registerController.lastNameController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.lastName,
                              prefixIcon: const Icon(Icons.person),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Email
                    TextFormField(
                      controller: registerController.emailController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email,
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password
                    Obx(
                      () => TextFormField(
                        controller: registerController.passwordController,
                        obscureText:
                            !registerController.isPasswordVisible.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                                registerController.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                            onPressed: () {
                              registerController.isPasswordVisible.value =
                                  !registerController.isPasswordVisible.value;
                            },
                          ),
                          labelText: AppLocalizations.of(context)!.password,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Repeat Password
                    Obx(
                      () => TextFormField(
                        controller: registerController.repeatPasswordController,
                        obscureText:
                            !registerController.isRepeatPasswordVisible.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                                registerController.isRepeatPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                            onPressed: () {
                              registerController.isRepeatPasswordVisible.value =
                                  !registerController
                                      .isRepeatPasswordVisible.value;
                            },
                          ),
                          labelText:
                              AppLocalizations.of(context)!.repeatPassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Terms and Conditions Checkbox
                    Obx(
                      () => Row(
                        children: [
                          Checkbox(
                            value: registerController.isTermsAccepted.value,
                            onChanged: (value) {
                              registerController.isTermsAccepted.value = value!;
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                registerController._launchUrl(
                                    Uri.parse(
                                        "https://aquaware.cloud/terms-and-conditions/"),
                                    context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.agreeTerms,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          registerController.register(context);
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
              const SizedBox(height: 10),
              /*
              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      indent: 60,
                      endIndent: 5,
                    ),
                  ),
                  Text(AppLocalizations.of(context)!.or),
                  const Flexible(
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

              // Google Sign-Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButton(
                    Buttons.Google,
                    text: AppLocalizations.of(context)!.signUpWithGoogle,
                    onPressed: () {
                      registerController.googleSignup(context);
                    },
                  ),
                ],
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
