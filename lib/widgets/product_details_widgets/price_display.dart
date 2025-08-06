import 'package:electronic_store/extensions.dart';
import 'package:electronic_store/price_extensions.dart';
import 'package:flutter/material.dart';


class PriceDisplay extends StatelessWidget {
  final double originalPrice;
  final double discountedPrice;
  final double discountPercentage;

  const PriceDisplay({
    super.key,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          discountedPrice.toINR(),//.toStringAsFixed(0)
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        if (discountPercentage > 0) ...[
          Text(
            originalPrice.toINR(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.black,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${discountPercentage.toStringAsFixed(0)}% OFF',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

        ],

      ],
    );
  }
}