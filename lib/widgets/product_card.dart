import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final double? width;
  final bool isHorizontal;

  const ProductCard({
    Key? key,
    required this.product,
    this.width,
    this.isHorizontal = false,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product',
        arguments: widget.product.id,
      ),
      child: Container(
        width: widget.width,
        margin: EdgeInsets.only(bottom: 16, right: widget.isHorizontal ? 0 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: widget.isHorizontal ? _buildHorizontalCard() : _buildVerticalCard(),
      ),
    );
  }

  Widget _buildVerticalCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: widget.product.imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) =>  const SizedBox(
              height: 180,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) => Container(
              height: 180,
              color: Colors.grey[200],
              child: const Icon(Icons.error_outline),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const DiscountBadge(discount: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCard() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: widget.product.imageUrl,
            height: 120,
            width: 120,
            fit: BoxFit.cover,
            placeholder: (context, url) =>  const SizedBox(
              height: 120,
              width: 120,
            ),
            errorWidget: (context, url, error) => Container(
              height: 120,
              width: 120,
              color: Colors.grey[200],
              child: const Icon(Icons.error_outline),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${widget.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const DiscountBadge(discount:20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DiscountBadge extends StatelessWidget {
  final int discount;

  const DiscountBadge({required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$discount% OFF',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

// class ShimmerLoading extends StatelessWidget {
//   final double height;
//   final double width;
//
//   const ShimmerLoading({
//     required this.height,
//     required this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         height: height,
//         width: width,
//         color: Colors.white,
//       ),
//     );
//   }
// }