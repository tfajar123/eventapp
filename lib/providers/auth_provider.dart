// lib/providers/auth_provider.dart

import 'package:event_app/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? get token {
    return _token;
  }
  bool get isAuth {
    return _token != null;
  }

  Future<void> register(String name, String email, String password) async {
    final url = Uri.parse('http://192.168.100.65:8000/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      }),
    );

    if (response.statusCode == 201) {
      _token = json.decode(response.body)['token'];
      notifyListeners();
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://192.168.100.65:8000/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      _token = json.decode(response.body)['token'];
      notifyListeners();
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> logout(BuildContext context) async {
  final url = Uri.parse('http://192.168.100.65:8000/api/logout');
  final response = await http.post(
    url,
    headers: {'Authorization': 'Bearer $_token'},
  );

  if (response.statusCode == 200) {
    _token = null;
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()), // or RegisterScreen()
    );
  } else {
    throw Exception('Failed to logout');
  }
}
}
