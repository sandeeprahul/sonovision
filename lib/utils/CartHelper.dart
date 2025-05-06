import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import 'cart_bottom_sheet.dart';

class CartHelper {
  static void addToCart({
    required String productId,
    required String name,
    required String image,
    required String color,
    required double price,
  }) {
    final controller = Get.find<CartController>();

    final exists = controller.cartItems
        .any((item) => item.productId == productId);

    if (exists) {
      Get.snackbar(
        'Info',
        'Item already in cart',
        overlayBlur: 2,
        overlayColor: Colors.black26,
        backgroundColor: Colors.white,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(milliseconds: 1500),
      );
    } else {
      controller.addItem(CartItem(
        name: name,
        image: image,
        color: color,
        price: price,
        productId: productId,
      ));
      CartBottomSheet.show();
    }
  }
}
