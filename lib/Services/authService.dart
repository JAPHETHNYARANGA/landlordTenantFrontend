import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:landlord_tenant/sharedPreferences/adminSharedPreference.dart';

import '../utils/urlContants.dart';

class AuthService {
  static const String _baseUrl = base_url; // Replace with your API base URL

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<void> logout() async {
    // Get the token from shared preferences
    String? token = SharedPreferencesManager.getString('token');

    if (token == null) {
      print("no user logged in");
      throw Exception('No user is logged in.');

    }

    final response = await http.post(
      Uri.parse('$_baseUrl/logout'), // Adjust the logout URL as necessary
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include the token for authentication
      },
    );

    if (response.statusCode == 200) {
      // Clear the stored token and user type on successful logout
      await SharedPreferencesManager.setString('token', '');
      await SharedPreferencesManager.setString('userType', '');
    } else {
      throw Exception('Failed to log out');
    }
  }

  Future<Map<String, dynamic>> fetchUser() async {
    String? token = SharedPreferencesManager.getString('token');

    if (token == null) {
      throw Exception('No user is logged in.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/user'), // Adjust the URL as needed for fetching user info
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }
}
