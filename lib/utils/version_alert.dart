import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Replace showDialog with Get.dialog and remove context parameter
void showUpdateDialog() {
  Get.dialog(
    AnimatedScale(
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      scale: 1,
      child: AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Get.theme.colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 24,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replace Lottie with Flutter's built-in animations
            SizedBox(
              height: 150,
              child: Icon(
                Icons.system_update_rounded,
                size: 80,
                color: Get.theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'New Version Available',
              style: Get.theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please update to the latest version to enjoy new features and improvements',
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Get.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            // Version comparison
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Current',
                        style: Get.theme.textTheme.labelSmall,
                      ),
                      Text(
                        '1.2.3',
                        style: Get.theme.textTheme.bodyLarge?.copyWith(
                          color: Get.theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Get.theme.colorScheme.onSurfaceVariant,
                  ),
                  Column(
                    children: [
                      Text(
                        'Available',
                        style: Get.theme.textTheme.labelSmall,
                      ),
                      Text(
                        '1.3.0',
                        style: Get.theme.textTheme.bodyLarge?.copyWith(
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {
                // Launch app store/play store
                Get.back(); // Replace Navigator.pop with Get.back
              },
              style: FilledButton.styleFrom(
                backgroundColor: Get.theme.colorScheme.primary,
                foregroundColor: Get.theme.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('UPDATE NOW'),
            ),
            // Later button
            TextButton(
              onPressed: () {
                Get.back(); // Replace Navigator.pop with Get.back
              },
              child: Text(
                textAlign: TextAlign.center,
                'REMIND ME LATER',
                style: TextStyle(
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        actions: const [
          // Update button

        ],
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      ),
    ),
    barrierDismissible: false, // Move to Get.dialog parameters
  );
}
Widget _buildVersionBadge(BuildContext context, {
  required String version,
  required String label,
  required bool isCurrent,
}) {
  return Column(
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrent
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          version,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}