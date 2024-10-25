import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:landlord_tenant/utils/urlContants.dart';

class ApartmentService {
  final String apiUrl = '$base_url/apartments';

  Future<bool> addApartment(Map<String, dynamic> apartmentData) async {
    final token = await _getToken(); // Retrieve token

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Include token in headers
      },
      body: jsonEncode(apartmentData),
    );

    return response.statusCode == 201; // Returns true if the apartment was created successfully
  }

  Future<List<dynamic>> getApartments() async {
    final token = await _getToken(); // Retrieve token

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token', // Include token in headers
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load apartments');
    }
  }

  Future<dynamic> getApartmentById(int id) async {
    final token = await _getToken(); // Retrieve token

    final response = await http.get(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include token in headers
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load apartment');
    }
  }

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token from shared preferences
  }
}
