import 'package:electronic_store/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

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
    ever(query, (_) => textController.text = query.value);

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

  Future<void> search(String q) async {
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
                  .contains(q.toLowerCase()) ||
              product['highlights']
                  .toString()
                  .toLowerCase()
                  .contains(q.toLowerCase()))
          .toList();

      results.value = localResults;

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
  }
  final deBouncer = Debouncer(delay: const Duration(milliseconds: 300));

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
