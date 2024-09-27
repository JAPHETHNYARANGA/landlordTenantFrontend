import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  final String baseUrl;

  AdminService(this.baseUrl);

  Future<List<Admin>> fetchLandlords() async {
    final response = await http.get(Uri.parse('$baseUrl/admins'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> landlordsJson = data['admins'];
      return landlordsJson.map((json) => Admin.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load landlords');
    }
  }

  Future<void> createAdmin(Admin admin) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admins'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(admin.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create landlord');
    }
  }

  Future<void> deleteAdmin(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admins/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete landlord');
    }
  }
}

class Admin {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'password': password,
    };
  }
}
