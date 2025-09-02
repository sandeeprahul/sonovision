

import 'dart:ui';

import 'package:electronic_store/price_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controllers/brand_controller.dart';
import '../models/product_of_brands.dart';
import '../utils/background_container_gradient.dart';





class PriceRange {
  final String id;
  final int min;
  final int max;
  final String label;

  PriceRange({
    required this.id,
    required this.min,
    required this.max,
    required this.label,
  });
}


///"http://sonovision.asquare.org.in/images/${category.icon}",

// class BrandsCategoriesScreen extends StatefulWidget {
//   const BrandsCategoriesScreen({super.key});
//
//   @override
//   State<BrandsCategoriesScreen> createState() => _BrandsCategoriesScreenState();
// }
//
// class _BrandsCategoriesScreenState extends State<BrandsCategoriesScreen> {
//   final BrandController controller = Get.put(BrandController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     controller.fetchBrand("68b2409ea98929799d4cc92e");
//
//     return Scaffold(
//      /* appBar: AppBar(
//         title: const Text(
//           '',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//
//       ),*/
//       body: BackgroundContainerGradient(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Obx(
//              () {
//                if (controller.isLoading.value) {
//                  return const Center(child: CircularProgressIndicator());
//                }
//
//                if (controller.errorMessage.isNotEmpty) {
//                  return Center(child: Text(controller.errorMessage.value));
//                }
//
//                if (controller.brand.value == null) {
//                  return const Center(child: Text("No data available"));
//                }
//                final brand = controller.brand.value!;
//
//                return ListView.builder(
//                  padding: const EdgeInsets.all(10),
//                  itemCount: brand.categories.length,
//                  itemBuilder: (context, index) {
//                    final category = brand.categories[index];
//                    return CategorySection(category: category);
//                  },
//                );
//             }
//           ),
//         ),
//       ),
//     );
//   }
// }

class CategorySection extends StatelessWidget {
  final Category category;

  const CategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),      // width: double.infinity,
      // padding: EdgeInsets.all(16),
   /*   decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),*/
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Category name + total products + See All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(category: category),
                      ),
                    );
                  },
                  child: Text("See all (${category.products.length})"),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Price ranges horizontal list
            if (category.priceRanges.isNotEmpty) ...[
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.priceRanges.length,
                  itemBuilder: (context, index) {
                    final priceRange = category.priceRanges[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Center(
                        child: Text(
                          priceRange.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Products horizontal list
            if (category.products.isNotEmpty)
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: category.products.length,
                  itemBuilder: (context, index) {
                    final product = category.products[index];
                    return Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 16),
                      child: ProductCard(product: product),
                    );
                  },
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No products available",
                  style: TextStyle(color: Colors.grey),
                ),
              ),

            // const Divider(height: 32, thickness: 1),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(product.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Product name
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Price
            Text(
              "₹${product.price}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Price ranges carousel
            const Text(
              'Price Ranges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.category.priceRanges.length,
                itemBuilder: (context, index) {
                  final priceRange = widget.category.priceRanges[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Center(
                      child: Text(
                        priceRange.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Products carousel
            const Text(
              'Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            widget.category.products.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No products available in this category'),
              ),
            )
                : SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.category.products.length,
                itemBuilder: (context, index) {
                  final product = widget.category.products[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: ProductCard(product: product),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(product.images[0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Product name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Product price
            Text(
              '₹${product.price}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1428A0),
              ),
            ),
            const SizedBox(height: 4),
            // Discount badge
            if (product.discountPercentage != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.discountPercentage}% OFF',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/

IconData _getIconForCategory(String categoryName) {
  switch (categoryName) {
    case 'Mobile Phones':
      return Icons.smartphone;
    case 'Laptops':
      return Icons.laptop;
    case 'Televisions':
      return Icons.tv;
    case 'Refrigerators':
      return Icons.kitchen;
    case 'Washing Machines':
      return Icons.local_laundry_service;
    case 'Air Conditioners':
      return Icons.ac_unit;
    default:
      return Icons.category;
  }
}
