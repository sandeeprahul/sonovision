import 'package:get/get.dart';

class CartItem {
  final String productId;
  final String name;
  final String image;
  final String color;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.color,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}


class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var discount = 0.0.obs;
  var deliveryCharge = 0.0.obs;
  var isCouponApplied = false.obs;

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + item.total);

  double get total =>
      subtotal - discount.value + deliveryCharge.value;

  void addItem(CartItem item) {
    int index = cartItems.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(item);
    }
  }

  void removeItem(CartItem item) {
    cartItems.remove(item);
  }

  void increaseQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }
  }

  void applyCoupon(String? code) {
    if (code != null && code.isNotEmpty && !isCouponApplied.value) {
      discount.value = subtotal * 0.1;
      isCouponApplied.value = true;
    }
  }

  void clearCart() {
    cartItems.clear();
    discount.value = 0.0;
    deliveryCharge.value = 0.0;
    isCouponApplied.value = false;
  }
}
