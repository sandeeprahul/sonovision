import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../pages/category_list_screen.dart';

Widget buildCategoryGroupWidget(Map<String, dynamic> group) {
  final rawList = group['data']?['data'] ?? [];

  final categories = List<Map<String, dynamic>>.from(rawList);
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final itemWidth = (screenWidth - (5 * 16)) / 4;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  group['label'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the CategoryListScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryListScreen(
                          categories: categories,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(6),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: itemWidth,
                height: itemWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: itemWidth * 0.8,
                      height: itemWidth * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: category['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
