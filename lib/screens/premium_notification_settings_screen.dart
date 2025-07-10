import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/notification_settings_controller.dart';
import '../theme/app_theme.dart';

class PremiumNotificationSettings extends StatelessWidget {
  final _settings = NotificationSettingsController();

  PremiumNotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:  BoxDecoration(
              gradient: AppTheme.appbarGradientBlue
          ),
        ),
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notification Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),

            // Email Notifications
            Obx(() => _NotificationToggleCard(
              icon: Icons.email,
              title: 'Email Notifications',
              description: 'Order updates, promotions, and newsletters',
              value: _settings.emailNotifications.value,
              onChanged: (v) => _settings.toggleEmailNotifications(),
            )),
            const SizedBox(height: 16),

            // Push Notifications
            Obx(()=> _NotificationToggleCard(
              icon: Icons.notifications,
              title: 'Push Notifications',
              description: 'App alerts and time-sensitive updates',
              value: _settings.pushNotifications.value,
              onChanged: (v) => _settings.togglePushNotifications(),
            ),),

            const SizedBox(height: 16),

            Obx(()=>_NotificationToggleCard(
              icon: Icons.sms,
              title: 'SMS Alerts',
              description: 'Delivery updates and security alerts',
              value: _settings.smsNotifications.value,
              onChanged: (v) => _settings.toggleSmsNotifications(),
            ),),
            // SMS Notifications

            const SizedBox(height: 32),

            const Divider(),
            const SizedBox(height: 16),

            // Notification Types
            const Text('Notification Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            Obx(()=>   _NotificationTypeOption(
              title: 'Promotional Offers',
              value: _settings.promotionalOffers.value,
              onChanged: (v) => _settings.togglePromotionalOffers(),
            ),),

            Obx(()=>  _NotificationTypeOption(
              title: 'Order Updates',
              value: _settings.orderUpdates.value,
              onChanged: (v) => _settings.toggleOrderUpdates(),
            ),),

            Obx(()=> _NotificationTypeOption(
              title: 'Security Alerts',
              value: _settings.securityAlerts.value,
              onChanged: (v) => _settings.toggleSecurityAlerts(),
            ),),


          ],
        ),
      ),
    );
  }
}

class _NotificationToggleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationToggleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
                  const SizedBox(height: 4),
                  Text(description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.2,
              child: Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTypeOption extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const _NotificationTypeOption({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15,color: Colors.black))),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}