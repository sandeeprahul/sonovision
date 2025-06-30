import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[50],
      backgroundColor: Colors.white,

      appBar: AppBar(
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
// class NotificationsPageddd extends StatelessWidget {
//   NotificationsPage({Key? key}) : super(key: key);
//
//   final NotificationController controller = Get.put(NotificationController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text(
//           'Notifications',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Obx(() => controller.isLoading.value
//           ? Center(
//               child: CircularProgressIndicator(
//                 color: Theme.of(context).primaryColor,
//                 strokeWidth: 3,
//               ),
//             )
//           : controller.notifications.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.notifications_off_outlined,
//                         size: 80,
//                         color: Theme.of(context).primaryColor.withOpacity(0.5),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No notifications yet',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[800],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'You\'re all caught up!',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   itemCount: controller.notifications.length,
//                   itemBuilder: (context, index) {
//                     final notification = controller.notifications[index];
//                     final isRead = notification['isRead'];
//
//                     return  AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.easeOut,
//                       margin: const EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context)
//                             .colorScheme
//                             .surfaceContainerHigh,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Theme.of(context)
//                                 .colorScheme
//                                 .shadow
//                                 .withOpacity(0.1),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16),
//                    /*       onTap: () =>
//                               controller.markAsRead(notification['id']),*/
//                           onTap: () {
//                             print(notification['type']);
//                             //notification['type']
//                             if(notification['type'] == 'order'){
//                               Get.offNamed('/order-history');
//                             }else{
//                               Get.back();
//                             }
//                           },
//                           splashFactory: InkSparkle.splashFactory,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Notification icon with status
//                                 AnimatedContainer(
//                                   duration: const Duration(milliseconds: 300),
//                                   width: 48,
//                                   height: 48,
//                                   decoration: BoxDecoration(
//                                     color: isRead
//                                         ? Theme.of(context)
//                                         .colorScheme
//                                         .surfaceVariant
//                                         : Theme.of(context)
//                                         .colorScheme
//                                         .primaryContainer,
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     _getNotificationIcon(
//                                         notification['type']),
//                                     size: 24,
//                                     color: isRead
//                                         ? Theme.of(context)
//                                         .colorScheme
//                                         .onSurfaceVariant
//                                         : Theme.of(context)
//                                         .colorScheme
//                                         .onPrimaryContainer,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//
//                                 // Notification content
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       // Title row with time and status
//                                       Row(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               notification['title'],
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .titleMedium
//                                                   ?.copyWith(
//                                                 fontWeight: isRead
//                                                     ? FontWeight.w500
//                                                     : FontWeight.w700,
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .onSurface,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 8),
//                                           Text(
//                                             timeago
//                                                 .format(notification['time']),
//                                             style: Theme.of(context)
//                                                 .textTheme
//                                                 .labelSmall
//                                                 ?.copyWith(
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .onSurfaceVariant,
//                                             ),
//                                           ),
//                                           if (!isRead) ...[
//                                             const SizedBox(width: 8),
//                                             Container(
//                                               width: 8,
//                                               height: 8,
//                                               decoration: BoxDecoration(
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .primary,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           ],
//                                         ],
//                                       ),
//                                       const SizedBox(height: 4),
//
//                                       // Message
//                                       Text(
//                                         notification['message'],
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium
//                                             ?.copyWith(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .onSurfaceVariant,
//                                           height: 1.4,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//
//                                       // Actions (if any)
//                                       if (notification['hasAction'] ?? false)
//                                         _buildActionButtons(
//                                             context, notification),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//     );
//   }
//
//   // Helper function to get appropriate icon
//   IconData _getNotificationIcon(String type) {
//     switch (type) {
//       case 'order':
//         return Icons.shopping_bag_rounded;
//       case 'promo':
//         return Icons.local_offer_rounded;
//       case 'system':
//         return Icons.settings_rounded;
//       case 'message':
//         return Icons.chat_bubble_rounded;
//       default:
//         return Icons.notifications_rounded;
//     }
//   }
//
// // Action buttons builder
//   Widget _buildActionButtons(
//       BuildContext context, Map<String, dynamic> notification) {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         if (notification['action1'] != null)
//           FilledButton.tonal(
//             style: FilledButton.styleFrom(
//               minimumSize: const Size(0, 36),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               print(notification['type']);
//               //notification['type']
//               if(notification['type'] == 'order'){
//                 Get.offNamed('/order-history');
//               }
//             },
//             child: Text(notification['action1']['label']),
//           ),
//         if (notification['action2'] != null)
//           OutlinedButton(
//             style: OutlinedButton.styleFrom(
//               minimumSize: const Size(0, 36),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               side: BorderSide(
//                 color: Theme.of(context).colorScheme.outline,
//               ),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: () {
//               print(notification['type']);
//               //notification['type']
//               if(notification['type'] == 'order'){
//                 Get.offNamed('/order-history');
//               }
//             },            child: Text(notification['action2']['label']),
//           ),
//       ],
//     );
//   }
// }
