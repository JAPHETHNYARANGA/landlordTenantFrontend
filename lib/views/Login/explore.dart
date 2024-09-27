import 'package:flutter/material.dart';
import 'loginScreen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
  }

  navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/skyscrapper_image.jpg'), // Ensure your image path is correct
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                // Logo or title
                Image.asset(
                  'assets/images/plain_logo.png', // Replace with your actual logo image path
                  width: 160, // Set your desired width
                  height: 160, // Set your desired height
                ),
                Spacer(),
                // Explore Properties Button
                ElevatedButton(
                  onPressed: () {
                    print('Explore Properties button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.3), // Make button color semi-transparent
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                  ),
                  child: Text(
                    'Explore Properties',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
                SizedBox(height: 10),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    navigateToLogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.3), // Make button color semi-transparent
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
