import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/lists_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://localhost:6036/user';

class ListRepository {
  final http.Client client;

  ListRepository({http.Client? client}) : client = client ?? http.Client();
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token;
  }

  Future<String?> _getID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    return id;
  }

  Future<List<GroceryList>> fetchAllLists() async {
    final token = await _getToken();
    final userid = await _getID();
    // print(token);
    final response = await http.get(Uri.parse('$baseUrl/lists/$userid'),
        headers: {'Authorization': 'Bearer $token'});

    // print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((list) => GroceryList.fromJson(list)).toList();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<String> addList(String date, String content) async {
    final token = await _getToken();
    final userid = await _getID();

    final response = await http.post(
      Uri.parse('$baseUrl/list/$userid'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({'date': date, 'content': content}),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body)['id'];
    } else {
      throw Exception('Failed to add list');
    }
  }

  Future<void> editList(String id, String date, String content) async {
    final token = await _getToken();
    final userid = await _getID();

    final response = await http.put(
      Uri.parse('$baseUrl/$userid/list/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({'date': date, 'content': content}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit list');
    }
  }

  Future<void> deleteList(String id) async {
    final token = await _getToken();
    final userid = await _getID();

    final response = await http.delete(
      Uri.parse('$baseUrl/$userid/list/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete list');
    }
  }
}
