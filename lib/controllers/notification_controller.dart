import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList notifications = [].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
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
        'type': 'promo',//order,promo,system,message
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
        'type': "order",//message
      },
    ];
    isLoading.value = false;
  }

  void markAsRead(int id) {
    final index = notifications.indexWhere((notification) => notification['id'] == id);
    if (index != -1) {
      final notification = notifications[index];
      notification['isRead'] = true;
      notifications[index] = notification;
    }
  }
}
