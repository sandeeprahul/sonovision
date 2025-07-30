import 'dart:convert';

import 'package:electronic_store/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';


class SearchhController extends GetxController {
  final RxString query = ''.obs;
  final RxList<dynamic> results = <dynamic>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxList<String> history = <String>[].obs;
  final RxBool isSearching = false.obs;
  final RxInt selectedIndex = (-1).obs;
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    _loadPopularSearches();
    // ever(query, (_) => textController.text = query.value);

    super.onInit();
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    textController.dispose();
    super.onClose();
  }


  Future<void> _loadPopularSearches() async {
    // Replace with actual API call if needed
    suggestions.value = [
      'Galaxy S24',
      'Washing Machine',
      'Apple',
      'Samsung',
      'Soundbar',
    ];
  }
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));

  Future<void> search(String q) async {
    query.value = q.trim();
    selectedIndex.value = -1;

    if (q.isEmpty) {
      results.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;

    try {
      // First check local cache (if you want)
      // await _searchLocalProducts(q);

      // Then search from API
      await _searchApiProducts(q);

      // Update history
      if (q.isNotEmpty && !history.contains(q)) {
        history.insert(0, q);
        if (history.length > 5) history.removeLast();
      }
    } catch (e) {
      Get.snackbar('Error', 'Search failed: ${e.toString()}');
      print('Search failed: ${e.toString()}');
    } finally {
      isSearching.value = false;
    }


  }
  Future<void> searchfff(String q) async {
    print('Search query: $q');
    query.value = q.trim();
    selectedIndex.value = -1;

    if (q.isEmpty) {
      results.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;

    try {
      // Search in local product list first
      final controller = ProductController.to;

      final localResults = controller.productList
          .where((product) =>
              product['name']
                  .toString()
                  .toLowerCase()
                  .contains(q.toLowerCase()) ||
              product['brand']
                  .toString()
                  .toLowerCase()
                  .contains(q.toLowerCase()) ||product['specifications']
                  .toString()
                  .toLowerCase()
                  .contains(q.toLowerCase()) ||
              product['highlights']
                  .toString()
                  .toLowerCase()
                  .contains(q.toLowerCase()))
          .toList();

      // results.value = localResults;
      results.assignAll(localResults);

      // Add to search history
      if (q.isNotEmpty && !history.contains(q)) {
        history.insert(0, q);
        if (history.length > 5) history.removeLast();
      }
    } catch (e) {
      Get.snackbar('Error', 'Search failed: ${e.toString()}');
      print('Search failed: ${e.toString()}');
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    query.value = '';
    textController.clear();
    results.clear();
    searchFocusNode.unfocus();
  }
  void selectSuggestion(String suggestion) {
    textController.text = suggestion;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    search(suggestion);
    searchFocusNode.requestFocus();

  }
  final deBouncer = Debouncer(delay: const Duration(milliseconds: 300));

  Future<void> _searchApiProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/products?search=$query'),
        headers: {'Content-Type': 'application/json'},
      );

      print("${ApiService.baseUrl}/api/products?search=$query");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        results.assignAll(data);

        // Optionally update local cache
        ProductController.to.productList.assignAll(data);
      } else {
        throw Exception('Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search API error: $e');
    }
  }

  void selectSuggestiond(String suggestion) {
    query.value = suggestion;
    textController.text = suggestion;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    search(suggestion);
    searchFocusNode.requestFocus();
  }
}
