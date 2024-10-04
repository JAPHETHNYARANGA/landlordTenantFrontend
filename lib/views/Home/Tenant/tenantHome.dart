import 'package:flutter/material.dart';
import '../../../widgets/MessageFloatingIcon.dart';
import '../../../widgets/bottomNavigationBar.dart';
import 'TenantReceipt.dart';
import 'TenantToken.dart';

class TenantHome extends StatefulWidget {
  @override
  _TenantHomeState createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color similar to the image
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange[200], // Placeholder avatar color
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome back, John Doe 👋',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'TOTAL BALANCE (KSH)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'KSH 999,999.999',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add funds action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Add funds'),
                  ),
                  SizedBox(height: 20),
                  // Payment statements section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment statements',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.error_outline, color: Colors.pink),
                        SizedBox(width: 8),
                        Text(
                          '- KSH. 50.00  18 Aug, 09:38 AM',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                      MaterialPageRoute(builder: (context) => TenantTicketScreen()),
                    );
                  }),
                  _buildGridItem(Icons.house, "Pay Rent"),
                  _buildGridItem(Icons.shopping_cart, "Buy Tokens", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TenantTokensScreen()),
                    );
                  }),
                  _buildGridItem(Icons.money, "Earn"),
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
        onPressed: () {
          // Implement the chat functionality for tenants here
        },
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, {VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap ?? () {
          // Default functionality or no-operation if not specified
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50, color: Colors.orangeAccent), // Adjust icon color
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
