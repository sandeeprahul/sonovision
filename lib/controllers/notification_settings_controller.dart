import 'package:get/get.dart';

class NotificationSettingsController extends GetxController {
  // Notification Channels
  final emailNotifications = true.obs;
  final pushNotifications = true.obs;
  final smsNotifications = false.obs;

  // Notification Types
  final promotionalOffers = true.obs;
  final orderUpdates = true.obs;
  final securityAlerts = true.obs;
  final newArrivals = false.obs;
  final priceDrops = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Simulate loading from storage/API
    await Future.delayed(Duration(milliseconds: 300));

    // Update with stored values (in a real app, these would come from shared preferences/API)
    emailNotifications.value = true;
    pushNotifications.value = true;
    smsNotifications.value = false;
    promotionalOffers.value = true;
    orderUpdates.value = true;
    securityAlerts.value = true;
    newArrivals.value = false;
    priceDrops.value = false;
  }

  // Toggle Methods
  void toggleEmailNotifications() {
    emailNotifications.toggle();
    _saveSettings();
  }

  void togglePushNotifications() {
    pushNotifications.toggle();
    _saveSettings();
  }

  void toggleSmsNotifications() {
    smsNotifications.toggle();
    _saveSettings();
  }

  void togglePromotionalOffers() {
    promotionalOffers.toggle();
    _saveSettings();
  }

  void toggleOrderUpdates() {
    orderUpdates.toggle();
    _saveSettings();
  }

  void toggleSecurityAlerts() {
    securityAlerts.toggle();
    _saveSettings();
  }

  void toggleNewArrivals() {
    newArrivals.toggle();
    _saveSettings();
  }

  void togglePriceDrops() {
    priceDrops.toggle();
    _saveSettings();
  }

  Future<void> _saveSettings() async {
    // In a real app, you would save these to shared preferences or send to API
    final settings = {
      'email': emailNotifications.value,
      'push': pushNotifications.value,
      'sms': smsNotifications.value,
      'promotional': promotionalOffers.value,
      'order_updates': orderUpdates.value,
      'security': securityAlerts.value,
      'new_arrivals': newArrivals.value,
      'price_drops': priceDrops.value,
    };

    print('Saving settings: $settings');
    // await StorageService.saveNotificationSettings(settings);
  }

  // Reset to defaults
  void resetToDefaults() {
    emailNotifications.value = true;
    pushNotifications.value = true;
    smsNotifications.value = false;
    promotionalOffers.value = true;
    orderUpdates.value = true;
    securityAlerts.value = true;
    newArrivals.value = false;
    priceDrops.value = false;
    _saveSettings();
  }
}