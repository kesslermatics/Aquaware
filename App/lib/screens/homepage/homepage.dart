import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/models/aquarium.dart';
import 'package:aquaware/screens/dashboard/details_screen.dart';
import 'package:aquaware/screens/dashboard/dashboard_screen.dart';
import 'package:aquaware/screens/navigation/navigation_drawer.dart';
import 'package:aquaware/screens/profile/profile_screen.dart';
import 'package:aquaware/screens/settings/settings_screen.dart';
import 'package:aquaware/services/color_provider.dart';
import 'package:aquaware/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final UserService _userService = UserService();
  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;
  Aquarium? _selectedAquarium;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final profile = await _userService.getUserProfile();
      setState(() {
        _profile = profile;
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
      _selectedAquarium = null; // Reset the selected aquarium
    });
    Navigator.pop(context); // Close the drawer
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
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

  void _onAquariumTapped(Aquarium aquarium) {
    setState(() {
      _selectedAquarium = aquarium;
    });
  }

  void _navigateBack() {
    setState(() {
      _selectedAquarium = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      _profile != null
          ? DashboardScreen(
              profile: _profile!, onAquariumTapped: _onAquariumTapped)
          : Center(child: CircularProgressIndicator()),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    List<String> _titles = [
      'Dashboard',
      'Profile',
      'Settings',
    ];

    return Scaffold(
      drawer: MenuDrawer(_profile, _onItemTapped),
      appBar: AppBar(
        title: Text(_selectedAquarium != null
            ? _selectedAquarium!.name
            : _titles[_selectedIndex]),
        actions: [
          if (_selectedAquarium == null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _showLogoutConfirmationDialog(context),
            ),
          if (_selectedAquarium != null)
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _navigateBack,
            ),
        ],
      ),
      body: _selectedAquarium != null
          ? DetailsScreen(aquarium: _selectedAquarium!)
          : _pages[_selectedIndex],
    );
  }
}
