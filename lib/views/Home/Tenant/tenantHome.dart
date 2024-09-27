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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('TOTAL BALANCE (KSH) KSH 999,999.999', style: TextStyle(fontSize: 20)),
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
      child: InkWell(
        onTap: onTap ?? () {
          // Default functionality or no-operation if not specified
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50),
            Text(label),
          ],
        ),
      ),
    );
  }
}
