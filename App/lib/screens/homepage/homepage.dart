import 'package:aquaware/models/environment.dart';
import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/screens/about/about_screen.dart';
import 'package:aquaware/screens/dashboard/details_screen.dart';
import 'package:aquaware/screens/dashboard/dashboard_screen.dart';
import 'package:aquaware/screens/disease_detection/disease_detection_screen.dart';
import 'package:aquaware/screens/feedback/feedback_screen.dart';
import 'package:aquaware/screens/animal_detection/animal_detection_screen.dart';
import 'package:aquaware/screens/navigation/navigation_drawer.dart';
import 'package:aquaware/screens/privacy/privacy_screen.dart';
import 'package:aquaware/screens/profile/profile_screen.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  String? _error;
  bool _isLoading = true;
  Environment? _selectedEnvironment;
  int _selectedIndex = 0;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      await _userService.getUserProfile();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedEnvironment = null; // Reset the selected aquarium
    });
    Navigator.pop(context); // Close the drawer
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          title: Row(
            children: [
              const Icon(Icons.logout, color: ColorProvider.n1),
              const SizedBox(width: 8),
              Expanded(child: Text(loc.logoutConfirmTitle)),
            ],
          ),
          content: Text(
            loc.logoutConfirmMessage,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Red for "No"
              ),
              child: Text(loc.no),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: Text(loc.yes),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Call the logout function
              },
            ),
          ],
        );
      },
    );
  }

  void _onEnvironmentTapped(Environment environment) {
    setState(() {
      _selectedEnvironment = environment;
    });
  }

  void _navigateBack() {
    setState(() {
      _selectedEnvironment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    List<Widget> pages = !_isLoading
        ? [
            DashboardScreen(onEnvironmentTapped: _onEnvironmentTapped),
            const AnimalDetectionScreen(),
            const DiseaseDetectionScreen(),
            const ProfileScreen(),
            const PrivacyScreen(),
            const FeedbackScreen(),
            const AboutScreen(),
          ]
        : [
            const Center(
              child: CircularProgressIndicator(),
            ),
          ];

    List<String> titles = [
      loc.dashboardTitle,
      loc.animalDetectionTitle,
      loc.diseaseDetectionTitle,
      loc.profileTitle,
      loc.privacyTitle,
      loc.feedbackTitle,
      loc.aboutTitle,
    ];

    return Scaffold(
      drawer: MenuDrawer(_onItemTapped),
      appBar: AppBar(
        title: Text(_selectedEnvironment != null
            ? _selectedEnvironment!.name
            : titles[_selectedIndex]),
        actions: [
          if (_selectedEnvironment == null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutConfirmationDialog(context),
            ),
          if (_selectedEnvironment != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _navigateBack,
            ),
        ],
      ),
      body: _selectedEnvironment != null
          ? DetailsScreen(aquarium: _selectedEnvironment!)
          : pages[_selectedIndex],
    );
  }
}
