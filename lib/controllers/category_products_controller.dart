import 'package:electronic_store/models/product_details_data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CategoryProductsController extends GetxController {
  final String categoryId;

  CategoryProductsController(this.categoryId);

  var products = <ProductDetailsData>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var isEmpty = false.obs;

  @override
  void onInit() {
    fetchProductsByCategory(categoryId);
    super.onInit();
  }

  void fetchProductsByCategory(String categoryId) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    isEmpty.value = false;
    products.value = [];
    try {
      final response = await http.get(
        Uri.parse('https://sonovision.asquare.org.in/api/products/category/$categoryId'),
      );
      print('https://sonovision.asquare.org.in/api/products/category/$categoryId');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          isEmpty.value = true;
        } else {
          products.value = data.map((e) => ProductDetailsData.fromJson(e)).toList();
        }
      } else {
        isError.value = true;
        errorMessage.value = 'Server error: ${response.statusCode}';
        print('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Something went wrong: $e';

      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
