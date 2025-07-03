// screens/order_screen.dart

import 'package:electronic_store/extensions.dart';
import 'package:electronic_store/utils/background_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/order_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(title: const Text("My Orders")),
      body: BackgroundContainer(
        child: FutureBuilder<List<dynamic>>(
          future: OrderService.fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final orders = snapshot.data!;
            if(orders.isEmpty){
              return Center(
                child: (
                  Text('No orders found',style: TextStyle(fontSize: 18,color: Colors.black),)
            ),
              );
            }
            final sortedOrders = orders
                .where((o) => o['createdAt'] != null)
                .toList()
              ..sort((a, b) => (b['createdAt'] as Comparable).compareTo(a['createdAt']));

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                final order = sortedOrders[index];
                final products = order['products'] as List;
                final statusColor = _getStatusColor(order['status']);
                final isCompleted = order['status'] == 'Completed';

                return PhysicalModel(
                  color: Colors.transparent,
                  elevation: 0,
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.surfaceContainerHigh.withOpacity(0.6),
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                        ],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(28),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(28),
                        // onTap: () => _handleOrderTap(context, order),
                        splashFactory: InkSparkle.splashFactory,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header with order ID and status
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order ID with decorative accent
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ORDER #${order['_id'].toString()}",
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                            letterSpacing: 1.2,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Placed on ${order['createdAt']?.toString().toFormattedDate ?? ''}",
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Status chip with animation
                                  TweenAnimationBuilder(
                                    duration: const Duration(milliseconds: 400),
                                    tween: ColorTween(
                                      begin: Colors.transparent,
                                      end: statusColor.withOpacity(0.16),
                                    ),
                                    builder: (_, color, __) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: statusColor.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                          order['status']=="Pending"?"PROCESSING":order['status'].toString().toUpperCase(),
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          color: statusColor,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Product carousel
                              SizedBox(
                                height: 140,
                                child: Stack(
                                  children: [
                                    ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: products.length,
                                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                                      itemBuilder: (ctx, idx) {
                                        final item = products[idx];
                                        final product = item['product'];
                                        return _buildProductCard(context, product, item['quantity']);
                                      },
                                    ),

                                    // Gradient edge fade
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Theme.of(context).colorScheme.surfaceContainerHigh.withOpacity(0),
                                              Theme.of(context).colorScheme.surfaceContainerHigh,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Delivery address
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.pin_drop_rounded,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Delivery Address",
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${order['address']['addressLine1']}, ${order['address']['city']}",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Order total
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _buildSummaryRow(
                                  context,
                                  "Total",
                                  "₹${order['total']}",
                                  isTotal: true,
                                ),
                              ),

                              // Rating section for completed orders
                              if (isCompleted) ...[
                                const SizedBox(height: 10),
                                _buildRatingSection(context, order),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
// Add this new widget for rating
  Widget _buildRatingSection(BuildContext context, Map<String, dynamic> order) {
    final rating =  3; // Default to 0 if no rating exists
    // final rating = order['rating'] ?? 0; // Default to 0 if no rating exists

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24, thickness: 0.8),
        Text(
          'Rate Your Order',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StarRating(
                rating: rating.toDouble(),
                onRatingChanged: (newRating) {

                  _submitRating(order['_id'], newRating);
                },
                starSize: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (rating > 0)
              Text(
                '${rating.toStringAsFixed(1)}/5',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ],
    );
  }
// Status color helper (updated for Material 3)
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.redAccent;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColodr(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

// Vibrant status colors
  Color _getStatusVibrantColor(String status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status.toLowerCase()) {
      case 'Delivered':
        return scheme.tertiary;
      case 'Pending':
        return scheme.secondary;
      case 'Completed':
        return scheme.primary;
      case 'Cancelled':
        return scheme.error;
      default:
        return scheme.outline;
    }
  }

// Product card widget
  Widget _buildProductCard(
      BuildContext context, dynamic product, int quantity) {
    return SizedBox(
      width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with quantity badge
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: product['images'][0],
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag_rounded,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "×$quantity",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Product name and price
          Text(
            product['name'],
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "₹${product['price']}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

// Summary row helper
  Widget _buildSummaryRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }
}
// StarRating widget (custom implementation)
class StarRating extends StatelessWidget {
  final double rating;
  final void Function(double) onRatingChanged;
  final double starSize;
  final Color color;

  const StarRating({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 24,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => onRatingChanged(index + 1.0),
          child: Icon(
            index < rating.floor() ? Icons.star_rounded :
            (index < rating.ceil() ? Icons.star_half_rounded : Icons.star_border_rounded),
            size: starSize,
            color: color,
          ),
        );
      }),
    );
  }
}

// Helper function to submit rating
void _submitRating(String orderId, double rating) {
  // Implement your rating submission logic here
  // Example: call API to update order rating
  print('Rating $rating submitted for order $orderId');
}