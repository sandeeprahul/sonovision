import 'package:electronic_store/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/api_service.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  final RxBool isLoading = false.obs;

  final RxList<MyNotification> notifications = <MyNotification>[].obs;
  final RxString errorMessage = ''.obs;

  final RxString fcmToken = ''.obs;
  final RxString registeredTokenId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _initFCMToken();
  }
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/api/notifications'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        notifications.assignAll(
          data.map((json) => MyNotification.fromJson(json)).toList(),
        );
        // Sort by date (newest first)
        notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching notifications: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  void markAsRead(String notificationId) {
    // Here you would typically call an API to mark as read
    // For now, we'll just update locally
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      // In a real app, you might have a 'read' property to update
      notifications.refresh();
    }
  }

  void clearAll() {
    // Here you would typically call an API to clear all
    notifications.clear();
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
  Future<void> registerTokenToServerToUserId() async {
    try {
      final token =
      await AuthController.to.loadUserAndToken(); // uses your getToken method
      String tokenValue = AuthController.to.token.value;
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/fcm-tokens'),
        headers: {
          'Authorization': 'Bearer $tokenValue',
          'Content-Type': 'application/json'},
        body: jsonEncode({
          'fcm_token': fcmToken.value,
          'device_os': 'android',
          'os_version': '12',
          'app_version': '1.0.0',
          'user_id': AuthController.to.user.value['_id'],//registeredTokenId
        }),
      );

      print({
        'fcm_token': fcmToken.value,
        'device_os': 'android',
        'os_version': '12',
        'app_version': '1.0.0',
        'user_id': AuthController.to.user.value['_id'],//registeredTokenId
      });
      print('${ApiService.baseUrl}/api/fcm-tokens');
      print('${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // registeredTokenId.value = data['_id']; // Replace 'id' with your field
        print('✅ registerTokenToServerToUserId, ID: $data');
      } else {
        print('❌ registerTokenToServerToUserId: API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Server error: $e');
    }
  }



}

class MyNotification {
  final String id;
  final String title;
  final String message;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final String? userId;

  MyNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.payload,
    required this.createdAt,
    this.userId,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      id: json['_id'],
      title: json['title'],
      message: json['message'],
      payload: json['payload'] is Map ? json['payload'] : {},
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['user_id'],
    );
  }
}