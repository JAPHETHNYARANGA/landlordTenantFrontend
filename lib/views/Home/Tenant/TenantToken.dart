import 'package:flutter/material.dart';
import '../../../widgets/bottomNavigationBar.dart';

class TenantTokensScreen extends StatefulWidget {
  @override
  _TenantTokensState createState() => _TenantTokensState();
}

class _TenantTokensState extends State<TenantTokensScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Sample data for tokens and amounts
  final List<Map<String, dynamic>> tokenData = [
    {'token': '788**899', 'amount': 999, 'details': 'Token details for 788**899'},
    {'token': '788**900', 'amount': 1200, 'details': 'Token details for 788**900'},
    {'token': '788**901', 'amount': 800, 'details': 'Token details for 788**901'},
    // Add more tokens if needed
  ];

  // Method to show the payment options modal
  void _showPaymentOptions(BuildContext context, String action) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                action == 'addFunds' ? 'Add Funds' : 'Buy Tokens',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('MPesa'),
                onTap: () {
                  // Handle MPesa payment
                  Navigator.pop(context); // Close modal
                },
              ),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Visa'),
                onTap: () {
                  // Handle Visa payment
                  Navigator.pop(context); // Close modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to show the token details modal
  void _showTokenDetails(BuildContext context, Map<String, dynamic> token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Token Details'),
          content: Text('Token Number: ${token['token']}\nAmount: Ksh.${token['amount']}\nDetails: ${token['details']}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '👋',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.qr_code, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'TOTAL BALANCE (KSH)',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'KSH 0',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _showPaymentOptions(context, 'addFunds'),
                    child: Text('Add funds'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _showPaymentOptions(context, 'buyTokens'),
                    child: Text('Buy Tokens'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 60),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: tokenData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.confirmation_number, color: Colors.amber),
                      title: Text('Token Number: ${tokenData[index]['token']}'),
                      subtitle: Text('Amount: Ksh.${tokenData[index]['amount']}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _showTokenDetails(context, tokenData[index]); // Show token details
                        },
                        child: Text('Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
