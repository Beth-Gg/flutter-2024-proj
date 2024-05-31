import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> signUp(String? username, String? password, String? role) async {
    if (username == null || password == null || role == null) {
      throw Exception('Username, password, and role are required');
    }
    final url = 'http://localhost:6036/user/signup';
    final body = {
      'username': username,
      'password': password,
      'role': role,
    };
    final response = await http.post(Uri.parse(url), body: body);
    return response;
  }

  Future<http.Response> login(String? username, String? password) async {
    if (username == null || password == null) {
      throw Exception('Username and password are required');
    }
    final url = 'http://localhost:6036/auth/login';
    final body = {
      'username': username,
      'password': password,
    };
    final response = await http.post(Uri.parse(url), body: body);
    return response;
  }
}