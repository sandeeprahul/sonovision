import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_page.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;

  const OrderSuccessPage({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final orderId = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10)}';
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                'Order Placed Successfully!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Order ID: $orderId',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Thank you for your purchase',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Get.offAllNamed( '/order-history');
                  Get.offAndToNamed( '/order-history');

                },
                child: const Text('View Order History'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {

                  // Get.offNamedUntil('/main', (route) => false);
                  Get.off(()=>const MainPage());

                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
