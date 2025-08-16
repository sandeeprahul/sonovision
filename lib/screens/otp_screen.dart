import 'package:electronic_store/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../theme/app_theme.dart';

class OtpScreen extends StatelessWidget {
  final OtpController otpController = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: AppTheme.appbarGradientBlue),
        ),
        title: const Text('', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading:   IconButton(
          onPressed: () => Get.toNamed('/main'),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [

        ],
      ),
      // backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          height: Get.height - 50,
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  // Animated Back Button
                  // _buildAnimatedBackButton(),
                  const SizedBox(height: 40),

                  // Header Section
                  _buildHeaderSection(),
                  const SizedBox(height: 40),

                  // Dynamic Content (Phone Input or OTP)
                  if (!otpController.otpSent.value) _buildPhoneInputSection(),
                  if (otpController.otpSent.value)
                    _buildOtpVerificationSection(),

                  const Spacer(),

                  // Footer Graphics
                  // _buildFooterGraphics(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: otpController.otpSent.value
          ? IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
              onPressed: () {
                otpController.otpSent.value = false;
                otpController.errorMessage.value = '';
              },
            )
          : const SizedBox(),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          otpController.otpSent.value ? 'Verify OTP' : 'Enter Phone',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          otpController.otpSent.value
              ? 'We sent a 6-digit code to ${otpController.phone.value}'
              : 'We\'ll send a verification code',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection() {
    return Column(
      children: [
        // Neumorphic Phone Input
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[50],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: otpController.phoneController.value,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              prefixIcon: Container(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('+91', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                  ],
                ),
              ),
              hintText: 'Phone Number',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Animated Submit Button
        SizedBox(
          width: double.infinity,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[400]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Obx(() {
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: otpController.isLoading.value
                      ? null
                      : () => otpController.sendOtp(),
                  child: Center(
                    child: otpController.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpVerificationSection() {
    return Column(
      children: [
        // OTP Input Fields
        PinCodeTextField(
          appContext: Get.context!,
          length: 6,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 60,
            fieldWidth: 50,
            activeFillColor: Colors.white,
            activeColor: Colors.blue,
            selectedColor: Colors.blue,
            inactiveColor: Colors.grey[300],
          ),
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          onCompleted: (value) => otpController.verifyOtp(value),
          onChanged: (value) {},
          beforeTextPaste: (text) => false,
        ),
        const SizedBox(height: 32),

        // Verify Button
        SizedBox(
          width: double.infinity,
          child: Material(
            borderRadius: BorderRadius.circular(16),
            elevation: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => otpController.verifyOtp(''),
              // Will be handled by auto-complete
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  child: otpController.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Resend OTP
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code?",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: otpController.resendTimer.value > 0
                  ? null
                  : otpController.resendOtp,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                otpController.resendTimer.value > 0
                    ? 'Resend in ${otpController.resendTimer.value}s'
                    : 'Resend now',
                style: TextStyle(
                  color: otpController.resendTimer.value > 0
                      ? Colors.grey
                      : Colors.blue[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterGraphics() {
    return Column(
      children: [
        if (otpController.errorMessage.value.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    otpController.errorMessage.value,
                    style: TextStyle(color: Colors.red[600]),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
