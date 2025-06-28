import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/api_service.dart';

class NotificationController extends GetxController {
  final RxList notifications = [].obs;
  final RxBool isLoading = false.obs;

  final RxString fcmToken = ''.obs;
  final RxString registeredTokenId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _initFCMToken();
  }

  void fetchNotifications() {
    ///order,promo,system,message

    isLoading.value = true;
    // Temporary data
    notifications.value = [
      {
        'id': 1,
        'title': 'New Arrival',
        'message': 'Check out our latest electronics collection!',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'type': 'promo', //order,promo,system,message
      },
      {
        'id': 2,
        'title': 'Special Offer',
        'message': '20% off on all smartphones this weekend!',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'type': 'promo',
      },
      {
        'id': 3,
        'title': 'Order Update',
        'message': 'Your order #12345 has been shipped',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': true,
        'type': "order", //message
      },
    ];
    isLoading.value = false;
  }

  void markAsRead(int id) {
    final index =
        notifications.indexWhere((notification) => notification['id'] == id);
    if (index != -1) {
      final notification = notifications[index];
      notification['isRead'] = true;
      notifications[index] = notification;
    }
  }

  Future<void> _initFCMToken() async {
    try {
      // Request permissions if needed
      await FirebaseMessaging.instance.requestPermission();

      // Get the FCM token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        fcmToken.value = token;
        print('✅ FCM Token: $token');

        // Send to your backend API
        await _registerTokenToServer(token);
      }
    } catch (e) {
      print('❌ Failed to get FCM token: $e');
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      fcmToken.value = newToken;
      _registerTokenToServer(newToken);
    });
  }

  Future<void> _registerTokenToServer(String token) async {
    try {
      //https://sonovision.asquare.org.in/api/fcm-tokens
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/fcm-tokens'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fcm_token': token,
          'device_os': 'android',
          'os_version': '12',
          'app_version': '1.0.0',
          'last_opened_time': DateTime.now().toIso8601String(),
          // 'user_id': '',
        }),
      );

      print('${ApiService.baseUrl}/api/fcm-tokens');
      print('${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        registeredTokenId.value = data['_id']; // Replace 'id' with your field
        print('✅ Token registered, ID: ${registeredTokenId.value}');
      } else {
        print('❌ API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Server error: $e');
    }
  }
}
