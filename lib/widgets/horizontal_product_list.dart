import 'package:electronic_store/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/product_controller.dart';
import '../utils/cart_bottom_sheet.dart';

class HorizontalProductList extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  HorizontalProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
      }

      if (controller.productList.isEmpty) {
        return const SizedBox(height: 200, child: Center(child: Text("No related products")));
      }

      return Container(
        margin: const EdgeInsets.only(right: 12,bottom: 12,left: 6),
        height: 340,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            final images = product['images'] as List;
            final double price = product['price']?.toDouble() ?? 0;
            final double discount = product['discountPercentage']?.toDouble() ?? 0;
            final discountedPrice = price - (price * discount / 100);

            return InkWell(
              onTap: (){
                Get.toNamed('/product-details', arguments: product);

                // Get.to(const ProductDetailsPage(), arguments: product);
                print('tapppppedddd');
              },
              child: Container(
                width: 180,
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: images.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product['brand'],
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const Spacer(),
                    Text(
                      "₹${discountedPrice.toStringAsFixed(0)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (discount > 0)
                      Text(
                        "₹${price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {

                          CartBottomSheet.show();

                          // Get.snackbar("Cart", "${product['name']} added to cart",snackPosition:SnackPosition.BOTTOM,overlayBlur: 2);
                        },
                        child: const Text("Add to Cart", style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
