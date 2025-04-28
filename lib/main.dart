import 'package:electronic_store/screens/home_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic_store/theme/app_theme.dart';
import 'controllers/home_controller.dart';
import 'repositories/home_repository.dart';
import 'pages/product_details_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/add_address_page.dart';
import 'pages/order_success_page.dart';
import 'pages/order_history_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Electronic Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreenTwo(),
      routes: {
      /*  '/product-details': (context) => ProductDetailsPage(
              product: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),*/
        '/product-details': (context) => ProductDetailsPage(
          product: Get.arguments as Map<String, dynamic>,
        ),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/add-address': (context) => const AddAddressPage(),
        '/order-success': (context) => const OrderSuccessPage(),
        '/order-history': (context) => const OrderHistoryPage(),
      },
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepository());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
