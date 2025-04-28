import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Map<String, dynamic> style;

  const SearchWidget({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style['height']?.toDouble() ?? 56,
      margin: EdgeInsets.all(style['margin']?.toDouble() ?? 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(style['borderRadius']?.toDouble() ?? 12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(style['borderRadius']?.toDouble() ?? 12),
          onTap: () {
            // Navigate to search screen
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  style['placeholder'] ?? 'Search products...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: Colors.grey[700],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}