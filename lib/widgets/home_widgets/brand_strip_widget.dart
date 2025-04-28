import 'package:flutter/material.dart';

class BrandStripWidget extends StatelessWidget {
  final Map<String, dynamic> style;
  final List<dynamic> data;

  const BrandStripWidget({
    super.key,
    required this.style,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: style['height']?.toDouble() ?? 120,
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
          final brand = data[index];
          return Container(
            width: 100,
            margin: EdgeInsets.only(
              right: style['spacing']?.toDouble() ?? 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Navigate using brand['deepLink']
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(
                              brand['color'].substring(1, 7),
                              radix: 16,
                            ) +
                            0xFF000000,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          brand['logo'],
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.business,
                              color: Color(
                                int.parse(
                                  brand['color'].substring(1, 7),
                                  radix: 16,
                                ) +
                                0xFF000000,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        brand['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}