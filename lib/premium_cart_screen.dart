import 'package:electronic_store/pages/main_page.dart';
import 'package:electronic_store/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/cart_controller.dart';

class PremiumCartScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController());
  final couponController = TextEditingController();

  PremiumCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('My Cart',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.white, fontSize: 22)),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.blue.shade800,
      /*leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: () => Get.back(),
      ),*/
    /*  actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
        ),
      ],*/
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyCart();
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = controller.cartItems[index];
                        return _buildCartItem(item, index, context);
                      },
                      childCount: controller.cartItems.length,
                    ),
                  ),
                  // SliverToBoxAdapter(child: _buildPromoSection()),
                  SliverToBoxAdapter(child: _buildDeliveryInfo()),
                  SliverToBoxAdapter(child: _buildOrderSummary()),
                  SliverToBoxAdapter(child: _buildCouponField()),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 120, color: Colors.black),
          const SizedBox(height: 16),
          const Text('Your Cart is Empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                // color: Colors.white,
              )),
          const SizedBox(height: 8),
          const Text('Explore  electronics and add some items',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.off(const MainPage()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.black,
            ),
            child: const Text('Continue Shopping',
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index, BuildContext context) {
    return Dismissible(
      key: Key(item.productId),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
      ),
      onDismissed: (direction) => controller.removeItem(item),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                  const SizedBox(height: 4),
                  Text('Color: ${item.color}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 8),
                  Text('₹${item.price}',
                      style:  Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed: () => controller.decreaseQuantity(index)),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text('${item.quantity}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                      _buildQuantityButton(
                          icon: Icons.add,
                          onPressed: () => controller.increaseQuantity(index)),
                  /*    const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, size: 20),
                        onPressed: () {},
                        color: Colors.grey,
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: IconButton(
        icon: Icon(icon, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Independence Day Sale!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text('Get 20% off on selected items',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delivery_dining, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivery info',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text('Delivery within 5-7 business days',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Order Summary',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 16),
              _buildSummaryRow(
                  'Subtotal', '₹${controller.subtotal.toStringAsFixed(2)}'),
              _buildSummaryRow('Discount',
                  '-₹${controller.discount.value.toStringAsFixed(2)}',
                  isDiscount: true),
              _buildSummaryRow('Delivery',
                  '₹${controller.deliveryCharge.value.toStringAsFixed(2)}'),
              const Divider(height: 24, thickness: 1),
              _buildSummaryRow(
                  'Total', '₹${controller.total.toStringAsFixed(2)}',
                  isTotal: true),
            ],
          )),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: isTotal ? 15 : 14,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  color: isDiscount
                      ? Colors.green
                      : isTotal
                          ? Colors.black
                          : Colors.black,
                  fontSize: isTotal ? 16 : 14,
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildCouponField() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Apply Coupon',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: couponController,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Invalid Coupon',
                    middleText: 'The coupon code you entered is not valid',
                    textConfirm: 'OK',
                    confirmTextColor: Colors.white,
                    onConfirm: () => Get.back(),
                    buttonColor: Colors.black,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black,
                ),
                child:
                    const Text('Apply', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Obx(() {
      if (controller.cartItems.isEmpty) return const SizedBox.shrink();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!))),
        child: ElevatedButton(
          onPressed: () {
            controller.authController.isLoggedIn
                ? Get.toNamed('/checkout')
                : Get.toNamed('/login');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.black,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('PROCEED TO CHECKOUT',
                  style: TextStyle(color: Colors.white, letterSpacing: 1)),
              // SizedBox(width: 8),
              // Icon(Icons.arrow_forward, color: Colors.white, size: 18),
            ],
          ),
        ),
      );
    });
  }
}
