import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/category.dart';

class CategoryController extends GetxController {
  var categories = <Category>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('https://sonovision.asquare.org.in/api/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        categories.value = data.map((e) => Category.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
