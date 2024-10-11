import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Services/authService.dart';
import '../../../widgets/bottomNavigationBar.dart';
import '../../Login/loginScreen.dart';

class TenantAccountScreen extends StatefulWidget {
  @override
  _TenantAccountScreenState createState() => _TenantAccountScreenState();
}

class _TenantAccountScreenState extends State<TenantAccountScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _user; // Variable to hold user information
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _fetchUser(); // Fetch user info when the screen is initialized
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Handle navigation logic here if necessary
  }

  Future<void> _fetchUser() async {
    try {
      final response = await _authService.fetchUser(); // Fetch user data from AuthService

      // Log the response for debugging
      print('Response from fetchUser: $response');

      if (response['success']) {
        setState(() {
          _user = response['user']; // Access the user data
          _isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      // Handle error (e.g., show a message to the user)
      setState(() {
        _isLoading = false; // Stop loading
      });
      _showSnackbar('Error fetching user data: $e');
    }
  }

  void _logout(BuildContext context) async {
    await _authService.logout();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _handleLogout() {
    _logout(context);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isLoading ? 'Loading...' : (_user?['name'] ?? 'N/A'),
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _isLoading ? 'Loading...' : 'Tenant ID: ${_user?['id'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Account Details
              Text(
                'Account Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (_isLoading)
                CircularProgressIndicator()
              else ...[
                _buildDetailCard('Email', _user?['email'] ?? 'N/A'),
                _buildDetailCard('Phone Number', _user?['phone_number'] ?? 'N/A'),
                _buildDetailCard('Lease Start Date', _user?['lease_start_date'] ?? 'N/A'),
                _buildDetailCard('Lease End Date', _user?['lease_end_date'] ?? 'N/A'),
              ],
              SizedBox(height: 24),

              // Action Buttons
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Edit Account Logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text('Edit Account', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 24),

              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Logout button color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
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

  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
