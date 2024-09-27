import 'package:flutter/material.dart';
import 'package:landlord_tenant/views/Login/explore.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToExplore();
  }

  _navigateToExplore() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ExploreScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image or Color
          Container(
            color: Colors.white, // Use a white background
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Image
                Image.asset(
                  'assets/images/logo.jpeg', // Replace with your actual logo asset path
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),
                // Company Name
                Text(
                  'CITY REALTY',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange, // Customize the color
                  ),
                ),
                // Tagline
                Text(
                  'LIVE RIGHT',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Bottom City Skyline Image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/city_img.png', // Replace with your actual skyline asset path
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
