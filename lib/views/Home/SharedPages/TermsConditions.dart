import 'package:flutter/material.dart';
import 'package:landlord_tenant/widgets/bottomNavigationBar.dart';

class TermsConditionsPage extends StatefulWidget {
  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  int _selectedIndex = 0; // Initialize the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms And Conditions', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Introduction\n'
                    'Welcome to our application. By using this app, you agree to these terms and conditions.\n\n'
                    '2. User Responsibilities\n'
                    'You are responsible for maintaining the confidentiality of your account information.\n\n'
                    '3. Limitation of Liability\n'
                    'Our company shall not be liable for any damages resulting from the use of this application.\n\n'
                    '4. Changes to Terms\n'
                    'We may modify these terms at any time. Please review them periodically.\n\n'
                    '5. Governing Law\n'
                    'These terms are governed by the laws of the jurisdiction in which our company is located.\n',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'For further information, please contact our support team.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
