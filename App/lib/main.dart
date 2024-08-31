import 'package:aquaware/constants.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'screens/homepage/homepage.dart';
import 'screens/onboarding/onboding_screen.dart';

// in pubspec.yaml Version increment
// in build.gradle version code incremetn
// flutter build appbundle
// java -jar bundletool-all-1.15.6.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/app/outputs/bundle/release/my_app.apks
// java -jar bundletool-all-1.15.6.jar install-apks --apks=build/app/outputs/bundle/release/my_app.apks

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _isAuthenticated = false;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final refreshErrorMessage = await _userService.refreshAccessToken();
    if (refreshErrorMessage == null) {
      setState(() {
        _isAuthenticated = true;
      });
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aquaware',
      theme: ThemeData(
        colorScheme: ColorProvider.colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor:
              ColorProvider.primaryDark, // Hintergrundfarbe der AppBar
          foregroundColor: ColorProvider.textLight, // Textfarbe der AppBar
          iconTheme: IconThemeData(
              color: ColorProvider.textLight), // Icon-Farbe der AppBar
          actionsIconTheme: IconThemeData(
              color: ColorProvider.textLight), // Aktions-Icon-Farbe der AppBar
          titleTextStyle: TextStyle(
            color: ColorProvider.textLight, // Textfarbe des Titels
            fontSize: 20, // Schriftgröße des Titels
            fontWeight: FontWeight.bold, // Schriftstil des Titels
          ),
        ),
        scaffoldBackgroundColor: ColorProvider.background,
        textTheme: TextTheme(
          displayLarge: TextStyle(color: ColorProvider.textDark),
          displayMedium: TextStyle(color: ColorProvider.textDark),
          displaySmall: TextStyle(color: ColorProvider.textDark),
          headlineLarge: TextStyle(color: ColorProvider.textDark),
          headlineMedium: TextStyle(color: ColorProvider.textDark),
          headlineSmall: TextStyle(color: ColorProvider.textDark),
          titleLarge: TextStyle(color: ColorProvider.textDark),
          titleMedium: TextStyle(color: ColorProvider.textDark),
          titleSmall: TextStyle(color: ColorProvider.textDark),
          bodyLarge: TextStyle(color: ColorProvider.textDark),
          bodyMedium: TextStyle(color: ColorProvider.textDark),
          bodySmall: TextStyle(color: ColorProvider.textDark),
          labelLarge: TextStyle(color: ColorProvider.textDark),
          labelMedium: TextStyle(color: ColorProvider.textDark),
          labelSmall: TextStyle(color: ColorProvider.textDark),
        ),
      ),
      home: _isLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _isAuthenticated
              ? HomepageScreen()
              : const OnboardingScreen(),
      routes: {
        '/homepage': (context) => HomepageScreen(),
        "/onboarding": (context) => OnboardingScreen(),
      },
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
