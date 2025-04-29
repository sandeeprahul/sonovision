import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://sonovision.asquare.org.in'; // Replace with your actual API base URL

  // Home Data
  Future<Map<String, dynamic>> getHomeData() async {
    final response = await http.get(Uri.parse('$baseUrl/api/render/home'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load home data');
  }

  // Categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Failed to load categories');
  }

  // Addresses
  Future<List<Map<String, dynamic>>> getAddresses() async {
    final response = await http.get(Uri.parse('$baseUrl/api/address'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Failed to load addresses');
  }

  Future<Map<String, dynamic>> addAddress(Map<String, dynamic> address) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/address'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(address),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to add address');
  }

  // Orders
  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> order) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/orders'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(order),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to place order');
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/api/orders'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Failed to load orders');
  }

  // Products
  Future<Map<String, dynamic>> getProduct(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/products/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load product');
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories/$categoryId/products'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    }
    throw Exception('Failed to load products');
  }
}
