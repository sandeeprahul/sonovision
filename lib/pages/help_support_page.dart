import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          _buildHelpItem(Icons.question_answer_outlined, "FAQs", "Find answers to common questions"),
          _buildHelpItem(Icons.chat_bubble_outline, "Chat with us", "Live support assistance"),
          _buildHelpItem(Icons.phone_outlined, "Call Us", "Customer care: +91-XXXXXX"),
          _buildHelpItem(Icons.email_outlined, "Email Support", "support@example.com"),
          _buildHelpItem(Icons.policy_outlined, "Terms & Privacy", "Legal documents"),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate to respective help section
      },
    );
  }
}
