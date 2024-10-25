import 'dart:convert';
import 'package:http/http.dart' as http;

import '../sharedPreferences/adminSharedPreference.dart';

class TenantService {
  final String baseUrl;
  String? token = SharedPreferencesManager.getString('token');

  TenantService(this.baseUrl);

  Future<List<Tenant>> fetchTenants() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tenants'));

      if (response.statusCode == 200) {
        final List<dynamic> tenantData = jsonDecode(response.body)['tenants'];
        return tenantData.map((data) => Tenant.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load tenants');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Tenant>> fetchLandlordTenants() async {
    try {
      // Check if the token is null or empty
      if (token == null || token!.isEmpty) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/landlord_tenants'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> tenantData = jsonDecode(response.body)['tenants'];
        return tenantData.map((data) => Tenant.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load tenants');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<void> createTenant(Tenant tenant) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tenants'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': tenant.name,
          'email': tenant.email,
          'phone_number': tenant.phoneNumber,
          'address': tenant.address,
          'house_no': tenant.houseNo,
          'property_id': tenant.propertyId,
        }),
      );

      if (response.statusCode != 201) {
        print('Response body: ${response.body}'); // Log the response body for debugging
        throw Exception('Failed to create tenant');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  Future<void> updateTenant(int id, Tenant tenant) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tenants/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': tenant.name,
          'email': tenant.email,
          'phone_number': tenant.phoneNumber,
          'address': tenant.address,
          'house_no': tenant.houseNo, // Include house_no
          'property_id': tenant.propertyId, // Include property_id
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update tenant');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTenant(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tenants/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete tenant');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class Tenant {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String houseNo; // New field for house number
  final int propertyId; // New field for property ID

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.houseNo, // Add houseNo to constructor
    required this.propertyId, // Add propertyId to constructor
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      houseNo: json['house_no'], // Parse house_no from JSON
      propertyId: json['property_id'], // Parse property_id from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'house_no': houseNo, // Include house_no in JSON output
      'property_id': propertyId, // Include property_id in JSON output
    };
  }
}
