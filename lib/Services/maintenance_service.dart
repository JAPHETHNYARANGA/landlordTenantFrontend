import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../sharedPreferences/adminSharedPreference.dart';

class MaintenanceService {
  final String baseUrl;
  String? token = SharedPreferencesManager.getString('token');

  MaintenanceService(this.baseUrl);

  Future<List<MaintenanceTicket>> fetchMaintenanceTickets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/maintenance-tickets'),
      headers: {
    'Authorization': 'Bearer $token', // Include the token in the headers
    'Content-Type': 'application/json', // Optionally set the content type
    },);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((ticket) => MaintenanceTicket.fromJson(ticket)).toList();
    } else {
      throw Exception('Failed to load maintenance tickets');
    }
  }

  Future<List<MaintenanceTicket>> fetchLandlordMaintenanceTickets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/landlord_tickets'),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
          'Content-Type': 'application/json', // Optionally set the content type
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((ticket) => MaintenanceTicket.fromJson(ticket)).toList();
      } else {
        // Log the actual response body for debugging
        print('Error response body: ${response.body}');
        throw Exception('Failed to load maintenance tickets: ${response.statusCode}');
      }
    } catch (e) {
      // Log any exceptions that occur
      print('Error fetching maintenance tickets: $e');
      throw Exception('Error fetching maintenance tickets: $e');
    }
  }

  Future<List<MaintenanceTicket>> fetchTenantMaintenanceTickets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tenant_tickets'),
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
          'Content-Type': 'application/json', // Optionally set the content type
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((ticket) => MaintenanceTicket.fromJson(ticket)).toList();
      } else {
        // Log the actual response body for debugging
        print('Error response body: ${response.body}');
        throw Exception('Failed to load maintenance tickets: ${response.statusCode}');
      }
    } catch (e) {
      // Log any exceptions that occur
      print('Error fetching maintenance tickets: $e');
      throw Exception('Error fetching maintenance tickets: $e');
    }
  }




  Future<void> createTicket(
      int tenantId,
      int propertyId,
      String issue,
      String description,
      File? image, // Add the image parameter
      ) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/maintenance-tickets'),
    );

    request.headers['Content-Type'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['tenant_id'] = tenantId.toString();
    request.fields['property_id'] = propertyId.toString();
    request.fields['issue'] = issue;
    request.fields['description'] = description;

    // If an image is provided, add it to the request
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Name of the field to which the file is attached
        image.path,
      ));
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to create maintenance ticket');
    }
  }

  Future<void> deleteTicket(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/maintenance-tickets/$id'),
      headers: {
        'Authorization': 'Bearer $token', // Include the bearer token
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete maintenance ticket: ${response.statusCode}');
    }
  }

}


class MaintenanceTicket {
  final int id;
  final int tenantId;
  final int propertyId;
  final String issue;
  final String description;
  final String status;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceTicket({
    required this.id,
    required this.tenantId,
    required this.propertyId,
    required this.issue,
    required this.description,
    required this.status,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaintenanceTicket.fromJson(Map<String, dynamic> json) {
    return MaintenanceTicket(
      id: json['id'],
      tenantId: json['tenant_id'],
      propertyId: json['property_id'],
      issue: json['issue'],
      description: json['description'],
      status: json['status'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
