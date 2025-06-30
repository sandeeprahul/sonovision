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
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Shopping Cart')),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.air,size: 120,color: Colors.black,),
              Center(child: Text('Your cart is empty',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),)),
            ],
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.image, width: 80, height: 80, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text('Color: ${item.color}', style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 4),
                                  Text('₹${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () => controller.decreaseQuantity(index),
                                        ),
                                        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () => controller.increaseQuantity(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever),
                              onPressed: () => controller.removeItem(item),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    )
                    ;
                  },
                ),


                // if (controller.discount.value > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.local_offer, color: Colors.green),
                        SizedBox(width: 8),
                        Expanded(child: Text('Independence Day Sale is running')),
                        // Expanded(child: Text('You saved ₹${controller.discount.value.toStringAsFixed(0)} on this order!')),
                      ],
                    ),
                  ),
                const Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.delivery_dining, color: Colors.blue),
                    title: Text('Delivery with 24 hours',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text('Express delivery available!'),
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
                        const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                        const SizedBox(height: 16),
                        rowItem('Subtotal', '₹${controller.subtotal.toStringAsFixed(0)},',Colors.black),
                        rowItem('Discount', '-₹${controller.discount.value.toStringAsFixed(0)}',Colors.green),
                        rowItem('Delivery Charge', '₹${controller.deliveryCharge.value.toStringAsFixed(0)}',Colors.red),
                        const Divider(),
                        rowItem('Total', '₹${controller.total.toStringAsFixed(0)}',Colors.black,
                            bold: true),
                      ],
                    )),
                  ),
                ),
                // Coupon
                Visibility(
                  visible: true,
                  child: Card(
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
                ),
              ],
            ),
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
                // Get.toNamed('/checkout');
                controller.authController.isLoggedIn ? Get.toNamed('/checkout') : Get.toNamed('/login');
                // checkUser

              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('PROCEED TO CHECKOUT'),
            ),
          ),
        );
      }),
    );
  }

  Widget rowItem(String label, String value, Color color, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: bold ? const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16) : const TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 14)),
          Text(value, style: bold ?  TextStyle(fontWeight: FontWeight.bold,color: color,fontSize: 16) :  TextStyle(fontWeight: FontWeight.bold,color: color,fontSize: 14)),
        ],
      ),
    );
  }
}

