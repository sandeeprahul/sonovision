// screens/order_screen.dart

import 'package:electronic_store/extensions.dart';
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
      appBar: AppBar(title: const Text("My Orders")),
      body: FutureBuilder<List<dynamic>>(
        future: OrderService.fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final orders = snapshot.data!;
          final sortedOrders = orders
              .where((o) => o['createdAt'] != null)
              .toList()
            ..sort((a, b) =>
                (b['createdAt'] as Comparable).compareTo(a['createdAt']));
          return ListView.separated(
            // reverse: true,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final order = sortedOrders[index];
              final products = order['products'] as List;
              final statusColor = _getStatusColor(order['status']);

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
                        Theme.of(context)
                            .colorScheme
                            .surfaceContainerHigh
                            .withOpacity(0.6),
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
                            // Header with dynamic status indicator
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Order ID with decorative accent
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ORDER #${order['_id'].toString().substring(0, 8)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              letterSpacing: 1.2,
                                              color: Colors.black,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${order['createdAt']?.toString().toFormattedDate ?? ''}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                          color: Colors.black,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Animated status pill
                                // const SizedBox(width: 20),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor( order['status']),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: statusColor.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    order['status'].toString().toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Product carousel with peek effect
                            SizedBox(
                              height: 140,
                              child: Stack(
                                children: [
                                  ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: products.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(width: 12),
                                    itemBuilder: (ctx, idx) {
                                      final item = products[idx];
                                      final product = item['product'];
                                      return _buildProductCard(
                                          context, product, item['quantity']);
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
                                            Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHigh
                                                .withOpacity(0),
                                            Theme.of(context)
                                                .colorScheme
                                                .surfaceContainerHigh,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Delivery address with map pin
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerLow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.pin_drop_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Delivery Address",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${order['address']['addressLine1']}, ${order['address']['city']}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Order summary with dynamic total
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  /* _buildSummaryRow(context, "Subtotal", "₹${order['subtotal']}"),
                                  const SizedBox(height: 8),
                                  _buildSummaryRow(context, "Shipping", "₹${order['shipping']}"),
                                  const Divider(height: 24, thickness: 0.8),*/
                                  _buildSummaryRow(
                                    context,
                                    "Total",
                                    "₹${order['total']}",
                                    isTotal: true,
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final products = order['products'] as List;

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Order #${order['_id'].toString().substring(0, 8)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black)),
                          Chip(
                            side: const BorderSide(color: Colors.transparent),
                            label: Text(order['status']),
                            backgroundColor: _getStatusColor(order['status']),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${order['address']['addressLine1']}, ${order['address']['city']}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.calendar_month,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${order['createdAt']?.toString().toFormattedDate}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 1),
                      // Product list
                      Column(
                        children: products.map((item) {
                          final product = item['product'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: product['images'][0],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.black)),
                                      Text("Qty: ${item['quantity']}",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text("₹${product['price']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.black)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const Divider(height: 24, thickness: 1),
                      // Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Total: ",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          Text("₹${order['total']}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
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
