// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../models/product_of_brands.dart';
//
// class BrandController extends GetxController {
//   var brand = Rxn<Brand>();
//   var isLoading = false.obs;
//   var errorMessage = "".obs;
//
//   Future<void> fetchBrand(String brandId) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = "";
//
//       final response = await http.get(
//         Uri.parse("https://sonovision.asquare.org.in/api/brands/$brandId"),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         brand.value = Brand.fromJson(data);
//       } else {
//         errorMessage.value =
//         "Failed to load brand (Status: ${response.statusCode})";
//       }
//     } catch (e) {
//       errorMessage.value = "Error: $e";
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
