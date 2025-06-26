// services/order_service.dart

import 'dart:convert';
import 'package:electronic_store/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_service.dart';

class OrderService {
  static Future<List<dynamic>> fetchOrders() async {
    AuthController authController = Get.put(AuthController());
     await authController.loadUserAndToken();
    String tokenValue = authController.token.value;

    final response = await http.get(
      Uri.parse("${ApiService.baseUrl}/api/orders"),
      headers: {
        'Authorization': 'Bearer $tokenValue',
        'Content-Type': 'application/json',
      },
    ); // Replace with your API
    if (response.statusCode == 200) {
      print('$tokenValue');
      print("${ApiService.baseUrl}/api/orders");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
