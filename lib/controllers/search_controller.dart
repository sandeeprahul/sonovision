import 'package:get/get.dart';

class SearchhController extends GetxController {
  final RxString query = ''.obs;
  final RxList results = [].obs;
  final RxList suggestions = [
    'iPhone',
    'Samsung',
    'Laptop',
    'Headphones',
    'Smartwatch',
  ].obs;
  final RxList history = [].obs;

  // Temporary product data
  final List<Map<String, dynamic>> products = [
    {'name': 'iPhone 15 Pro', 'category': 'Mobile', 'price': 1299, 'image': 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-model-unselect-gallery-1-202309?wid=512&hei=512&fmt=jpeg&qlt=95&.v=1692912410452'},
    {'name': 'Samsung Galaxy S24', 'category': 'Mobile', 'price': 1099, 'image': 'https://images.samsung.com/is/image/samsung/p6pim/in/sm-s921bzadins/gallery/in-galaxy-s24-s921-sm-s921bzadins-thumb-538876569?172_172_PNG'},
    {'name': 'Sony WH-1000XM5', 'category': 'Headphones', 'price': 399, 'image': 'https://m.media-amazon.com/images/I/61bK6PMOC3L._SX679_.jpg'},
    {'name': 'MacBook Air M3', 'category': 'Laptop', 'price': 1499, 'image': 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-15-m3-hero-202402?wid=512&hei=512&fmt=jpeg&qlt=95&.v=1707332184720'},
    {'name': 'Apple Watch Series 9', 'category': 'Smartwatch', 'price': 499, 'image': 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MRX23ref_VW_34FR+watch-case-45-alum-starlight-nc-9s_VW_34FR_WF_CO_GEO_IN?wid=512&hei=512&fmt=jpeg&qlt=95&.v=1693186748290'},
  ];

  void search(String q) {
    query.value = q;
    if (q.isEmpty) {
      results.clear();
      return;
    }
    results.value = products
        .where((product) => product['name'].toLowerCase().contains(q.toLowerCase()))
        .toList();
    if (q.isNotEmpty && !history.contains(q)) {
      history.insert(0, q);
      if (history.length > 5) history.removeLast();
    }
  }

  void clearSearch() {
    query.value = '';
    results.clear();
  }

  void selectSuggestion(String suggestion) {
    search(suggestion);
  }
}
