import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class QuickAccess extends StatelessWidget {
  const QuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.phone_android,
        'label': 'Phones',
        'color': AppTheme.primaryColor,
      },
      {
        'icon': Icons.laptop,
        'label': 'Laptops',
        'color': AppTheme.secondaryColor,
      },
      {
        'icon': Icons.headphones,
        'label': 'Audio',
        'color': AppTheme.accentColor,
      },
      {
        'icon': Icons.watch,
        'label': 'Watches',
        'color': Colors.purple,
      },
      {
        'icon': Icons.camera_alt,
        'label': 'Cameras',
        'color': Colors.red,
      },
      {
        'icon': Icons.memory,
        'label': 'Accessories',
        'color': Colors.teal,
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Shop by Category',
              style: AppTheme.titleStyle.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: category['color'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              // color: category['color'].withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 10,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          category['icon'],
                          color: category['color'],
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'asdfasdfasd',
                        // category['label'],
                        style: AppTheme.subtitleStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 