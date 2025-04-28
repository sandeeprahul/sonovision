import 'package:flutter/material.dart';

class QuickLinksWidget extends StatelessWidget {
  final Map<String, dynamic> style;
  final List<dynamic> data;

  const QuickLinksWidget({
    super.key,
    required this.style,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style['height']?.toDouble() ?? 100,
      margin: EdgeInsets.symmetric(
        vertical: style['margin']?.toDouble() ?? 16,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: style['margin']?.toDouble() ?? 16,
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return Container(
            width: 80,
            margin: EdgeInsets.only(
              right: style['spacing']?.toDouble() ?? 16,
            ),
            child: Column(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Color(int.parse(item['color'].substring(1, 7), radix: 16) + 0xFF000000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        // Handle quick link tap
                      },
                      child: Icon(
                        _getIcon(item['icon']),
                        color: Color(int.parse(item['color'].substring(1, 7), radix: 16) + 0xFF000000),
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case 'swap':
        return Icons.swap_horiz;
      case 'compare':
        return Icons.compare_arrows;
      case 'credit_card':
        return Icons.credit_card;
      default:
        return Icons.circle;
    }
  }
}