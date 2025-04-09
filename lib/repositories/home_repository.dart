import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/home_screen_model.dart';

class HomeRepository extends GetxService {
  final String baseUrl = 'https://api.example.com'; // Replace with your API URL

  Future<HomeScreenModel> getHomeScreenData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/home'));
      
      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        return HomeScreenModel.fromJson(resBody);
      } else {
        throw Exception('Failed to load home screen data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 