import 'package:flutter/material.dart';
import 'package:landlord_tenant/views/Login/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Services/authService.dart';
import '../../../widgets/bottomNavigationBar.dart';

class AdminAccountScreen extends StatefulWidget {
  @override
  _AdminAccountScreenState createState() => _AdminAccountScreenState();
}

class _AdminAccountScreenState extends State<AdminAccountScreen> {
  int _selectedIndex = 3; // Track the selected index for the bottom navigation
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _user; // Variable to hold user information
  bool _isLoading = true; // Track loading state
  bool _isLoggingOut = false; // Track logging out state

  @override
  void initState() {
    super.initState();
    _fetchUser(); // Fetch user info when the screen is initialized
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _fetchUser() async {
    try {
      final userInfo = await _authService.fetchUser();
      print('Fetched user info: $userInfo'); // Log the fetched user info
      setState(() {
        _user = userInfo['user']; // Store user data
        _isLoading = false; // Stop loading
      });
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false; // Stop loading even on error
      });
    }
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
              Text(
                'Profile Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  : _user != null
                  ? Column(
                children: [
                  _buildProfileTile('Name', _user!['name'] ?? 'N/A'),
                  _buildProfileTile('Email', _user!['email'] ?? 'N/A'),
                  // _buildProfileTile('Phone Number', _user!['phone_number'] ?? 'N/A'),
                  // _buildProfileTile('Address', _user!['address'] ?? 'N/A'),
                  // _buildProfileTile('Role', _user!['user_type'] ?? 'N/A'),
                ],
              )
                  : Text('No user data available'), // Message when no data

              SizedBox(height: 40),

              Center(
                child: ElevatedButton(
                  onPressed: _isLoggingOut ? null : () async {
                    await _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: _isLoggingOut
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
    setState(() {
      _isLoggingOut = true; // Start loading
    });

    try {
      await _authService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout successful!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    } finally {
      setState(() {
        _isLoggingOut = false; // Stop loading
      });
    }
  }
}
