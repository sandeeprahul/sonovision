import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example order data
    final List<Map<String, dynamic>> orders = [
      {
        'orderId': 'ORD1682512345',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'status': 'Delivered',
        'items': [
          {
            'name': 'Galaxy S24',
            'quantity': 1,
            'price': 150000.0,
            'image': 'https://sonovision.in/wp-content/uploads/2022/08/samsung-s225g-white.jpg',
          }
        ],
        'total': 135000.0,
      },
      // Add more orders as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text('No orders yet'),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text('Order #${order['orderId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          timeago.format(order['date']),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        _buildOrderStatusChip(order['status']),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Items',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: order['items'].length,
                              itemBuilder: (context, itemIndex) {
                                final item = order['items'][itemIndex];
                                return ListTile(
                                  leading: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Image.network(
                                      item['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(item['name']),
                                  subtitle: Text(
                                    'Qty: ${item['quantity']} × ₹${item['price']}',
                                  ),
                                );
                              },
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '₹${order['total']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildOrderTimeline(order['status']),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOrderStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'delivered':
        color = Colors.green;
        break;
      case 'shipped':
        color = Colors.blue;
        break;
      case 'processing':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  Widget _buildOrderTimeline(String currentStatus) {
    final List<Map<String, dynamic>> stages = [
      {
        'title': 'Order Placed',
        'subtitle': 'Your order has been placed',
        'icon': Icons.shopping_cart,
        'completed': true,
      },
      {
        'title': 'Processing',
        'subtitle': 'Your order is being processed',
        'icon': Icons.assignment,
        'completed': currentStatus != 'Order Placed',
      },
      {
        'title': 'Shipped',
        'subtitle': 'Your order is on the way',
        'icon': Icons.local_shipping,
        'completed': currentStatus == 'Shipped' || currentStatus == 'Delivered',
      },
      {
        'title': 'Delivered',
        'subtitle': 'Your order has been delivered',
        'icon': Icons.check_circle,
        'completed': currentStatus == 'Delivered',
      },
    ];

    return Column(
      children: [
        const Text(
          'Order Timeline',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stages.length,
          itemBuilder: (context, index) {
            final stage = stages[index];
            return ListTile(
              leading: Icon(
                stage['icon'],
                color: stage['completed'] ? Colors.green : Colors.grey,
              ),
              title: Text(stage['title']),
              subtitle: Text(stage['subtitle']),
              trailing: stage['completed']
                  ? const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }
}
