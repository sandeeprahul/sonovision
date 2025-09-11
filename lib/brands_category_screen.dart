import 'dart:convert';
import 'dart:ui';

import 'package:electronic_store/models/product_of_brands.dart';
import 'package:electronic_store/pages/category_details_page.dart';
import 'package:electronic_store/pages/products_from_brand_category_screen.dart';
import 'package:electronic_store/price_extensions.dart';
import 'package:electronic_store/utils/background_container_gradient.dart';
import 'package:electronic_store/widgets/filters_grid_widget.dart';
import 'package:electronic_store/widgets/price_range_carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';

// Mock classes to make the code work (replace with your actual implementations)
class BrandsCategoryScreen extends StatefulWidget {
  final String brandId;

  const BrandsCategoryScreen({super.key, required this.brandId});

  @override
  _BrandsCategoryScreenState createState() => _BrandsCategoryScreenState();
}

class _BrandsCategoryScreenState extends State<BrandsCategoryScreen> {
  final BrandController controller = Get.put(BrandController());

  final isDark = false;

  @override
  void initState() {
    super.initState();
    controller.fetchBrand(widget.brandId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue.shade200,
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

          return BackgroundContainerGradient(
            child: Container(
              padding: const EdgeInsets.only(bottom: 16),
            /*  decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),*/
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
                            icon: const Icon(Icons.arrow_back_ios,color: Colors.white,)),
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
                            color: Colors.white,
                            // color: Color(0xFF1A73E8),
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
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ListView.builder(
                          itemCount: categories.length,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              // spacing between items
                              child: _buildCategoryCard(category, brand),
                            );
                          },
                        ) /*GridView.builder(
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
                          return _buildCategoryCard(category,brand);
                        },
                      ),*/
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryCard(Category category, Brand brand) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductsFromBrandCategoryScreen(
              categoryId: category.id,
              categoryName: category.name,
              imageUrl:
                  "http://sonovision.asquare.org.in/images/${category.icon}",
              brandName: brand.name,
              brandId: brand.id,
            ),
          ),
        );
      },
      child: Container(
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
                    /*    Image.network(
                      "http://sonovision.asquare.org.in/images/${category.icon}",
                      fit: BoxFit.cover,
                    ),

                    // Blur Effect
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3,),
                      child: Container(
                        color: Colors.white
                            .withOpacity(0.5), // Optional dark overlay
                      ),
                    ),*/
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
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                          radius: 16,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "http://sonovision.asquare.org.in/images/${category.icon}",
                              height: 26,
                              width: 26,
                              fit: BoxFit.cover,
                            ),
                          )),
                      SizedBox(width: 6,),
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),
                      Container(
                        // width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [Color(0xFF1F1F1F), Color(0xFF2C2C2E)]
                                : [Color(0xFF4A90E2), Color(0xFF007AFF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: isDark ? Colors.white10 : Colors.transparent,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "VIEW ALL",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Text(
                    // textAlign: TextAlign.center,
                    "Prices from",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),
                  PriceRangeCarousel(
                      priceRanges: category.priceRanges, category: category, brand: brand,),

                  _buildCompactFiltersGrid(category.filters, category),

                  // // Products Horizontal List
                  // if (category.products.isNotEmpty) ...[
                  //   // const SizedBox(height: 4),
                  //   Visibility(
                  //     visible: false,
                  //     child: SizedBox(
                  //       height: 98,
                  //       child: ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: category.products.length,
                  //         itemBuilder: (context, index) {
                  //           final product = category.products[index];
                  //
                  //           final value =
                  //               num.tryParse(product.price.toString());
                  //           final formattedSubtitle = value != null
                  //               ? value.toINR() // your extension
                  //               : product.price.toString();
                  //           return InkWell(
                  //             onTap: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       ProductsFromBrandCategoryScreen(
                  //                     categoryId: category.id,
                  //                     categoryName: category.name,
                  //                     imageUrl:
                  //                         "http://sonovision.asquare.org.in/images/${category.icon}",
                  //                         brandId: brand.id,
                  //                         brandName: brand.name,
                  //                         filterId: ,
                  //                   ),
                  //                 ),
                  //               );
                  //             },
                  //             child: Container(
                  //               width: 80,
                  //               margin: const EdgeInsets.only(right: 8),
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white.withOpacity(0.9),
                  //                 borderRadius: BorderRadius.circular(8),
                  //               ),
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   // Product image
                  //                   if (product.images.isNotEmpty)
                  //                     Container(
                  //                       height: 50,
                  //                       width: 50,
                  //                       decoration: BoxDecoration(
                  //                         borderRadius:
                  //                             BorderRadius.circular(8),
                  //                         image: DecorationImage(
                  //                           image:
                  //                               NetworkImage(product.images[0]),
                  //                           fit: BoxFit.cover,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   const SizedBox(height: 4),
                  //
                  //                   // Product name
                  //                   Padding(
                  //                     padding: const EdgeInsets.symmetric(
                  //                         horizontal: 4.0),
                  //                     child: Text(
                  //                       product.name,
                  //                       style: const TextStyle(
                  //                         fontSize: 10,
                  //                         fontWeight: FontWeight.w600,
                  //                       ),
                  //                       maxLines: 1,
                  //                       overflow: TextOverflow.ellipsis,
                  //                       textAlign: TextAlign.center,
                  //                     ),
                  //                   ),
                  //
                  //                   // Product price
                  //                   /*    Text(
                  //                     formattedSubtitle,
                  //                     style: TextStyle(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.bold,
                  //                       color: Colors.blue.shade800,
                  //                     ),
                  //                   ),*/
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ],

                  // ElevatedButton(onPressed: (){}, child: Text('See all')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactFiltersGrid(List<Filter> filters, Category category) {
    final displayedFilters =
        filters.where((filter) => filter.showInUi).toList();

    if (displayedFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 6),
            child: Text(
              "Key Features",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: displayedFilters
                .map((filter) => _buildFilterChip(filter, category))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(Filter filter, Category category,) {
    final List<FilterValue> displayValues = filter.values.take(2).toList();
    final hasMore = filter.values.length > 2;

    return Tooltip(
      message: filter.label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              filter.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            if (displayValues.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ":",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Make each value clickable
                  ...displayValues.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index > 0)
                          Text(
                            ", ",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductsFromBrandCategoryScreen(
                                  categoryId: category.id,
                                  categoryName: category.name,
                                  imageUrl:
                                      "http://sonovision.asquare.org.in/images/${category.icon}",
                                  brandName: category.name,
                                  filterId: value.id,
                                  // Pass the specific filter value ID
                                  filterTitle: filter.label,
                                  brandId: widget.brandId,
                                      selectedFilters: [value],
                                      allFilters:filter.values ,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            value.value,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  if (hasMore)
                    Text(
                      " +${filter.values.length - 2}",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

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
