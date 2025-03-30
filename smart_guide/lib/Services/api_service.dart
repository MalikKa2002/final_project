import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final String apiUrl = '';

// GET ALL THE DATA FROM DATABASE
  static Future<Map<String, dynamic>> fetchAll() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load names');
    }
  }

// ADD New DATA TO DATABASE
  static Future<Map<String, dynamic>> addData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

// UPDATE DATA IN DATABASE
  static Future<Map<String, dynamic>> updateData(
      String id, List<String> data) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data');
    }
  }

// DELETE DATA FROM DATABASE
  static Future<void> deleteData(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
    return;
  }
}
