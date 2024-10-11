import 'package:flutter/material.dart';

import '../../../widgets/bottomNavigationBar.dart';
import 'landlordEmergency.dart';
import 'landlordMaintenance.dart';
import 'landlordPayments.dart';
import 'landlordProperties.dart';
import 'landlordTenant.dart';
// import 'adminEmergency.dart';
// import 'adminMaintenance.dart';
// import 'adminPayments.dart';
// import 'adminProperties.dart';
// import 'adminTenant.dart';

class LandlordHome extends StatefulWidget {
  const LandlordHome({Key? key}) : super(key: key);

  @override
  _LandlordHomeState createState() => _LandlordHomeState();
}

class _LandlordHomeState extends State<LandlordHome> {
  int _selectedIndex = 0;
  String _userName = "Landlord";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top logo and dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/plain_logo.png',
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CITY REALTY",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            "LIVE RIGHT",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: 'Landlord',
                    items: <String>['Landlord'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome back, $_userName",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    _buildCard("TENANTS", Icons.group, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandlordTenantScreen()),
                      );
                    }),
                    _buildCard("PAYMENTS", Icons.payment, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandlordPaymentScreen()),
                      );
                    }),
                    _buildCard("PROPERTIES", Icons.home, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandlordPropertiesScreen()),
                      );
                    }),
                    _buildCard("MAINTENANCE", Icons.build, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandlordMaintenanceScreen()),
                      );
                    }),
                    _buildCard("EMERGENCY CONTACTS", Icons.phone, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandlordEmergencyScreen()),
                      );
                    }),
                  ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement live chat functionality
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.chat),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.orange[100],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.orange,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
