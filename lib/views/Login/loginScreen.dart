import 'package:flutter/material.dart';
import 'package:landlord_tenant/views/Home/Admin/adminHome.dart';
import 'package:landlord_tenant/views/Home/Admin/adminLandlord.dart';
import 'package:landlord_tenant/views/Home/Admin/adminTenant.dart';
import 'package:landlord_tenant/views/Home/Tenant/tenantHome.dart';
import '../../Services/authService.dart';
import '../../sharedPreferences/adminSharedPreference.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false; // Loading state

  void _login() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final authService = AuthService();

    try {
      final response = await authService.login(email, password);
      print('Login Response: $response');

      if (response['success']) {
        final token = response['token'];
        final userName = response['user']['name'];
        final userType = response['user']['user_type'];

        // Store token and user name
        await SharedPreferencesManager.setString('token', token);
        await SharedPreferencesManager.setString('userName', userName);
        await SharedPreferencesManager.setString('userType', userType);

        if(userType == 'admin'){
          // Navigate to the AdminHomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()),
          );
        }else if(userType == 'superAdmin'){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()),
          );
        } else if(userType == 'tenant'){
          Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => TenantHome()),);
        }else if(userType == 'landlord'){
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AdminLandlordScreen(),));
        }
      } else {
        _showSnackbar('Login failed');
      }
    } catch (e) {
      print('Login Error: $e');
      _showSnackbar('An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Back Text
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    // Subtitle
                    Text(
                      'Log in to continue your journey.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    // Email Input Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        filled: true,
                        fillColor: Colors.orange[50], // Light orange color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    // Password Input Field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        filled: true,
                        fillColor: Colors.orange[50], // Light orange color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 30),
                    // Login Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login, // Disable button when loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Remember me & Forgot Password Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            Text('Remember me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/images/city_img.png', // Replace with your actual skyline asset path
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Full-Screen Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black54, // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
