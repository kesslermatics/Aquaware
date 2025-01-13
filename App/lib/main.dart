import 'dart:ui';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/homepage/homepage.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'package:aquaware/services/color_provider.dart';

// in pubspec.yaml Version increment
// in build.gradle version code incremetn
// flutter build appbundle
// java -jar bundletool-all-1.15.6.jar build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=build/app/outputs/bundle/release/my_app.apks
// java -jar bundletool-all-1.15.6.jar install-apks --apks=build/app/outputs/bundle/release/my_app.apks

// keytool -genkeypair -alias my-release-key -keyalg RSA -keysize 2048 -validity 10000 -keystore my-release-key.jks
// keytool -list -v -keystore <pfad-zu-deinem-keystore>.jks -alias <dein-alias> -storepass< dein-keystore-passwort>
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Sprache laden
  final savedLocale = await _loadSavedLocale();

  runApp(MyApp(savedLocale: savedLocale));
}

Future<Locale> _loadSavedLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final savedLanguageCode = prefs.getString('language_code');

  if (savedLanguageCode != null) {
    return Locale(savedLanguageCode);
  } else {
    final deviceLocale = window.locale;
    if (['en', 'de'].contains(deviceLocale.languageCode)) {
      return Locale(deviceLocale.languageCode);
    }
    return const Locale('en'); // Fallback auf Englisch
  }
}

class MyApp extends StatefulWidget {
  final Locale savedLocale;

  const MyApp({super.key, required this.savedLocale});

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
    setState(() {
      _isAuthenticated = refreshErrorMessage == null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: widget.savedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Englisch
        Locale('de'), // Deutsch
      ],
      debugShowCheckedModeBanner: false,
      title: 'Aquaware',
      theme: ThemeData(
        fontFamily: 'Sora',
        colorScheme: ColorProvider.colorScheme,
        scaffoldBackgroundColor: ColorProvider.n8,
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorProvider.n6,
          foregroundColor: ColorProvider.n1,
          titleTextStyle: TextStyle(
            color: ColorProvider.n1,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: ColorProvider.n1),
          titleMedium: TextStyle(color: ColorProvider.n1),
          titleSmall: TextStyle(color: ColorProvider.n1),
          bodyLarge: TextStyle(color: ColorProvider.n2),
          bodyMedium: TextStyle(color: ColorProvider.n2),
          bodySmall: TextStyle(color: ColorProvider.n2),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorProvider.n1,
            backgroundColor: ColorProvider.n17,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ColorProvider.n17, // Textfarbe Button
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: ColorProvider.n5, // Rahmenfarbe
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: ColorProvider.n17, // Hintergrundfarbe FAB
          foregroundColor: ColorProvider.n1, // Textfarbe FAB
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: ColorProvider.n12, // Hintergrund Input
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: ColorProvider.n5),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? ColorProvider.n17
                : ColorProvider.n12,
          ),
          checkColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? ColorProvider.n1
                : ColorProvider.n12,
          ),
        ),
        cardTheme: const CardTheme(
          color: ColorProvider.n6,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _isAuthenticated
              ? const HomepageScreen()
              : const OnboardingScreen(),
      routes: {
        '/homepage': (context) => const HomepageScreen(),
        "/onboarding": (context) => const OnboardingScreen(),
      },
    );
  }
}
