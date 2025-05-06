import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final SearchhController controller = Get.put(SearchhController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: controller.search,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Search products...',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: Obx(() => controller.query.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: controller.clearSearch,
                    )
                  : const SizedBox()),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.query.value.isEmpty) {
          return _buildSuggestions(context);
        } else if (controller.results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 70, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No results found', style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Try a different keyword', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.results.length,
            itemBuilder: (context, index) {
              final product = controller.results[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product['image'],
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  subtitle: Text(
                    product['category'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Text(
                    '\$${product['price']}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to product details
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.history.isNotEmpty) ...[
            const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(controller.history.length, (index) {
                final item = controller.history[index];
                return ActionChip(
                  label: Text(item),
                  backgroundColor: Colors.grey[200],
                  onPressed: () => controller.selectSuggestion(item),
                  avatar: const Icon(Icons.history, size: 18, color: Colors.grey),
                );
              }),
            ),
            const SizedBox(height: 24),
          ],
          const Text('Suggestions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: List.generate(controller.suggestions.length, (index) {
              final suggestion = controller.suggestions[index];
              return Chip(
                label: Text(suggestion),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                avatar: const Icon(Icons.search, size: 18, color: Colors.grey),
                onDeleted: null,
                deleteIcon: null,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                elevation: 0,
                shadowColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,

                // onPressed: () => controller.selectSuggestion(suggestion),
              );
            }),
          ),
        ],
      ),
    );
  }
}
