import 'dart:convert';

import 'package:electronic_store/services/api_service.dart';
import 'package:electronic_store/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _showOtpField = false;
  bool _isLoading = false;
  int _resendTimer = 30;
  String _enteredPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    // _phoneController.dispose();
    // _otpController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber() {
    setState(() {});
  }

  void _sendOtp() {
    if (_phoneController.text.length < 10) return;

    setState(() {
      _isLoading = true;
      _enteredPhoneNumber = _phoneController.text;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _showOtpField = true;
        _startResendTimer();
      });
    });
  }

  Future<void> sendOtp(String phoneNumber) async {
    try {
      _isLoading = true;
      errorMessage.value = '';
      otpSent.value = false;

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        otpSent.value = true;
        _verificationId = responseData['verification_id']; // If API returns one
        Get.snackbar(
          'OTP Sent',
          'Verification code sent to $phoneNumber',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
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
      _isLoading = false;
    }
  }

  final otpSent = false.obs;
  final isVerified = false.obs;
  final errorMessage = ''.obs;
  String? _verificationId; // Store verification ID if needed
  final String baseUrl = ApiService.baseUrl;

  Future<void> verifyOtp(String otp) async {
    try {
      _isLoading = true;
      errorMessage.value = '';

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isVerified.value = true;
        Get.snackbar(
          'Success',
          'Phone number verified successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Handle successful verification (navigate to home, store token etc.)
        // Get.offAllNamed('/home');
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
      _isLoading = false;
    }
  }

  // Optional: Resend OTP
  Future<void> resendOtp(String phoneNumber) async {
    await sendOtp(phoneNumber);
  }
  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendTimer > 0 && mounted) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
  }

  void _verifyOtp() {
    setState(() => _isLoading = true);
    // Verification logic
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
      // Navigate to home or show success
      AuthController.to.phone.value = _enteredPhoneNumber;
      Get.offAllNamed('/main');

    });
  }

  void _resendOtp() {
    setState(() => _resendTimer = 30);
    _startResendTimer();
    // Resend OTP logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_showOtpField) {
              setState(() => _showOtpField = false);
            } else {
              Get.toNamed('/login');
              // Navigator.pop(context);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _showOtpField
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your phone number',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We\'ll send a verification code',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        padding: const EdgeInsets.only(left: 16, right: 8),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('+91', style: TextStyle(fontSize: 16)),
                            Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify your phone',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      text: 'Enter the 4-digit code sent to ',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      children: [
                        TextSpan(
                          text: _enteredPhoneNumber,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            if (_showOtpField)
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _otpController,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 64,
                  fieldWidth: 64,
                  activeFillColor: Colors.white,
                  activeColor: Theme.of(context).primaryColor,
                  selectedColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.grey[300],
                  inactiveFillColor: Colors.grey[100],
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onCompleted: (value) => _verifyOtp(),
                onChanged: (value) {},
              )
            else
              const SizedBox(),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _showOtpField
                      ? _otpController.text.length == 4 ? _verifyOtp : null
                      : _phoneController.text.length >= 10 ? _sendOtp : null,
                  child: Text(_showOtpField ? 'Verify' : 'Continue'),
                ),
              ),
            if (_showOtpField) ...[
              const SizedBox(height: 24),
              Center(
                child: _resendTimer > 0
                    ? Text(
                  'Resend code in $_resendTimer seconds',
                  style: const TextStyle(color: Colors.grey),
                )
                    : TextButton(
                  onPressed: _resendOtp,
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}