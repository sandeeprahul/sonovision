import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TopProducts extends StatelessWidget {
  const TopProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Products',
                style: AppTheme.titleStyle.copyWith(fontSize: 20),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      'View all',
                      style: AppTheme.subtitleStyle.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          childAspectRatio: 0.75,
          children: [
            _buildProductCard(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/ipad-pro-model-select-gallery-2-202212?wid=5120&hei=2880&fmt=p-jpg&qlt=80&.v=1667594167534',
              title: 'iPad Pro 12.9"',
              price: 1099,
              originalPrice: 1199,
              isNew: true,
              onFavorite: () {},
            ),
            _buildProductCard(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/homepod-select-midnight-202210?wid=800&hei=800&fmt=jpeg&qlt=90&.v=1670557210097',
              title: 'HomePod 2nd Gen',
              price: 299,
              originalPrice: 349,
              isOnSale: true,
              onFavorite: () {},
            ),
            _buildProductCard(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQDP3?wid=800&hei=800&fmt=jpeg&qlt=90&.v=1692936507700',
              title: 'Magic Keyboard',
              price: 179,
              originalPrice: 199,
              isOnSale: true,
              onFavorite: () {},
            ),
            _buildProductCard(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MTJV3?wid=800&hei=800&fmt=jpeg&qlt=90&.v=1694014871985',
              title: 'AirPods Max',
              price: 549,
              originalPrice: 599,
              isNew: true,
              onFavorite: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String image,
    required String title,
    required double price,
    required double originalPrice,
    bool isOnSale = false,
    bool isNew = false,
    int? discount,
    Duration? duration,
    required VoidCallback onFavorite,
  }) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                  onPressed: onFavorite,
                ),
              ),
              if (isOnSale)
                Positioned(
                  top: 8,
                  left: 8,
                  child: AppTheme.buildSaleBadge('Sale'),
                ),
              if (isNew)
                Positioned(
                  top: 8,
                  left: 8,
                  child: AppTheme.buildNewBadge(),
                ),
              if (discount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: AppTheme.buildSaleBadge('-$discount%'),
                ),
              if (duration != null)
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: AppTheme.buildCountdownTimer(duration),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.titleStyle.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$$price',
                      style: AppTheme.priceStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$$originalPrice',
                      style: AppTheme.oldPriceStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: AppTheme.buildAddButton(),
            ),
          ),
        ],
      ),
    );
  }
} 