import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../controllers/checkout_controller.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class MyAddressPage extends StatefulWidget {
  const MyAddressPage({Key? key}) : super(key: key);

  @override
  _MyAddressPageState createState() => _MyAddressPageState();
}

class _MyAddressPageState extends State<MyAddressPage> {
  final _formKey = GlobalKey<FormState>();

 final controller = Get.put(CheckoutController());

  @override
  void initState() {
    super.initState();
    controller.fetchAddresses();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Address')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.addresses.isEmpty) {
                return const Center(child: Text('No addresses found.'));
              }

              return ListView.builder(
                itemCount: controller.addresses.length,
                itemBuilder: (context, index) {
                  final address = controller.addresses[index];
                  final isSelected = controller.selectedAddress.value?.id == address.id;

                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => controller.selectedAddress.value = address,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.shade50 : Colors.white,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // _rowText(Icons.person, address.name),
                              Row(
                                children: [
                                  Icon(Icons.person, size: 18, color: Colors.grey.shade700),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(address.name, style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold))),
                                ],
                              ),
                              const SizedBox(height: 6),

                              _rowText(Icons.home, address.addressLine1),
                              _rowText(Icons.location_city, address.addressLine2),
                              _rowText(Icons.place, '${address.city}, ${address.postalCode}'),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                                      onPressed: () => _showEditBottomSheet(context, address),

                                      child: const Text("Edit", style: TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      onPressed: () => _confirmDelete(context, address.id),

                                      child: const Text("Delete", style: TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  Get.toNamed('/add-address');
                }, child: const Text('ADD NEW ADDRESS'))),
          ),
        ],
      ),
    );
  }
  void _showEditBottomSheet(BuildContext context, AddressModel address) {
    final nameController = TextEditingController(text: address.name);
    final line1Controller = TextEditingController(text: address.addressLine1);
    final line2Controller = TextEditingController(text: address.addressLine2);
    final cityController = TextEditingController(text: address.city);
    final postalController = TextEditingController(text: address.postalCode);

    Get.bottomSheet(
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Edit Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: line1Controller, decoration: const InputDecoration(labelText: 'Address Line 1')),
              TextField(controller: line2Controller, decoration: const InputDecoration(labelText: 'Address Line 2')),
              TextField(controller: cityController, decoration: const InputDecoration(labelText: 'City')),
              TextField(controller: postalController, decoration: const InputDecoration(labelText: 'Postal Code')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final newData = {
                    "name": nameController.text,
                    "type": "${nameController.text} Address",
                    "addressLine1": line1Controller.text,
                    "addressLine2": line2Controller.text,
                    "city": cityController.text,
                    "postalCode": postalController.text,
                    "latitude": 0.0, // Update if needed
                    "longitude": 0.0, // Update if needed
                  };
                  // controller.(address.id, newData);
                  // _submitForm(newData);
                },
                child: const Text("Update Address"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
  var latitude = 0.0;
  var longitude = 0.0;

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        print('Full Address: ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}');

        setState(() {
          // _addressLine1 = place.street;
          // _addressLine2 = place.subLocality;
          // _city = place.locality;
          // _postalCode = place.postalCode;
        });
      }
    } catch (e) {
      print('Failed to get address: $e');
    }
  }


  Future<void> _getCurrentLocation() async {
    // Request location permission
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        // Use platform-specific location settings
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        );
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        _getAddressFromLatLng(latitude, longitude);



      } catch (e) {
        Get.snackbar('Error', 'Could not get location: $e');
      }
    } else if (status.isDenied) {
      Get.defaultDialog(
        title: "Permission Denied",
        middleText: "Location permission is required to get your current position.",
        confirm: ElevatedButton(
          onPressed: () {
            openAppSettings(); // Open settings to enable manually
            Get.back();
          },
          child: const Text("Open Settings"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        title: "Permission Permanently Denied",
        middleText: "Please enable location permission from app settings.",
        confirm: ElevatedButton(
          onPressed: () {
            openAppSettings();
            Get.back();
          },
          child: const Text("Open Settings"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      );
    }
  }

  void _submitForm(Map<String, Object> newData) async {
    await _getCurrentLocation();


      final url = Uri.parse(
          '${ApiService.baseUrl}/api/address'); // Replace with your API base URL

      AuthController authController = Get.put(AuthController());
      await authController.loadUserAndToken();
      final tokenValue = authController.token.value;
      try {
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $tokenValue"
          },
          body: jsonEncode(newData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address submitted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                Text('Failed to submit. Status: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }

  }


  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // controller.deleteAddress(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  Widget _rowText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}



//   }
