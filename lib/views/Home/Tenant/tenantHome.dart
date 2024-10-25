import 'package:flutter/material.dart';
import 'package:landlord_tenant/utils/urlContants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Services/adminService.dart';
import '../../../widgets/MessageFloatingIcon.dart';
import '../../../widgets/bottomNavigationBar.dart';
import 'TenantReceipt.dart';
import 'TenantToken.dart';
import 'FinancialStatementsScreen.dart'; // Import the new screen

class TenantHome extends StatefulWidget {
  @override
  _TenantHomeState createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  int _selectedIndex = 0;
  String _userName = '';
  List<Admin> _admins = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _fetchAdmins();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
    });
  }

  Future<void> _fetchAdmins() async {
    setState(() {
      _isLoading = true;
    });

    final adminService = AdminService(base_url);
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '254${phoneNumber.substring(1)}';
    }
    return phoneNumber;
  }

  void _launchWhatsApp(String phoneNumber) async {
    final formattedNumber = formatPhoneNumber(phoneNumber);
    final message = Uri.encodeComponent("Hello, I need assistance.");
    final url = Uri.parse("https://wa.me/$formattedNumber?text=$message");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
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
                          Navigator.of(context).pop();
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

  void _showPaymentMethodModal() {
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
                'Choose Payment Method',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.green),
                title: Text('M-Pesa'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle M-Pesa payment
                },
              ),
              ListTile(
                leading: Icon(Icons.credit_card, color: Colors.blue),
                title: Text('Visa'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle Visa payment
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange[200],
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome back, $_userName 👋',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'TOTAL BALANCE (KSH)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Text(
                    'KSH 0.00',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showPaymentMethodModal();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Add funds'),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment statements',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FinancialStatementsScreen()),
                            );
                          },
                          child: Text(
                            'SEE ALL',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: Colors.pink),
                        SizedBox(width: 8),
                        Text(
                          '- KSH. 50.00  18 Aug, 09:38 AM',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  _buildGridItem(Icons.build, "Raise Ticket", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TenantTicketScreen()),
                    );
                  }),
                  _buildGridItem(Icons.house, "Pay Rent", onTap: () {
                    _showPaymentMethodModal();
                  }),
                  _buildGridItem(Icons.shopping_cart, "Buy Tokens", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TenantTokensScreen()),
                    );
                  }),
                  _buildGridItem(Icons.money, "Financial Statements", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FinancialStatementsScreen()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: ChatFloatingActionButton(
        onPressed: _showContactModal,
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, {VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap ?? () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50, color: Colors.orangeAccent),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center the text
            ),
          ],
        ),
      ),
    );
  }
}
