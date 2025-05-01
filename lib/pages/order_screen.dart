// screens/order_screen.dart

import 'package:flutter/material.dart';
import '../services/order_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

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
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final products = order['products'] as List;

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Order #${order['_id'].toString().substring(0, 8)}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.black)),
                          Chip(
                            label: Text(order['status']),
                            backgroundColor: _getStatusColor(order['status']),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${order['address']['addressLine1']}, ${order['address']['city']}",
                              style: const TextStyle(fontSize: 14,color: Colors.black),
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
                                    placeholder: (context, url) => const SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product['name'],
                                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14,color: Colors.black)),
                                      Text("Qty: ${item['quantity']}", style: const TextStyle(fontSize: 12, color: Colors.black)),
                                    ],
                                  ),
                                ),
                                Text("₹${product['price']}",
                                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14,color: Colors.black)),
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
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.black)),
                          Text("₹${order['total']}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Processing':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
