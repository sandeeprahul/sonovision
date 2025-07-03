import 'package:electronic_store/models/product_details_data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/api_service.dart';


class CategoryProductsController extends GetxController {
  final String categoryId;

  CategoryProductsController(this.categoryId);


  final RxList<ProductDetailsData> products = <ProductDetailsData>[].obs;
  final List<ProductDetailsData> allProducts = [];
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEmpty = false.obs;
  final RxString selectedFilter = 'All'.obs;

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
    products.clear();
    allProducts.clear();

    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/products/category/$categoryId'),
      );
      print('${ApiService.baseUrl}/api/products/category/$categoryId');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isEmpty) {
          isEmpty.value = true;
        } else {
          allProducts.addAll(data.map((e) => ProductDetailsData.fromJson(e)));

          products.value = data.map((e) => ProductDetailsData.fromJson(e)).toList();
          applyFilter('All');

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

  void applyFilter(String filter) {
    selectedFilter.value = filter;

    switch (filter) {
      case 'All':
        products.assignAll(allProducts);
        break;

      case 'Price ↑':
        products.assignAll(List.from(allProducts)..sort((a, b) => a.price.compareTo(b.price)));
        break;

      case 'Price ↓':
        products.assignAll(List.from(allProducts)..sort((a, b) => b.price.compareTo(a.price)));
        break;

      case 'Popular':
        products.assignAll(List.from(allProducts)..sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage)));
        break;

      case 'New':
        products.assignAll(List.from(allProducts)..reversed.toList()); // Replace with actual 'isNew' or 'createdAt' logic if available
        break;

      default:
        products.assignAll(allProducts);
    }
  }


  void applyFilteddr(String filter) {
    selectedFilter.value = filter;

    switch (filter) {
      case 'Popular':
        products.value = List.from(allProducts)
          ..sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      case 'New':
      // If you have createdAt field, sort by it. For now use as-is
        products.value = List.from(allProducts);
        break;
      case 'Price ↑':
        products.value = List.from(allProducts)
          ..sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price ↓':
        products.value = List.from(allProducts)
          ..sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'All':
      default:
        products.value = List.from(allProducts);
    }
  }
}
