import 'dart:convert';
import 'package:electronic_store/models/review_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/product_details_data.dart';
import '../services/api_service.dart';

class ProductDetailsController extends GetxController {
  var isLoading = true.obs;
  // var product = Rxn<ProductDetailsData>();
  var product = Rxn<ProductDetailsData>();



  final RxList<ProductReview> reviews = <ProductReview>[].obs;
  final RxString errorMessage = ''.obs;
  final RxDouble averageRating = 0.0.obs;
  final RxInt totalReviews = 0.obs;


  Future<void> fetchProduct(String productId) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('https://sonovision.asquare.org.in/api/products/$productId'),///682db38b42916fcb457b89d5
      );
      print('https://sonovision.asquare.org.in/api/products/$productId');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        product.value = ProductDetailsData.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to fetch product details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReviews(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/reviews/product/$productId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('${ApiService.baseUrl}/api/reviews/product/$productId');
      print('${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        reviews.assignAll(
          data.map((json) => ProductReview.fromJson(json)).toList(),
        );
        _calculateStats();
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching reviews: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStats() {
    if (reviews.isEmpty) {
      averageRating.value = 0.0;
      totalReviews.value = 0;
      return;
    }

    final total = reviews.fold(0, (sum, review) => sum + review.rating);
    averageRating.value = total / reviews.length;
    totalReviews.value = reviews.length;
  }

 /* Future<void> refreshReviews() async {
    await fetchReviews();
  }*/
}
