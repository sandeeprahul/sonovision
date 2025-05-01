import 'dart:io';

import 'package:electronic_store/pages/login_page.dart';
import 'package:electronic_store/pages/register_page.dart';
import 'package:electronic_store/screens/home_screen_two.dart';
import 'package:electronic_store/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'pages/main_page.dart';
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

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init(); // initialize once
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
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
      /*   theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),*/
      home:  const SplashScreen(),
      routes: {
        /*  '/product-details': (context) => ProductDetailsPage(
              product: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),*/
        '/product-details': (context) => ProductDetailsPage(
              product: Get.arguments as Map<String, dynamic>,
            ),
        '/cart': (context) => CartPage(),
        '/': (context) => const MainPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/add-address': (context) => const AddAddressPage(),
        '/order-success': (context) =>  OrderSuccessPage(orderId: '0',),
        '/order-history': (context) => const OrderHistoryPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
