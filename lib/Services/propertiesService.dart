import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/urlContants.dart';



class PropertyService {

  // Fetch all properties
  Future<List<dynamic>> getProperties() async {
    var response = await http.get(Uri.parse('${base_url}/properties'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load properties');
    }
  }

  // Fetch landlord properties
  Future<List<dynamic>> getLandlordProperties() async {
    var response = await http.get(Uri.parse('${base_url}/landlord_properties'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load properties');
    }
  }


  // Add a new property
  Future<void> addProperty(Map<String, dynamic> propertyData) async {
    var response = await http.post(
      Uri.parse('${base_url}/properties'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(propertyData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add property');
    }
  }

  // Update a property
  Future<void> updateProperty(String id, Map<String, dynamic> propertyData) async {
    var response = await http.put(
      Uri.parse('${base_url}/properties/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(propertyData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update property');
    }
  }

  // Delete a property
  Future<void> deleteProperty(String id) async {
    var response = await http.delete(Uri.parse('${base_url}/properties/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete property');
    }
  }
}
