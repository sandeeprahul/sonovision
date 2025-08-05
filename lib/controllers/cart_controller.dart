import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/auth_service.dart';

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
  final authController =Get.put(AuthController());

  final _storage = GetStorage();
  final _cartKey = 'cart_items';

  var cartItems = <CartItem>[].obs;
  var discount = 0.0.obs;
  var deliveryCharge = 0.0.obs;
  var isCouponApplied = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal - discount.value + deliveryCharge.value;

  void addItem(CartItem item) {
    int index = cartItems.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(item);
    }
    saveCart();
  }

  void removeItem(CartItem item) {
    cartItems.remove(item);
    saveCart();
  }

  void applyCoupon(String? code) {
    if (code != null && code.isNotEmpty && !isCouponApplied.value) {
      discount.value = subtotal * 0.1;
      isCouponApplied.value = true;
      saveCart(); // 🔥 Save changes
    }
  }

  void increaseQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
    saveCart();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    }else {
      // Remove the item from the cart if its quantity is 1
      cartItems.removeAt(index);
    }
    saveCart();

  }

  void clearCart() {
    cartItems.clear();
    discount.value = 0.0;
    deliveryCharge.value = 0.0;
    isCouponApplied.value = false;
    _storage.remove(_cartKey);
  }

  void saveCart() {
    final cartData = cartItems.map((item) => {
      'productId': item.productId,
      'name': item.name,
      'image': item.image,
      'color': item.color,
      'price': item.price,
      'quantity': item.quantity,
    }).toList();

    _storage.write(_cartKey, cartData);
  }

  void loadCart() {
    final stored = _storage.read<List>(_cartKey);
    if (stored != null) {
      cartItems.value = stored.map((item) => CartItem(
        productId: item['productId'],
        name: item['name'],
        image: item['image'],
        color: item['color'],
        price: item['price'],
        quantity: item['quantity'],
      )).toList();
    }
  }
}
