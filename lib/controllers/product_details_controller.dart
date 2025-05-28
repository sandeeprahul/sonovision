import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/product_details_data.dart';

class ProductDetailsController extends GetxController {
  var isLoading = true.obs;
  var product = Rxn<ProductDetailsData>();

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
}
