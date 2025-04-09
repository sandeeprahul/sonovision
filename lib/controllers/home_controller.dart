import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final Rx<Map<String, dynamic>> homeData = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/home_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      homeData.value = jsonData;
    } catch (e) {
      error.value = 'Failed to load home data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshHomeData() {
    loadHomeData();
  }
}