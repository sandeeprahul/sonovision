import 'package:flutter/material.dart';




import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final CartController controller = Get.put(CartController());
  final TextEditingController couponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(item.image, width: 100, height: 100, fit: BoxFit.cover),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                                Text('Color: ${item.color}'),
                                Text('₹${item.price}', style: Theme.of(context).textTheme.titleLarge),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => controller.decreaseQuantity(index),
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => controller.increaseQuantity(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => controller.removeItem(item),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Coupon
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Apply Coupon'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: couponController,
                              decoration: const InputDecoration(
                                hintText: 'Enter coupon code',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => controller.applyCoupon(couponController.text),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Summary
              Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Order Summary'),
                      const SizedBox(height: 16),
                      rowItem('Subtotal', '₹${controller.subtotal.toStringAsFixed(0)}'),
                      rowItem('Discount', '-₹${controller.discount.value.toStringAsFixed(0)}'),
                      rowItem('Delivery Charge', '₹${controller.deliveryCharge.value.toStringAsFixed(0)}'),
                      const Divider(),
                      rowItem('Total', '₹${controller.total.toStringAsFixed(0)}',
                          bold: true),
                    ],
                  )),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.cartItems.isEmpty) return const SizedBox.shrink();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to checkout
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('PROCEED TO CHECKOUT'),
            ),
          ),
        );
      }),
    );
  }

  Widget rowItem(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
          Text(value, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}

