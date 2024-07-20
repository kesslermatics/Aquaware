import 'package:aquaware/models/user_profile.dart';
import 'package:aquaware/screens/dashboard/dashboard_screen.dart';
import 'package:aquaware/screens/navigation/navigation_drawer.dart';
import 'package:aquaware/screens/profile/profile_screen.dart';
import 'package:aquaware/screens/settings/settings_screen.dart';
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
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      _buildHomePage(),
      const DashboardScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      drawer: MenuDrawer(_profile, _onItemTapped),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildHomePage() {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : _error != null
              ? Text('Error: $_error')
              : _profile != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Welcome, ${_profile!.firstName} ${_profile!.lastName}!'),
                        Text('Email: ${_profile!.email}'),
                        // Weitere Profilinformationen hier anzeigen
                      ],
                    )
                  : Text('No profile data available'),
    );
  }
}
