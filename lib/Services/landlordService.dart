import 'dart:convert';
import 'package:http/http.dart' as http;

class LandlordService {
  final String baseUrl;

  LandlordService(this.baseUrl);

  Future<List<Landlord>> fetchLandlords() async {
    final response = await http.get(Uri.parse('$baseUrl/landlords'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> landlordsJson = data['landlords'];
      return landlordsJson.map((json) => Landlord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load landlords');
    }
  }

  Future<void> createLandlord(Landlord landlord) async {
    final response = await http.post(
      Uri.parse('$baseUrl/landlords'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(landlord.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create landlord');
    }
  }

  Future<void> deleteLandlord(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/landlords/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete landlord');
    }
  }
}

class Landlord {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;


  Landlord({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,

  });

  factory Landlord.fromJson(Map<String, dynamic> json) {
    return Landlord(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,

    };
  }
}
