import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandlordAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Landlord Account'),
        centerTitle: true,
        backgroundColor: Colors.green, // Change color as needed
      ),
      body: Padding(
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
            _buildProfileTile('Name', 'Landlord Name'), // Replace with actual name
            _buildProfileTile('Email', 'landlord@example.com'), // Replace with actual email
            _buildProfileTile('Property Count', '5'), // Replace with actual property count
            SizedBox(height: 40),

            // Actions Section
            Text(
              'Actions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildActionButton(context, 'View Properties', () {
              // Navigate to View Properties page
            }),
            _buildActionButton(context, 'Manage Tenants', () {
              // Navigate to Manage Tenants page
            }),
            _buildActionButton(context, 'Add New Property', () {
              // Navigate to Add Property page
            }),
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
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildActionButton(BuildContext context, String title, VoidCallback onPressed) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward),
        onTap: onPressed,
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Clear the shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to Login Screen (adjust this based on your routing)
    Navigator.pushReplacementNamed(context, '/login');
  }
}
