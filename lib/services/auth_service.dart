import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';

  RxString token = ''.obs;
  RxMap<String, dynamic> user = <String, dynamic>{}.obs;

  static const String baseUrl =
      'https://sonovision.asquare.org.in';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': "user@sonovision.com",
        // 'email': email,
        'password': "Test@1234",
        // 'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      final tkn = data['token'];
      // final userData = data['user'];

      await _saveToken(tkn);
      final userData = {
        'email': email,
        'login_time': DateTime.now().toIso8601String(),
      };
      await _saveUser(userData);

      token.value = tkn;
      user.value = userData;

      return tkn;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register: ${response.statusCode}');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<void> _saveUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, json.encode(userData));
  }

  Future<void> loadUserAndToken() async {
    final prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString(tokenKey) ?? '';
    final userString = prefs.getString(userKey);
    if (userString != null) {
      user.value = json.decode(userString);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
    token.value = '';
    user.value = {};
  }

  bool get isLoggedIn => token.isNotEmpty;
}

class AuthServissce {
  static const String baseUrl =
      'https://sonovision.asquare.org.in'; // Replace with your actual API base URL

  // static const String baseUrl = 'YOUR_API_BASE_URL'; // Replace with your actual API base URL
  static const String tokenKey = 'auth_token';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      /*body: json.encode({
        "email": "sandeeprahul156@gmail.com",
        "password": "123456"
      }),*/    body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      await _saveToken(token);
      return token;
    } else {
      print(response.statusCode);
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
  }
}
