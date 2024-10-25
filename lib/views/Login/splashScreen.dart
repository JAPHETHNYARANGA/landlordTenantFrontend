import 'package:flutter/material.dart';
import 'package:landlord_tenant/sharedPreferences/adminSharedPreference.dart';
import 'package:landlord_tenant/views/Home/Admin/adminHome.dart';
import 'package:landlord_tenant/views/Home/Admin/adminLandlord.dart';
import 'package:landlord_tenant/views/Home/Admin/adminTenant.dart';
import 'package:landlord_tenant/views/Home/LandLord/landlordHome.dart';
import 'package:landlord_tenant/views/Home/Tenant/tenantHome.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Delay for 3 seconds
    await Future.delayed(Duration(seconds: 3));

    // Check if the widget is still mounted
    if (!mounted) return;

    // Get stored user type and token
    String? token;
    String? userType;

    try {
      token = await SharedPreferencesManager.getString('token');
      userType = await SharedPreferencesManager.getString('userType');
    } catch (e) {
      print("Error retrieving shared preferences: $e");
    }

    print("Token: $token");
    print("User Type: $userType");

    // Navigate based on the user type
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      // Navigate based on userType
      if (userType == 'admin' || userType == 'superAdmin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHomeScreen()),
        );
      } else if (userType == 'tenant') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TenantHome()),
        );
      } else if (userType == 'landlord') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandlordHome()),
        );
      } else {
        // Default to login if userType is unrecognized
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image or Color
          Container(
            color: Colors.white,
          ),
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Image
                Image.asset(
                  'assets/images/logo.jpeg',
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
                    color: Colors.orange,
                  ),
                ),
                // Tagline
                Text(
                  'MODISH LIVING KE',
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
              'assets/images/city_img.png',
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
