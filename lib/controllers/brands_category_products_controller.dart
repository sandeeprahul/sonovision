import 'package:electronic_store/models/product_details_data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_details_data_from_brands_category.dart';
import '../services/api_service.dart';


class BrandsCategoryProductsController extends GetxController {
  final String categoryId;

  BrandsCategoryProductsController(this.categoryId);


  final RxList<ProductDetailsDataFromBrandsCategory> products = <ProductDetailsDataFromBrandsCategory>[].obs;
  final List<ProductDetailsDataFromBrandsCategory> allProducts = [];
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEmpty = false.obs;
  final RxString selectedFilter = 'All'.obs;

  // Brand filtering variables
  final RxList<String> availableBrands = <String>[].obs;
  final RxString selectedBrand = 'All'.obs;

  // Price filtering variables
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 0.0.obs;
  final RxDouble selectedMinPrice = 0.0.obs;
  final RxDouble selectedMaxPrice = 0.0.obs;



  @override
  void onInit() {
    // fetchProductsByCategory(categoryId,);
    super.onInit();
  }

  void setInitialPriceRange(double min, double max) {
    selectedMinPrice.value = min;
    selectedMaxPrice.value = max;

    // Also set bounds if needed
    if (minPrice.value == 0 && maxPrice.value == 0) {
      minPrice.value = min;
      maxPrice.value = max;
    }
  }
  void setInitialBrand(String brandName) {
    selectedBrand.value = brandName;
    print("brandNameINITAL SETUP");
    print(brandName);
  }
  void applyInitialFilters() {
    // _applyAllFilters();
    _initializeBrandFilters();

  }

  void _initializeBrandFilters() {
    // Extract all unique brands from products
    final brands = allProducts
        .map((p) => p.brand?.name ?? 'Unknown')
        .toSet()
        .toList();
    // final brands = allProducts.map((p) => p.brand!.name??'Unknown').whereType<String>().toSet().toList();
    availableBrands.assignAll(['All', ...brands]);
    selectedBrand.value = 'All';
  }

  void _initializePriceRangeFilters() {
    if (allProducts.isEmpty) return;

    // Find min and max prices
    final prices = allProducts.map((p) => p.price).toList();
    minPrice.value = prices.reduce((a, b) => a < b ? a : b);
    maxPrice.value = prices.reduce((a, b) => a > b ? a : b);

    // Set initial selected range to full range
    selectedMinPrice.value = minPrice.value;
    selectedMaxPrice.value = maxPrice.value;
  }

  void applyFilterf(String filter) {
    selectedFilter.value = filter;
    // _applyAllFilters();
  }

  void selectBrandf(String brand) {
    selectedBrand.value = brand;
    // _applyAllFilters();
  }

  void updatePriceRangef(double min, double max) {
    selectedMinPrice.value = min;
    selectedMaxPrice.value = max;
    // _applyAllFilters();
  }

  void _applyAllFiltersf() {
    print('came to_applyAllFilters ');
    print(selectedBrand.value );
    print(selectedMinPrice.value );
    List<ProductDetailsDataFromBrandsCategory> filteredProducts = List.from(allProducts);

    // Apply brand filter
    if (selectedBrand.value != 'All') {
      filteredProducts = filteredProducts.where((p) => p.brand?.name == selectedBrand.value).toList();
    }

    // Apply price range filter
    filteredProducts = filteredProducts.where((p) =>
    p.price >= selectedMinPrice.value && p.price <= selectedMaxPrice.value
    ).toList();

    // Apply sorting filter
    switch (selectedFilter.value) {
      case 'Price ↓':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price ↑':
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Popular':
        filteredProducts.sort((a, b) => b.discountPercentage!.compareTo(a.discountPercentage!));
        break;
      case 'New':
      // If you have createdAt field, use: b.createdAt.compareTo(a.createdAt)
        filteredProducts = filteredProducts.reversed.toList();
        break;
      case 'All':
      default:
      // No additional sorting needed
        break;
    }

    products.assignAll(filteredProducts);
  }

  void resetFiltersd() {
    selectedFilter.value = 'All';
    selectedBrand.value = 'All';
    selectedMinPrice.value = minPrice.value;
    selectedMaxPrice.value = maxPrice.value;
    // _applyAllFilters();
  }


  void fetchProductsByCategory(String categoryId, String brandId, {
    String? filterName,
    String? filterId,
  }) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';
    isEmpty.value = false;
    products.clear();

    try {
      String url;

      if (filterName != null && filterId != null) {
        final safeFilterName = filterName.replaceAll(' ', '%20');
        // final filterParam = "Battery capacity:68ba650cdda4a05113457879";
        final filterParam = "$safeFilterName:$filterId";
        //Battery capacity
        url = '${ApiService.baseUrl}/api/products?brand=$brandId&category=$categoryId&filter=$filterParam';
      } else {
        url = '${ApiService.baseUrl}/api/products?brand=$brandId&category=$categoryId';
      }
      print(url);

      final response = await http.get(Uri.parse(url));
      print("new $response");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isEmpty) {
          isEmpty.value = true;
          allProducts.clear();
          products.clear();
        } else {
          print(data.length);

          allProducts.assignAll(
            data.map((e) => ProductDetailsDataFromBrandsCategory.fromJson(e)).toList(),
          );
          print("Parsed products: ${allProducts.map((e) => e.name).toList()}");

          print(allProducts.length);
        }
      } else {
        isError.value = true;
        print('${response.statusCode}');

        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print(e);
      isError.value = true;
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }


}
