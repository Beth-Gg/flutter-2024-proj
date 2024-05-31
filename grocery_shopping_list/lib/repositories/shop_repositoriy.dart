import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/shops_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://localhost:6036/shop';

class ShopRepository {
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<List<Shop>> fetchAllShops() async {
    final token = await _getToken();
    final response = await http.get(Uri.parse('$baseUrl/allshops'),
        headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((shop) => Shop.fromJson(shop)).toList();
    } else {
      throw Exception('Failed to load shops');
    }
  }

  Future<String> addShop(String name, String items) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({'name': name, 'items': items}),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body)['id'];
    } else {
      throw Exception('Failed to add shop');
    }
  }

  Future<void> editShop(String id, String name, String items) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({'name': name, 'items': items}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit shop');
    }
  }

  Future<void> deleteShop(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete shop');
    }
  }
}
