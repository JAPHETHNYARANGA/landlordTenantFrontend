import 'dart:convert';
import 'package:http/http.dart' as http;


class TenantService {
  final String baseUrl;

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
          'password': tenant.password,
        }),
      );

      if (response.statusCode != 201) {
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
  final String? password;

  Tenant({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.password,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      password: json['password'],  // Optional password field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'password': password,
    };
  }
}

