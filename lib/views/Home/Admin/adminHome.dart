import 'package:flutter/material.dart';
import 'package:landlord_tenant/views/Home/Admin/adminEmergency.dart';
import 'package:landlord_tenant/views/Home/Admin/adminMaintenance.dart';
import 'package:landlord_tenant/views/Home/Admin/adminPayments.dart';
import 'package:landlord_tenant/views/Home/Admin/adminProperties.dart';
import 'package:landlord_tenant/views/Home/Admin/adminSuperAdmin.dart';
import 'package:landlord_tenant/views/Home/Admin/adminTenant.dart';
import '../../../sharedPreferences/adminSharedPreference.dart';
import '../../../widgets/MessageFloatingIcon.dart';
import '../../../widgets/bottomNavigationBar.dart';
import 'adminLandlord.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  String _userName = "User";
  String _userType = ""; // Store user type

  @override
  void initState() {
    super.initState();
    _loadUserNameAndType();
  }

  void _loadUserNameAndType() async {
    final userName = SharedPreferencesManager.getString('userName');
    final userType = SharedPreferencesManager.getString('userType'); // Load user type
    if (userName != null && userName.isNotEmpty) {
      setState(() {
        _userName = userName;
      });
    }
    if (userType != null && userType.isNotEmpty) {
      setState(() {
        _userType = userType; // Update user type state
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _startLiveChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChatModal(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
    );
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
              // Top header with logo and dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/plain_logo.png',
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Column(
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
                    value: 'Admin',
                    items: <String>['Admin', 'User'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Welcome back, $_userName",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  children: [
                    buildCard("LANDLORDS", Icons.person, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminLandlordScreen()),
                      );
                    }),
                    buildCard("TENANTS", Icons.group, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminTenantScreen()),
                      );
                    }),
                    buildCard("PROPERTIES", Icons.home, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminPropertiesScreen()),
                      );
                    }),
                    buildCard("PAYMENTS", Icons.payment, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminPaymentsScreen()),
                      );
                    }),
                    buildCard("MAINTENANCE", Icons.build, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminMaintenanceScreen()),
                      );
                    }),
                    buildCard("EMERGENCY CONTACTS", Icons.phone, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminEmergencyScreen()),
                      );
                    }),
                    // Conditionally show the add admins card
                    if (_userType == 'superAdmin')
                      buildCard("ADMINS", Icons.admin_panel_settings, () {
                        // Action to navigate to add admins screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminSuperAdminScreen()), // Replace with your actual add admin screen
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
      floatingActionButton: ChatFloatingActionButton(
        onPressed: _startLiveChat,
      ),
    );
  }

  Widget buildCard(String title, IconData icon, VoidCallback onTap) {
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
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ChatModal widget remains the same
class ChatModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3, // Initial height as a percentage of the screen
      minChildSize: 0.3, // Minimum height
      maxChildSize: 0.8, // Maximum height
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Live Chat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            "Chat content goes here",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Handle send message action
                        },
                        child: Text("Send"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Match the theme color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
