import 'package:flutter/material.dart';

class TenantTokensScreen extends StatefulWidget {
  @override
  _TenantTokensState createState() => _TenantTokensState();
}

class _TenantTokensState extends State<TenantTokensScreen> {
  // Sample data for tokens and amounts
  final List<Map<String, dynamic>> tokenData = [
    {'token': '788**899', 'amount': 999},
    {'token': '788**899', 'amount': 999},
    {'token': '788**899', 'amount': 999},
    {'token': '788**899', 'amount': 999},
    {'token': '788**899', 'amount': 999},
    {'token': '788**899', 'amount': 999},
  ];

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
              backgroundColor: Colors.amber, // Avatar color
              child: Icon(Icons.person, color: Colors.white), // User icon
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
                      '👋', // waving hand emoji
                      style: TextStyle(fontSize: 18),
                    )
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
                    'KSH 999,999.999',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Add funds'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
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
                          // Details button action
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Terms & Conditions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
        ],
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
