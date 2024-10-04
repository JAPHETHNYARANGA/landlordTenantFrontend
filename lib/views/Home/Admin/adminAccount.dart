import 'package:flutter/material.dart';
import 'package:landlord_tenant/views/Login/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Services/authService.dart';
import '../../../widgets/bottomNavigationBar.dart'; // Import your custom bottom navigation bar

class AdminAccountScreen extends StatefulWidget {
  @override
  _AdminAccountScreenState createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  int _selectedIndex = 0; // Track the selected index for the bottom navigation
  final AuthService _authService = AuthService();

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
        title: Text('Admin Account'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Profile Section
              Text(
                'Profile Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildProfileTile('Name', 'Admin Name'), // Replace with actual name
              _buildProfileTile('Email', 'admin@example.com'), // Replace with actual email
              _buildProfileTile('Role', 'Administrator'),

              SizedBox(height: 40),

              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Logout button color
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar( // Add the bottom navigation bar here
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
    // Clear the shared preferences
    await _authService.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
