import 'package:electronic_store/utils/background_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      backgroundColor: Colors.white,

      appBar: AppBar(
        flexibleSpace: Container(
          decoration:  BoxDecoration(
              gradient: AppTheme.appbarGradientBlue
          ),
        ),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        // actions: [
        //   Obx(() => controller.notifications.isNotEmpty
        //       ? TextButton(
        //     onPressed: () => _showClearAllDialog(context),
        //     child: const Text('Clear All', style: TextStyle(color: Colors.red)),
        //   )
        //       : const SizedBox()),
        // ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchNotifications,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No notifications yet', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: controller.fetchNotifications,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return _buildNotificationCard(notification, context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(MyNotification notification, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          controller.markAsRead(notification.id);
          _showNotificationDetails(context, notification);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, hh:mm a').format(notification.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.message,
                style: const TextStyle(fontSize: 14),
              ),
              if (notification.payload.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Order ID: ${notification.payload['orderId'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, MyNotification notification) {
    showModalBottomSheet(
        context: context,
        shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext context)  {
    return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Container(
    width: 40,
    height: 4,
    decoration: BoxDecoration(
    color: Colors.grey[300],
    borderRadius: BorderRadius.circular(2),
    ),
    ),
    ),
    const SizedBox(height: 16),
    Text(
    notification.title,
    style: const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    ),
    ),
    const SizedBox(height: 8),
    Text(
    DateFormat.yMMMMd().add_jm().format(notification.createdAt),
    style: TextStyle(color: Colors.grey[600]),
    ),
    const SizedBox(height: 16),
    Text(
    notification.message,
    style: const TextStyle(fontSize: 16),
    ),
    const SizedBox(height: 16),
    if (notification.payload.isNotEmpty) ...[
    const Text(
    'Details:',
    style: TextStyle(fontWeight: FontWeight.bold),
    ),
    const SizedBox(height: 8),
    Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
    color: Colors.grey[100],
    borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: notification.payload.entries.map((entry) {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: RichText(
    text: TextSpan(
    style: DefaultTextStyle.of(context).style,
    children: [
    TextSpan(
    text: '${entry.key}: ',
    style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    TextSpan(text: entry.value.toString()),
    ],
    ),
    ),
    );
  }).toList(),
    ),
    ),
    ],
    const SizedBox(height: 24),
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    onPressed: () => Navigator.pop(context),
    child: const Text('Close'),
    ),
    ),
    ],
    ),
    );
  },
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear All Notifications'),
          content: const Text('Are you sure you want to clear all notifications?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.clearAll();
                Navigator.pop(context);
              },
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
