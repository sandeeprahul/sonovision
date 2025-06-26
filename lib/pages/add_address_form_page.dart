import 'dart:convert';

import 'package:electronic_store/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../services/api_service.dart';

class AddressFormPage extends StatefulWidget {
  @override
  _AddressFormPageState createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name = 'Home';
  String? _type = 'Home Address';
  String? _addressLine1;
  String? _addressLine2;
  String? _city;
  String? _postalCode;

  var latitude = 0.0;
  var longitude = 0.0;

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        print('Full Address: ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}');

        setState(() {
          _addressLine1 = place.street;
          _addressLine2 = place.subLocality;
          _city = place.locality;
          _postalCode = place.postalCode;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Address'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSegmentedControl(),
                  const SizedBox(height: 12),
                  _buildTextField(Icons.location_on, 'Door no,Street', (val) => _addressLine1 = val),

                  _buildTextField(Icons.location_city, 'Landmark,Area,District', (val) => _addressLine2 = val),

                  _buildTextField(Icons.map, 'City', (val) => _city = val),

                  _buildTextField(Icons.local_post_office, 'Postal Code', (val) => _postalCode = val),


                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('SUBMIT'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, Function(String) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }


  Widget _buildSegmentedControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoSegmentedControl<String>(
          children: const {
            'Home': Padding(padding: EdgeInsets.all(8), child: Text('Home')),
            'Work': Padding(padding: EdgeInsets.all(8), child: Text('Work')),
          },
          onValueChanged: (val) => setState(() => _name = val),
          groupValue: _name,
          borderColor: Colors.black,
          selectedColor: Colors.black,
          unselectedColor: Colors.white,
          pressedColor: Colors.grey[200],
        ),
      ],
    );
  }


  void _submitForm() async {
    await _getCurrentLocation();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final addressData = {
        "name": _name,
        "type": "$_name Address",
        "addressLine1": _addressLine1,
        "addressLine2": _addressLine2,
        "city": _city,
        "postalCode": _postalCode,
        "latitude": latitude,
        "longitude": longitude,
      };

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
          body: jsonEncode(addressData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Address submitted successfully')),
          );
          Get.back();
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
  }
}
