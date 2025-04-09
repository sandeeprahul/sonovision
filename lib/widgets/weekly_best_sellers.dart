import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeeklyBestSellers extends StatelessWidget {
  const WeeklyBestSellers({super.key});

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
                'Weekly Best Sellers',
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
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildBestSellerItem(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-black-select-202309?wid=800&hei=800&fmt=jpeg&qlt=90&.v=1692991293617',
              title: 'iPhone 15 Pro Max',
              rating: 4.9,
              reviews: 1289,
              price: 1099,
              originalPrice: 1199,
              onFavorite: () {},
            ),
            _buildBestSellerItem(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQD83?wid=572&hei=572&fmt=jpeg&qlt=95&.v=1660803972361',
              title: 'AirPods Pro 2nd Gen',
              rating: 4.8,
              reviews: 856,
              price: 249,
              originalPrice: 279,
              onFavorite: () {},
            ),
            _buildBestSellerItem(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQDY3ref_VW_34FR+watch-49-titanium-ultra_VW_34FR_WF_CO+watch-face-49-alpine-ultra_VW_34FR_WF_CO?wid=750&hei=712&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1683224241054',
              title: 'Apple Watch Ultra',
              rating: 4.85,
              reviews: 543,
              price: 799,
              originalPrice: 899,
              onFavorite: () {},
            ),
            _buildBestSellerItem(
              image: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/macbook-air-space-gray-select-201810?wid=904&hei=840&fmt=jpeg&qlt=80&.v=1633027804000',
              title: 'MacBook Air M2',
              rating: 4.95,
              reviews: 721,
              price: 1199,
              originalPrice: 1299,
              onFavorite: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBestSellerItem({
    required String image,
    required String title,
    required double rating,
    required int reviews,
    required double price,
    required double originalPrice,
    required VoidCallback onFavorite,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
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
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: AppTheme.ratingStyle,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviews review)',
                        style: AppTheme.ratingStyle,
                      ),
                    ],
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
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppTheme.greyColor,
              ),
              onPressed: onFavorite,
            ),
          ],
        ),
      ),
    );
  }
} 