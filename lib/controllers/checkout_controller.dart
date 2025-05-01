import 'package:electronic_store/services/api_service.dart';
import 'package:electronic_store/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';

import '../pages/order_success_page.dart';
import 'cart_controller.dart';

class AddressModel {
  final String id;
  final String name;
  final String type;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String postalCode;

  AddressModel({
    required this.id,
    required this.name,
    required this.type,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      postalCode: json['postalCode'],
    );
  }
}

class CheckoutController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final selectedAddress =
      Rxn<AddressModel>(); // Rxn<T> means nullable observable
  final isLoading = false.obs;
  final selectedAddressId = RxnString(); // Nullable
  final _authController = Get.put(AuthController());
  final selectedPaymentMethod = ''.obs; // A
  final Razorpay _razorpay = Razorpay();

  onInit() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchAddresses() async {
    final token =
        await _authController.loadUserAndToken(); // uses your getToken method
    // String? name = _authController.user['name'];
    String tokenValue = _authController.token.value;
    bool loggedIn = _authController.isLoggedIn;

    if (tokenValue.isEmpty) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/address'),
        headers: {
          'Authorization': 'Bearer $tokenValue',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        addresses.value = data.map((e) => AddressModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load addresses');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder() async {
    final cartController = Get.put(CartController());
    final token =
        await _authController.loadUserAndToken(); // uses your getToken method
    String tokenValue = _authController.token.value;
    if (selectedAddressId.value == null || cartController.cartItems.isEmpty) {
      Get.snackbar('Error', 'Please select an address and add items to cart.');
      return;
    }

    final products = cartController.cartItems
        .map((item) => {
              "product": item.productId,
              "quantity": item.quantity,
            })
        .toList();

    final total = cartController.cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final body = {
      "products": products,
      "total": total,
      "address": selectedAddressId.value,
    };

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/api/orders"),
        headers: {
          'Authorization': 'Bearer $tokenValue',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        cartController.clearCart();
        final responseData = jsonDecode(response.body);

        if(selectedPaymentMethod.value=="Cash on Delivery"){
          final orderId = responseData['_id']; // this is your actual order ID
          Get.to(() => OrderSuccessPage(orderId: orderId));
        }else{
          // Online Payment via Razorpay
          var options = {
            'key': 'rzp_test_YourTestKeyHere', // replace with your test key
            'amount': cartController.total* 100, // in paise
            'name': 'Your App Name',
            'description': 'Order Payment',
            'prefill': {
              'contact': '9876543210',
              'email': 'test@example.com',
            },
            'external': {
              'wallets': ['paytm']
            }
          };

          try {
            _razorpay.open(options);
          } catch (e) {
            debugPrint('Error: $e');
          }

          // Store the orderId in a variable accessible to the success handler
          // currentOrderId = orderId;
        }


      } else {
        Get.snackbar("Error", "Failed to place order: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
