import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SaleTimer extends StatelessWidget {
  final DateTime endTime;

  const SaleTimer({
    super.key,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final difference = endTime.difference(now);
        
        if (difference.isNegative) {
          return const Text('Sale Ended');
        }

        final hours = difference.inHours;
        final minutes = difference.inMinutes.remainder(60);
        final seconds = difference.inSeconds.remainder(60);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeBox(hours.toString().padLeft(2, '0'), 'HRS'),
            const SizedBox(width: 8),
            _buildTimeBox(minutes.toString().padLeft(2, '0'), 'MIN'),
            const SizedBox(width: 8),
            _buildTimeBox(seconds.toString().padLeft(2, '0'), 'SEC'),
          ],
        );
      },
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.titleStyle.copyWith(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTheme.subtitleStyle.copyWith(
              color: AppTheme.primaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 