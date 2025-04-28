import 'package:flutter/material.dart';

class CategoryGridWidget extends StatelessWidget {
  final String label;
  final Map<String, dynamic> style;
  final List<dynamic> data;

  const CategoryGridWidget({
    super.key,
    required this.label,
    required this.style,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(style['padding']?.toDouble() ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: style['columns'] ?? 4,
              childAspectRatio: style['aspectRatio']?.toDouble() ?? 1.0,
              crossAxisSpacing: style['spacing']?.toDouble() ?? 12,
              mainAxisSpacing: style['spacing']?.toDouble() ?? 12,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final category = data[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to category
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(
                          category['color'].substring(1, 7),
                          radix: 16,
                        ) +
                        0xFF000000,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              category['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.category);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}