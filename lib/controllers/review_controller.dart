import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class ReviewController extends GetxController {
  final isLoading = false.obs;
  final isSuccess = false.obs;
  final errorMessage = ''.obs;

  Future<void> submitReview({
    required String productId,
    required String orderId,
    required int rating,
    required String review,
    required List<String> files,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      const String apiUrl = 'https://sonovision.asquare.org.in/api/reviews';
      AuthController authController = Get.put(AuthController());
      await authController.loadUserAndToken();
      String tokenValue = authController.token.value;
      String userId = authController.user.value['_id'];

      final Map<String, dynamic> requestBody = {
        "user_id": userId,
        "product_id": productId,
        "order_id": orderId,
        "rating": rating,
        "review": review,
        "files": files,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
        body: jsonEncode(requestBody),
      );

      print('Rating Response:${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        isSuccess.value = true;
        Get.snackbar(
          'Success',
          'Review submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage.value = errorData['message'] ?? 'Failed to submit review';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}