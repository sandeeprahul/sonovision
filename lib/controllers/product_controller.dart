import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = [].obs;

  static const String apiUrl =
      'https://sonovision.asquare.org.in';
  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('$apiUrl/api/products'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        productList.assignAll(data);
      } else {
        Get.snackbar('Error', 'Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    } finally {
      isLoading(false);
    }
  }
}
