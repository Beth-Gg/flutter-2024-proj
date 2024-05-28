import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future signUp(String username, String password, String role, context) async {
  final response = await http.post(
      Uri.parse('http://localhost:6036/user/signup'),
      body: {
        'username': username,
        'password': password,
        'role': role,
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  

  
}
