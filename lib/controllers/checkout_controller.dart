import 'package:electronic_store/services/api_service.dart';
import 'package:electronic_store/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final isLoading = false.obs;
  final selectedAddressId = RxnString();

  Future<void> fetchAddresses() async {
    ApiService apiService = ApiService();
    AuthService authService  = AuthService();
    final token = await authService.getToken(); // uses your getToken method

    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/api/address'),  headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },);
      print("${ApiService.baseUrl}/api/address");
      print(response.statusCode);
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
}
