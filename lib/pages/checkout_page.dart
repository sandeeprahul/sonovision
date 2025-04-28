import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  String? selectedAddress;
  String selectedPaymentMethod = 'Credit Card';

  final List<Map<String, String>> addresses = [
    {
      'id': '1',
      'name': 'John Doe',
      'address': '123 Main St, Apt 4B',
      'city': 'New York',
      'state': 'NY',
      'zip': '10001',
      'phone': '(555) 123-4567',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Place order
            _showOrderConfirmation();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: [
          // Delivery Address Step
          Step(
            title: const Text('Delivery Address'),
            content: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return RadioListTile(
                      value: address['id'],
                      groupValue: selectedAddress,
                      title: Text(address['name']!),
                      subtitle: Text(
                        '${address['address']}, ${address['city']}, ${address['state']} ${address['zip']}\n${address['phone']}',
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = value as String;
                        });
                      },
                    );
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-address');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Address'),
                ),
              ],
            ),
            isActive: _currentStep >= 0,
          ),

          // Payment Method Step
          Step(
            title: const Text('Payment Method'),
            content: Column(
              children: [
                RadioListTile(
                  value: 'Credit Card',
                  groupValue: selectedPaymentMethod,
                  title: const Text('Credit Card'),
                  subtitle: const Text('Visa, MasterCard, RuPay'),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  value: 'UPI',
                  groupValue: selectedPaymentMethod,
                  title: const Text('UPI'),
                  subtitle: const Text('Google Pay, PhonePe, Paytm'),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  value: 'Net Banking',
                  groupValue: selectedPaymentMethod,
                  title: const Text('Net Banking'),
                  subtitle: const Text('All major banks supported'),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  value: 'Cash on Delivery',
                  groupValue: selectedPaymentMethod,
                  title: const Text('Cash on Delivery'),
                  subtitle: const Text('Pay when you receive'),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value.toString();
                    });
                  },
                ),
              ],
            ),
            isActive: _currentStep >= 1,
          ),

          // Order Review Step
          Step(
            title: const Text('Review Order'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe'),
                        Text('123 Main St, Apt 4B'),
                        Text('New York, NY 10001'),
                        Text('(555) 123-4567'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.payment),
                    title: Text(selectedPaymentMethod),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'),
                            Text('₹150000'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount'),
                            Text('-₹15000'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery'),
                            Text('₹0'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '₹135000',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: const Text('Are you sure you want to place this order?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/order-success',
                (route) => false,
              );
            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
