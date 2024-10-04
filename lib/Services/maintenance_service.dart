import 'dart:convert';
import 'package:http/http.dart' as http;

class MaintenanceService {
  final String baseUrl;

  MaintenanceService(this.baseUrl);

  Future<List<MaintenanceTicket>> fetchMaintenanceTickets() async {
    final response = await http.get(Uri.parse('$baseUrl/maintenance-tickets'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((ticket) => MaintenanceTicket.fromJson(ticket)).toList();
    } else {
      throw Exception('Failed to load maintenance tickets');
    }
  }

  Future<void> createTicket(int tenantId, int propertyId, String issue, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/maintenance-tickets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'tenant_id': tenantId,
        'property_id': propertyId,
        'issue': issue,
        'description': description,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create maintenance ticket');
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
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceTicket({
    required this.id,
    required this.tenantId,
    required this.propertyId,
    required this.issue,
    required this.description,
    required this.status,
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
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
