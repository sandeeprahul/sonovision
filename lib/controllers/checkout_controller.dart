import 'package:electronic_store/services/api_service.dart';
import 'package:electronic_store/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert';

import '../pages/order_screen.dart';
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

  Rx<PaymentGatewayModel?> paymentGateway = Rx<PaymentGatewayModel?>(null);

  @override
  onInit() {
    super.onInit();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchPaymentMethods();
  }

  void fetchPaymentMethods() async {
    final token =
        await _authController.loadUserAndToken(); // uses your getToken method
    // String? name = _authController.user['name'];
    String tokenValue = _authController.token.value;

    if (tokenValue.isEmpty) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/pg-details'),
        headers: {
          'Authorization': 'Bearer $tokenValue',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        paymentGateway.value = PaymentGatewayModel.fromJson(data);
      } else {
        Get.snackbar('Error', 'Failed to fetch PaymentMethods');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch PaymentMethods : $e');
    } finally {
      isLoading.value = false;
    }
  }

  late String currentOrderId;

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // You can also verify the payment with your backend here
    orderPaymentStatusUpdate(currentOrderId,"SUCCESS",response.orderId,"ONLINE",);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final pg = paymentGateway.value;

    orderPaymentStatusUpdate(currentOrderId,"FAILED",pg!.key??"0","ONLINE",);

    // Get.back();
    Get.snackbar("Payment Failed", "Order Successful. Payment Failed!");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet Selected", response.walletName ?? "External Wallet");
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

    var forprint = jsonEncode(body);
    print(forprint);

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

      print(response.body);
      print("${ApiService.baseUrl}/api/orders");
      print(body);
      print(tokenValue);
      isLoading.value = false;

      if (response.statusCode == 200) {
        cartController.clearCart();
        final responseData = jsonDecode(response.body);
        final orderId = responseData['_id']; // this is your actual order ID

        if (selectedPaymentMethod.value == "Cash on Delivery") {
          Get.off(() => OrderSuccessPage(orderId: orderId));
        } else {
          // Online Payment via Razorpay
          final pg = paymentGateway.value;
          if(pg!=null){

            if(pg.name=="razorpay"){
              ///pg.key=="KEY"
              var options = {
                'key': 'rzp_test_GmmmCvqA3JxAlP', // replace with your test key
                'amount': cartController.total * 100, // in paise
                'name': 'Sonovision Electronics Pvt. Ltd.',
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
            }
          }


          // Store the orderId in a variable accessible to the success handler
          currentOrderId = orderId;
        }
      } else {
        // Get.snackbar("Error", "Failed to place order: ${response.body}");
        Get.defaultDialog(
            title: "Error",
            content: Text("Failed to place order: ${response.body}"),
            confirm: TextButton(
              child: const Text("OK"),
              onPressed: () {
                Get.back();
              },
            ));
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Error", "An error occurred: $e");
      Get.defaultDialog(
          title: "Error",
          content: Text("Failed to place order: ${e}"),
          confirm: TextButton(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
            },
          ));
    }
  }


  Future<void> orderPaymentStatusUpdate(String currentOrderId, String paymentStatus, String? paymentOrderId, String paymentType) async {
    final cartController = Get.put(CartController());
    final token =
        await _authController.loadUserAndToken(); // uses your getToken method
    String tokenValue = _authController.token.value;


    final body = {
      "orderId": currentOrderId,
      "paymentStatus": paymentStatus,
      "paymentId": paymentOrderId,
      "paymentType": paymentType,
    };

    var forprint = jsonEncode(body);
    print(forprint);

    try {
      isLoading.value = true;

      final response = await http.put(
        Uri.parse("${ApiService.baseUrl}/api/orders/payment-status"),
        headers: {
          'Authorization': 'Bearer $tokenValue',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print(response.body);
      print("${ApiService.baseUrl}/api/orders/payment-status");
      print(body);
      print(tokenValue);
      isLoading.value = false;

      if (response.statusCode == 200) {
        // Get.to(() => OrderSuccessPage(orderId: currentOrderId));

        cartController.clearCart();
        final responseData = jsonDecode(response.body);
        final orderId = responseData['_id']; // this is your actual order ID
        //
        if (paymentStatus == "SUCCESS") {
          Get.off(() => OrderSuccessPage(orderId: currentOrderId));
        } else {
          Get.off(() => const OrderScreen());
        }
      } else {
        // Get.snackbar("Error", "Failed to place order: ${response.body}");
        Get.defaultDialog(
            title: "Error",
            content: Text("Failed to place order: ${response.body}"),
            confirm: TextButton(
              child: const Text("OK"),
              onPressed: () {
                Get.back();
              },
            ));
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Error", "An error occurred: $e");
      Get.defaultDialog(
          title: "Error",
          content: Text("Failed to place order: ${e}"),
          confirm: TextButton(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
            },
          ));
    }
  }
}
class PaymentGatewayModel {
  final String name;
  final String key;

  PaymentGatewayModel({required this.name, required this.key});

  factory PaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayModel(
      name: json['name'] ?? '',
      key: json['key'] ?? '',
    );
  }
}
