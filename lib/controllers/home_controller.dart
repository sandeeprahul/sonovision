import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';
import '../utils/version_alert.dart';

class HomeController extends GetxController {
  final Rx<Map<String, dynamic>> homeData = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>> nearestStore = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
    loadStores();
  }

  final ApiService _apiService = ApiService();

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      error.value = '';

      final jsonData = await _apiService.getHomeData();
      homeData.value = jsonData;
      if (homeData.value.isNotEmpty) {
        if (homeData.value['version'].isNotEmpty) {
          if (homeData.value['version'] != '1.0.0') {
            showUpdateDialog();
          }
        }
      }
    } catch (e) {
      error.value = 'Failed to load home data: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHomeData() async {
    await loadHomeData();
  }

  Future<void> loadStores() async {
    try {
      isLoading.value = true;
      error.value = '';

      final storesData = await _apiService.getStores();
      stores.value = List<Map<String, dynamic>>.from(storesData);

      // Initialize nearest store if we have location data
      if (stores.isNotEmpty) {
        // You can call findNearestStore() here if you already have user location
        // findNearestStore();
      }
    } catch (e) {
      error.value = 'Failed to load stores: ${e.toString()}';
      print('Failed to load stores: ${e.toString()}');
      stores.value = []; // Reset stores on error
    } finally {
      isLoading.value = false;
    }
  }

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxString addressLine1 = "".obs;

  /// Call this method to get location and update nearest store
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      error.value = '';
      var status = await Permission.location.request();

      if (status.isGranted) {
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        );

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        //16.501927, 80.642784
        // latitude.value = 16.501927;
        // longitude.value = 80.642784;
 latitude.value = position.latitude;
        longitude.value = position.longitude;

        // Call to find nearest store (you need to define this)
        findNearestStore(latitude.value, longitude.value);

        if (nearestStore.value.isNotEmpty) {
          addressLine1.value = "Nearest store: ${nearestStore.value['name']}";
        } else {
          addressLine1.value = "No nearby stores found";
        }
      } else if (status.isDenied) {
        _showPermissionDialog(
          title: "Permission Denied",
          message:
              "Location permission is required to get your current position.",
        );
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          title: "Permission Permanently Denied",
          message: "Please enable location permission from app settings.",
        );
      }
    } catch (e) {
      error.value = 'Could not get location:  ${e.toString()}';
      Get.snackbar('Error', 'Could not get location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showPermissionDialog({required String title, required String message}) {
    Get.defaultDialog(
      title: title,
      middleText: message,
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
  } // Function to find nearest store

  void findNearestStore(double userLat, double userLng) {
    try {
      // Filter out stores with invalid coordinates (0,0)
      final validStores = stores
          .where((store) => store['latitude'] != 0 && store['longitude'] != 0)
          .toList();

      if (validStores.isEmpty) {
        nearestStore.value = {};
        return;
      }

      // Calculate distances and find nearest
      Map<String, dynamic> nearest = validStores.reduce((a, b) {
        final distanceA =
            _calculateDistance(userLat, userLng, a['latitude'], a['longitude']);
        final distanceB =
            _calculateDistance(userLat, userLng, b['latitude'], b['longitude']);
        return distanceA < distanceB ? a : b;
      });

      // Add distance to the nearest store info
      nearest['distance'] = _calculateDistance(
          userLat, userLng, nearest['latitude'], nearest['longitude']);

      nearestStore.value = nearest;
    } catch (e) {
      error.value = 'Error finding nearest store: ${e.toString()}';
    }
  }

  // Haversine formula to calculate distance between two coordinates
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius of the earth in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c; // Distance in km
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (pi / 180);
  }
}
