import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _buildSettingTile(Icons.person_outline, "Account", "Update personal info"),
          _buildSettingTile(Icons.lock_outline, "Privacy & Security", "Manage passwords & privacy"),
          _buildSettingTile(Icons.notifications_outlined, "Notifications", "Push, Email preferences"),
          _buildSettingTile(Icons.language, "Language", "Select app language"),
          _buildSettingTile(Icons.info_outline, "About", "App version, legal info"),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate to respective settings screen
      },
    );
  }
}
