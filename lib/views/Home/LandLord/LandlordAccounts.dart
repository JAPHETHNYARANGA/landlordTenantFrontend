import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/authService.dart';
import '../../../widgets/bottomNavigationBar.dart';
import '../../Login/loginScreen.dart';

class LandlordAccountScreen extends StatefulWidget {
  @override
  _LandlordAccountScreenState createState() => _LandlordAccountScreenState();
}

class _LandlordAccountScreenState extends State<LandlordAccountScreen> {
  int _selectedIndex = 3; // Track the selected index for the bottom navigation
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData; // Variable to hold user data
  bool _isLoading = true; // Variable to show loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on initialization
  }

  Future<void> _fetchUserData() async {
    try {
      final data = await _authService.fetchUser();
      setState(() {
        _userData = data['user']; // Store user data
        _isLoading = false; // Stop loading
      });
    } catch (error) {
      // Handle error (e.g., show a snackbar)
      print('Error fetching user data: $error');
      setState(() {
        _isLoading = false; // Stop loading even on error
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation based on selected index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landlord Account'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Landlord Profile Section
            Text(
              'Profile Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildProfileTile('Name', _userData?['name'] ?? 'N/A'),
            _buildProfileTile('Email', _userData?['email'] ?? 'N/A'),
            _buildProfileTile('Phone Number', _userData?['phone_number'] ?? 'N/A'),
            _buildProfileTile('Address', _userData?['address'] ?? 'N/A'),
            SizedBox(height: 40),

            // Logout Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileTile(String title, String value) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await _authService.logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
