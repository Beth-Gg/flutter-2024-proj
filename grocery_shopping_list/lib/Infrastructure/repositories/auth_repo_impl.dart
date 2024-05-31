import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Add this import for jsonEncode and jsonDecode
import 'package:flutter/material.dart'; 
import '../api_service.dart';// Add this import for BuildContext

import 'Auth_repository.dart';
class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  final ApiService _apiService;

  AuthRepositoryImpl(this._prefs, this._apiService); // Constructor

  @override
  Future<String?> getToken() async {
    return _prefs.getString('access_token');
  }

  @override
  Future<void> signUp(String username, String password, String role, BuildContext context) async {
    await _apiService.signUp(username, password, role);
  }

  @override
  Future<String?> getID() async {
    return _prefs.getString('id');
  }

  @override
  Future<bool> setToken(String value) async {
    return _prefs.setString('access_token', value);
  }

  @override
  Future<bool> setID(String value) async {
    return _prefs.setString('id', value);
  }

  @override
  Future<void> logout() async {
    await _prefs.clear();
  }

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:6036/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      await setToken(responseData['access_token']);
      await setID(responseData['id']);
      return responseData;
    } else {
      throw Exception('Failed to login');
    }
  }
}