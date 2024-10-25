import 'package:flutter/material.dart';
import 'package:landlord_tenant/utils/urlContants.dart';
import 'package:landlord_tenant/widgets/bottomNavigationBar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Services/adminService.dart';
import '../../../Services/landlordService.dart';
import '../../../Services/tenantService.dart';
import '../../../sharedPreferences/adminSharedPreference.dart';
import 'adminEmergency.dart';
import 'adminLandlord.dart';
import 'adminMaintenance.dart';
import 'adminPayments.dart';
import 'adminProperties.dart';
import 'adminSuperAdmin.dart';
import 'adminTenant.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  String _userName = "User";
  String _userType = "";

  List<Tenant> _tenants = [];
  List<Landlord> _landlords = [];
  bool _isLoadingTenants = false;
  bool _isLoadingLandlords = false;

  // Service instances
  late TenantService _tenantService;
  late LandlordService _landlordService;

  @override
  void initState() {
    super.initState();
    _loadUserNameAndType();

    // Initialize services with your base URL
    _tenantService = TenantService(base_url); // Replace with your actual base URL
    _landlordService = LandlordService(base_url); // Replace with your actual base URL

    _fetchTenants();
    _fetchLandlords();
  }

  void _loadUserNameAndType() async {
    final userName = await SharedPreferencesManager.getString('userName');
    final userType = await SharedPreferencesManager.getString('userType');
    if (userName != null && userName.isNotEmpty) {
      setState(() {
        _userName = userName;
      });
    }
    if (userType != null && userType.isNotEmpty) {
      setState(() {
        _userType = userType;
      });
    }
  }

  Future<void> _fetchTenants() async {
    setState(() {
      _isLoadingTenants = true;
    });

    try {
      final tenants = await _tenantService.fetchTenants();
      setState(() {
        _tenants = tenants;
      });
    } catch (e) {
      print('Failed to fetch tenants: $e');
    } finally {
      setState(() {
        _isLoadingTenants = false;
      });
    }
  }

  Future<void> _fetchLandlords() async {
    setState(() {
      _isLoadingLandlords = true;
    });

    try {
      final landlords = await _landlordService.fetchLandlords();
      setState(() {
        _landlords = landlords;
      });
    } catch (e) {
      print('Failed to fetch landlords: $e');
    } finally {
      setState(() {
        _isLoadingLandlords = false;
      });
    }
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '254${phoneNumber.substring(1)}';
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Contact Tenants',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Reduced font size
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    _isLoadingTenants
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                      child: ListView.builder(
                        itemCount: _tenants.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                                backgroundColor: Colors.orangeAccent,
                              ),
                              title: Text(
                                _tenants[index].name,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), // Reduced font size
                              ),
                              subtitle: Text(
                                _tenants[index].phoneNumber,
                                style: TextStyle(fontSize: 10), // Reduced font size
                              ),
                              trailing: Icon(Icons.chat, color: Colors.green),
                              onTap: () {
                                _launchWhatsApp(_tenants[index].phoneNumber);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Contact Landlords',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), // Reduced font size
                    ),
                    const SizedBox(height: 10),
                    Divider(),
                    _isLoadingLandlords
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                      child: ListView.builder(
                        itemCount: _landlords.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.person),
                                backgroundColor: Colors.orangeAccent,
                              ),
                              title: Text(
                                _landlords[index].name,
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold), // Reduced font size
                              ),
                              subtitle: Text(
                                _landlords[index].phoneNumber,
                                style: TextStyle(fontSize: 10), // Reduced font size
                              ),
                              trailing: Icon(Icons.chat, color: Colors.green),
                              onTap: () {
                                _launchWhatsApp(_landlords[index].phoneNumber);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
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
                    value: 'Admin',
                    items: <String>['Admin'].map((String value) {
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
                    buildCard("TENANTS", Icons.group, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminTenantScreen()),
                      );
                    }),
                    buildCard("LANDLORDS", Icons.person, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminLandlordScreen()),
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
                    if (_userType == 'superAdmin')
                      buildCard("ADMINS", Icons.admin_panel_settings, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminSuperAdminScreen()),
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
          _showContactModal();
        },
        backgroundColor: Colors.orangeAccent,
        child: const Icon(Icons.chat),
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
