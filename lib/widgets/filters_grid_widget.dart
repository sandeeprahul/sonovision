import 'package:flutter/material.dart';

import '../models/product_of_brands.dart';

import 'package:flutter/material.dart';



class FiltersGrid extends StatelessWidget {
  final List<Filter> filters;

  const FiltersGrid({Key? key, required this.filters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayedFilters = filters.where((filter) => filter.showInUi).toList();

    if (displayedFilters.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayedFilters.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final filter = displayedFilters[index];
        final displayValues = filter.values.take(2).toList();
        final hasMore = filter.values.length > 2;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter label with optional icon
              Row(
                children: [
                  if (filter.icon != null)
                    Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(right: 6),
                      child: Image.network(
                        filter.icon!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      filter.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF333333),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Filter values
              if (displayValues.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    // Display values
                    ...displayValues.map((v) => _FilterChip(value: v.value)),
                    // More indicator if needed
                    if (hasMore)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${filter.values.length - 2} more',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                  ],
                )
              else
                Text(
                  'No values selected',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String value;

  const _FilterChip({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        // color: _getChipColor(value),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          // color: _getTextColor(value),
        ),
      ),
    );
  }
}
