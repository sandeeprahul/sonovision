import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permissions
    await _firebaseMessaging.requestPermission();

    // Foreground messages (app open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundNotification(message);
    });

    // App opened from background notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // App opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleForegroundNotification(RemoteMessage message) {
    // Show a dialog or in-app banner
    Get.dialog(
      AlertDialog(
        title: Text(message.notification?.title ?? 'Notification'),
        content: Text(message.notification?.body ?? ''),
        actions: [TextButton(onPressed: () => Get.back(), child: Text('OK'))],
      ),
    );

    // Or use flutter_local_notifications for heads-up style
  }


  void _handleNotificationTap(RemoteMessage message) {
    // Navigate based on data payload
    final data = message.data;
    if (data['screen'] == 'profile') {
      Get.toNamed('/profile', arguments: {'id': data['id']});
    } else if (data['screen'] == 'chat') {
      Get.toNamed('/chat', arguments: {'roomId': data['roomId']});
    }
    // Add more routes as needed
  }
}