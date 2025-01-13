import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String paragraph;
  final bool showLanguageDropdown;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.paragraph,
    this.showLanguageDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            image: AssetImage(imagePath),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Text(
            paragraph,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (showLanguageDropdown) ...[
            const SizedBox(height: 20),
            const LanguageDropdown(),
          ],
        ],
      ),
    );
  }
}

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  Locale _currentLocale = const Locale('en'); // Default language

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('language_code') ?? 'en';
    setState(() {
      _currentLocale = Locale(savedLocale);
    });
    Get.updateLocale(_currentLocale);
  }

  Future<void> _saveLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    setState(() {
      _currentLocale = locale;
    });
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: _currentLocale,
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              Image.asset('assets/flags/us.png', width: 24),
              const SizedBox(width: 8),
              const Text("English"),
            ],
          ),
        ),
        DropdownMenuItem(
          value: const Locale('de'),
          child: Row(
            children: [
              Image.asset('assets/flags/germany.png', width: 24),
              const SizedBox(width: 8),
              const Text("Deutsch"),
            ],
          ),
        ),
      ],
      onChanged: (Locale? locale) {
        if (locale != null) {
          _saveLanguage(locale);
        }
      },
    );
  }
}
