import 'package:flutter/material.dart';
import 'package:landlord_tenant/widgets/bottomNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Services/adminService.dart';
import '../../../sharedPreferences/adminSharedPreference.dart';
import '../../../utils/urlContants.dart';
import 'landlordEmergency.dart';
import 'landlordMaintenance.dart';
import 'landlordPayments.dart';
import 'landlordProperties.dart';
import 'landlordTenant.dart';

class LandlordHome extends StatefulWidget {
  const LandlordHome({Key? key}) : super(key: key);

  @override
  _LandlordHomeState createState() => _LandlordHomeState();
}

class _LandlordHomeState extends State<LandlordHome> {
  int _selectedIndex = 0;
  String _userName = "Landlord";
  List<Admin> _admins = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAdmins(); // Fetch admin data when the widget initializes
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    // Fetch landlord name from SharedPreferences
    String? name = await SharedPreferencesManager.getString('userName');
    setState(() {
      _userName = name ?? "Landlord"; // Use default if name is null
    });
  }

  Future<void> _fetchAdmins() async {
    setState(() {
      _isLoading = true;
    });

    final adminService = AdminService(base_url); // Replace with your actual base URL
    try {
      final admins = await adminService.fetchAdmins();
      setState(() {
        _admins = admins;
      });
    } catch (e) {
      print('Failed to fetch admins: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '254${phoneNumber.substring(1)}'; // Change '0' to '254'
    }
    return phoneNumber;
  }

  void _launchWhatsApp(String phoneNumber) async {
    final formattedNumber = formatPhoneNumber(phoneNumber);
    final message = Uri.encodeComponent("Hello, this is $_userName, an admin from City Realty, here to assist you.");
    final url = Uri.parse("https://wa.me/$formattedNumber?text=$message");

    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showContactModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contact Admins',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Divider(),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Expanded(
                child: ListView.builder(
                  itemCount: _admins.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.person),
                          backgroundColor: Colors.orangeAccent,
                        ),
                        title: Text(
                          _admins[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(_admins[index].phoneNumber),
                        trailing: Icon(Icons.chat, color: Colors.green),
                        onTap: () {
                          _launchWhatsApp(_admins[index].phoneNumber);
                          Navigator.of(context).pop(); // Close the modal
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                            "MODISH LIVING KE",
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
        onPressed: _showContactModal, // Show contact modal on button press
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
