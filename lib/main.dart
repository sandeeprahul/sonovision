import 'dart:io';

import 'package:electronic_store/pages/add_address_form_page.dart';
import 'package:electronic_store/pages/help_support_page.dart';
import 'package:electronic_store/pages/login_page.dart';
import 'package:electronic_store/pages/order_screen.dart';
import 'package:electronic_store/pages/product_details_page_new.dart';
import 'package:electronic_store/pages/register_page.dart';
import 'package:electronic_store/pages/settings_page.dart';
import 'package:electronic_store/screens/home_screen_two.dart';
import 'package:electronic_store/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/cart_controller.dart';
import 'controllers/notification_controller.dart';
import 'firebase_options.dart';
import 'pages/main_page.dart';
import 'package:get/get.dart';
import 'package:electronic_store/theme/app_theme.dart';
import 'controllers/home_controller.dart';
import 'repositories/home_repository.dart';
import 'pages/product_details_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
import 'pages/my_address_page.dart';
import 'pages/order_success_page.dart';
import 'pages/order_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init(); // initialize once
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // from firebase_options.dart
  );
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  Get.put(CartController(), permanent: true); // Global instance
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(NotificationController());

  runApp(const MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SonoVision Electronics',
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
      home: const SplashScreen(),
      getPages: [
        GetPage(
            name: '/product-details', page: () => const ProductDetailsScreenNew()),////ProductDetailsPage
      ],
      routes: {
        '/cart': (context) => CartPage(),
        '/main': (context) => const MainPage(),
        '/checkout': (context) => const CheckoutPage(),
        '/add-address': (context) => AddressFormPage(),
        '/my-address': (context) => const MyAddressPage(),
        '/order-success': (context) => const OrderSuccessPage(
              orderId: '0',
            ),
        '/order-history': (context) => const OrderScreen(),

        ///OrderHistoryPage
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/settings': (context) => const SettingsPage(),
        '/helpsupport': (context) => const HelpSupportPage(),
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
