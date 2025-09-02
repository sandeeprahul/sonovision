import 'dart:convert';
import 'dart:ui';

import 'package:electronic_store/models/product_of_brands.dart';
import 'package:electronic_store/price_extensions.dart';
import 'package:electronic_store/widgets/price_range_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

class _ModernCategoryScreenState extends State<ModernCategoryScreen> {
  final BrandController controller = Get.put(BrandController());

  @override
  void initState() {
    super.initState();
    controller.fetchBrand(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (controller.brand.value == null) {
            return const Center(
              child: Text(
                "No data available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final brand = controller.brand.value!;
          final categories = brand.categories;

          return Container(
            // margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header Row (Logo + Search + Profile)

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      /*     Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:Image.network(controller.brand.value.icon,height: 60,width: 60,)

                      ),*/
                      const SizedBox(width: 10),
                      // 🔹 Grid Title
                      Text(
                        brand.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                      /*    const Padding(
                        padding: EdgeInsets.only(left: 24.0, top: 8.0),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A73E8),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),

                // const SizedBox(height: 16),

                // 🔹 Categories Grid with Products and Price Ranges
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.6,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return _buildCategoryCard(category);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Category icon as background with overlay
          // Blurred Background Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image
                  Image.network(
                    "http://sonovision.asquare.org.in/images/${category.icon}",
                    fit: BoxFit.cover,
                  ),

                  // Blur Effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: Colors.black
                          .withOpacity(0.2), // Optional dark overlay
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category name
                SizedBox(
                  height: 20,
                  child:  category.name.length > 100?Marquee(
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 30.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(milliseconds: 500),
                    decelerationCurve: Curves.easeOut,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    // maxLines: 2,
                   /* overflow: TextOverflow.ellipsis,*/ text: '${ category.name}',
                  ):Text(
                    category.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  "Prices from",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Colors.black,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                PriceRangeCarousel(priceRanges: category.priceRanges),

                // Price Ranges Grid (2x2)
               /* Expanded(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: category.priceRanges.length > 4 ? 4 : 0,
                    itemBuilder: (context, index) {
                      final range = category.priceRanges[index];

                      final value = num.tryParse(range.min.toString());
                      final formattedSubtitle = value != null
                          ? value.toINR() // your extension
                          : range.min.toString();

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            formattedSubtitle,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),*/

                // const SizedBox(height: 8),

                // Products Horizontal List
                if (category.products.isNotEmpty) ...[
                  // const SizedBox(height: 4),
                  SizedBox(
                    height: 98,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: category.products.length,
                      itemBuilder: (context, index) {
                        final product = category.products[index];

                        final value = num.tryParse(product.price.toString());
                        final formattedSubtitle = value != null
                            ? value.toINR() // your extension
                            : product.price.toString();
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Product image
                              if(product.images.isNotEmpty)
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(product.images[0]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Product name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              // Product price
                              /*    Text(
                                formattedSubtitle,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),*/
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mock classes to make the code work (replace with your actual implementations)
class ModernCategoryScreen extends StatefulWidget {
  final String brandId;
  const ModernCategoryScreen({super.key, required this.brandId});

  @override
  _ModernCategoryScreenState createState() => _ModernCategoryScreenState();
}

class BrandController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var brand = Brand(id: '', name: '', icon: '', categories: []).obs;

  Future<void> fetchBrand(String brandId) async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await http.get(
        Uri.parse("https://sonovision.asquare.org.in/api/brands/$brandId"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        brand.value = Brand.fromJson(data);
      } else {
        errorMessage.value =
            "Failed to load brand (Status: ${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
