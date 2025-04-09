// import 'package:electronic_store/screens/home_screen_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:electronic_store/widgets/home_screen_two.dart';
import 'package:electronic_store/theme/app_theme.dart';
import 'controllers/home_controller.dart';
import 'repositories/home_repository.dart';

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
