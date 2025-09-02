import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';
import 'order_success_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  String? selectedAddress;
  String selectedPaymentMethod = 'Credit Card';


  final controller = Get.put(CheckoutController());
  final cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    controller.fetchAddresses();
  }
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
                Obx(
                   () {
                     if (controller.isLoading.value) {
                       return const CircularProgressIndicator();
                     }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.addresses.length,
                      itemBuilder: (context, index) {
                        final address = controller.addresses[index];
                        return Obx(
                           () {
                            return RadioListTile(
                              value: address.id.toString(),
                              activeColor: Colors.black,
                              groupValue: controller.selectedAddressId.value, // <-- use this
                              title: Text(address.name),
                              subtitle: Text(
                                '${address.addressLine1}, ${address.addressLine2}, ${address.city}, ${address.postalCode}',
                              ),
                              onChanged: (value) {
                                controller.selectedAddressId.value = value;

                                controller.selectedAddress.value =
                                    controller.addresses.firstWhere((addr) => addr.id == value);
                                print("SELECTED ADDRESS ID");
                                print(controller.selectedAddress.value!.id);
                                },
                            );
                          }
                        );
                      },
                    );
                  }
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.offNamed( '/add-address');
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
            content: Obx(
               () {
                 final controller = Get.put(CheckoutController());
                return Column(
                  children: [
                    RadioListTile(
                      value: 'Credit Card',
                      groupValue: controller.selectedPaymentMethod.value,
                      title: const Text('Credit Card'),
                      subtitle: const Text('Visa, MasterCard, RuPay'),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedPaymentMethod.value = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      value: 'UPI',
                      groupValue: controller.selectedPaymentMethod.value,
                      title: const Text('UPI'),
                      subtitle: const Text('Google Pay, PhonePe, Paytm'),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedPaymentMethod.value = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      value: 'Net Banking',
                      groupValue: controller.selectedPaymentMethod.value,
                      title: const Text('Net Banking'),
                      subtitle: const Text('All major banks supported'),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedPaymentMethod.value = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      value: 'Cash on Delivery',
                      groupValue: controller.selectedPaymentMethod.value,
                      title: const Text('Cash on Delivery'),
                      subtitle: const Text('Pay when you receive'),
                      onChanged: (value) {
                        setState(() {
                          controller.selectedPaymentMethod.value = value.toString();
                        });
                      },
                    ),
                  ],
                );
              }
            ),
            isActive: _currentStep >= 1,
          ),

          // Order Review Step
          Step(
            title: const Text('Review Order'),
            content: Obx(
              () {
                final controller = Get.put(CheckoutController());
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                     Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.selectedAddress.value!.name),
                            Text(controller.selectedAddress.value!.addressLine1),
                            Text(controller.selectedAddress.value!.addressLine2),
                            // Text('${controller.selectedAddress.value!.}'),
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
                        title: Text(controller.selectedPaymentMethod.value),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                       () {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Subtotal'),
                                    Text(cartController.subtotal.toStringAsFixed(2)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discount'),
                                    Text(cartController.discount.toStringAsFixed(2)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                 Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Delivery'),
                                    Text(cartController.deliveryCharge.toStringAsFixed(2)),
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
                                      cartController.total.toStringAsFixed(2),
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  ],
                );
              }
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
            onPressed: () async {

              // final controller = Get.put(CheckoutController());
              // if (controller.selectedPaymentMethod.value == "Cash on Delivery") {
              //   Get.off(() => OrderSuccessPage(orderId: orderId));
              // }

             await controller.placeOrder();
             Navigator.pop(context);
             // Navigator.pop(context);


            },
            child: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}
