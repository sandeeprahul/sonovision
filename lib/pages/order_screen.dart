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
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order ID: ${order['_id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Status: ${order['status']}", style: const TextStyle(color: Colors.blue)),
                      const SizedBox(height: 8),
                      Text("Total: ₹${order['total']}"),
                      const SizedBox(height: 8),
                      Text("Delivery Address: ${order['address']['addressLine1']}, ${order['address']['city']}"),
                      const SizedBox(height: 12),
                      ...products.map((item) {
                        final product = item['product'];
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: CachedNetworkImage(
                            imageUrl: product['images'][0],
                            width: 60,
                            height: 60,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          title: Text(product['name']),
                          subtitle: Text("Qty: ${item['quantity']}"),
                          trailing: Text("₹${product['price']}"),
                        );
                      }).toList()
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
}
