import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/product_controller.dart';

class ProductListScreen extends StatelessWidget {
  final controller = Get.put(ProductController());

  ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.productList.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            final images = product['images'] as List;
            final specs = product['specifications'] as Map<String, dynamic>;

            final double price = product['price']?.toDouble() ?? 0;
            final double discount = product['discountPercentage']?.toDouble() ?? 0;
            final discountedPrice = price - (price * discount / 100);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image PageView
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        itemCount: images.length,
                        itemBuilder: (context, i) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: images[i],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(product['name'], style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(product['brand'], style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text("₹${discountedPrice.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if (discount > 0)
                      Text("₹${price.toStringAsFixed(0)}", style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text("Highlights: ${product['highlights']}", style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: (product['colors'] as List).map<Widget>((color) {
                        return Chip(
                          label: Text(color),
                          backgroundColor: Colors.grey.shade100,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text("Specifications", style: TextStyle(fontWeight: FontWeight.bold)),
                      children: specs.entries.map((entry) {
                        final key = entry.key[0].toUpperCase() + entry.key.substring(1);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(key, style: const TextStyle(color: Colors.black54)),
                              Text(entry.value.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text("Add to Cart"),
                        onPressed: () {
                          Get.snackbar("Cart", "${product['name']} added to cart");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
