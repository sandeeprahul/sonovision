import 'package:flutter/material.dart';

import '../../models/product_details_data.dart';

class FiltersList extends StatelessWidget {
  final List<ProductFilter> filters;

  const FiltersList({Key? key, required this.filters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
           Text(
            'Specifications',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )),
          const SizedBox(height: 16),
          // const Divider(height: 1),
          const SizedBox(height: 16),

          // Filters List
          ...filters.map((filter) => _buildFilterItem(filter)).toList(),
        ],
      ),
    );
  }

  Widget _buildFilterItem(ProductFilter filter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key/Property name
          Expanded(
            flex: 2,
            child: Text(
              filter.key,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          // Separator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
              ),
            ),
          ),

          // Value
          Expanded(
            flex: 3,
            child: Text(
              filter.value!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,//
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getValueColor(String key) {
    if (key.isEmpty) return Colors.grey;

    final firstChar = key[0].toLowerCase();
    final charCode = firstChar.codeUnitAt(0);

    // Map character codes to a color palette
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];

    return colors[charCode % colors.length];
  }
  Color _getValueColorf(String key) {
    final lowerKey = key.toLowerCase();

    if (lowerKey.contains('screen') || lowerKey.contains('size') || lowerKey.contains('display')) {
      return Colors.blue.shade700;
    } else if (lowerKey.contains('processor') || lowerKey.contains('chip')) {
      return Colors.deepPurple.shade700;
    } else if (lowerKey.contains('ram') || lowerKey.contains('memory')) {
      return Colors.green.shade700;
    } else if (lowerKey.contains('storage') || lowerKey.contains('capacity')) {
      return Colors.orange.shade700;
    } else if (lowerKey.contains('battery')) {
      return Colors.red.shade700;
    } else if (lowerKey.contains('camera')) {
      return Colors.pink.shade700;
    } else if (lowerKey.contains('os') || lowerKey.contains('operating')) {
      return Colors.indigo.shade700;
    } else if (lowerKey.contains('network') || lowerKey.contains('sim')) {
      return Colors.cyan.shade700;
    } else if (lowerKey.contains('weight') || lowerKey.contains('thickness')) {
      return Colors.brown.shade700;
    } else if (lowerKey.contains('sensor')) {
      return Colors.teal.shade700;
    } else if (lowerKey.contains('connectivity')) {
      return Colors.lightBlue.shade700;
    } else if (lowerKey.contains('build') || lowerKey.contains('material')) {
      return Colors.blueGrey.shade700;
    } else if (lowerKey.contains('charging')) {
      return Colors.amber.shade700;
    } else if (lowerKey.contains('resolution')) {
      return Colors.purple.shade700;
    }

    return Colors.black87;
  }
}