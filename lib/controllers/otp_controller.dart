import 'dart:async';
import 'dart:convert';
import 'package:electronic_store/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/auth_service.dart';

class OtpController extends GetxController {
  // Reactive variables
  final phoneController = TextEditingController().obs;

  final isLoading = false.obs;
  final otpSent = false.obs;
  final isVerified = false.obs;
  final errorMessage = ''.obs;
  final resendTimer = 0.obs;
  final phone = ''.obs;
  String? _verificationId;

  // Timer reference
  Timer? _timer;

  // API endpoints
  static const String baseUrl = ApiService.baseUrl;
  final String sendOtpUrl = '$baseUrl/api/auth/send-otp';
  final String verifyOtpUrl = '$baseUrl/api/auth/verify-otp';

  // Send OTP method
  Future<void> sendOtp() async {
    try {
      AuthController authController = Get.put(AuthController());
      await authController.loadUserAndToken();
      String tokenValue = authController.token.value;
      // String userId = authController.user.value['_id'];
      if (tokenValue.isEmpty) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }
      if (phoneController.value.text.length < 10) {
        errorMessage.value = 'Enter valid phone number';
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      print(tokenValue);
      print(phoneController.value.text.length);
      print(phoneController.value.text);
      final response = await http.post(
        Uri.parse(sendOtpUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },
        // body: jsonEncode({'phone':'8977771266'}),
        body: jsonEncode({'phone': phoneController.value.text}),
      );
      print(response);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        phone.value = phoneController.value.text;
        otpSent.value = true;
        _verificationId = responseData['verification_id'];
        startResendTimer();
        Get.snackbar(
          'OTP Sent',
          'Verification code sent',
          // 'Verification code sent to ${phoneController.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print(responseData);
        errorMessage.value = responseData['message'] ?? 'Failed to send OTP';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Verify OTP method
  Future<void> verifyOtp(String otp) async {
    try {
      AuthController authController = Get.put(AuthController());
      await authController.loadUserAndToken();
      String tokenValue = authController.token.value;
      String userId = authController.user.value['_id'];
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tokenValue',
        },        body: jsonEncode({'otp': otp}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isVerified.value = true;
        _clearTimer();
        Get.snackbar(
          'Success',
          'Phone number verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/main'); // Navigate after verification
      } else {
        errorMessage.value = responseData['message'] ?? 'Invalid OTP';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Verification failed: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Resend OTP method
  Future<void> resendOtp() async {
    if (resendTimer.value > 0) return;

    await sendOtp();
  }

  // Timer methods
  void startResendTimer([int seconds = 30]) {
    resendTimer.value = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void _clearTimer() {
    _timer?.cancel();
    resendTimer.value = 0;
  }

  @override
  void onClose() {
    _clearTimer();
    super.onClose();
  }
}