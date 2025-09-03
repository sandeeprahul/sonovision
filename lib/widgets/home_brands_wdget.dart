import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../modern_screen_brands_products.dart';

// Brand Model
class Brand {
  final String id;
  final String name;
  final String image;
  final String color;
  final Gradient gradient;
  final String count;
  final String deepLink;

  Brand({
    required this.id,
    required this.name,
    required this.image,
    required this.color,
    required this.gradient,
    required this.count,
    required this.deepLink,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      color: json['color'],
      gradient: LinearGradient(
        colors: [
          Color(int.parse(json['gradient']['start'].replaceAll('#', '0xFF'))),
          Color(int.parse(json['gradient']['end'].replaceAll('#', '0xFF'))),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      count: json['count'],
      deepLink: json['deepLink'],
    );
  }
  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      color: map['color'] ?? '#FFFFFF',
      gradient: LinearGradient(
        colors: [
          _hexToColor(map['gradient']?['start'] ?? '#FFFFFF'),
          _hexToColor(map['gradient']?['end'] ?? '#FFFFFF'),
        ],
      ),
      count: map['count'] ?? '',
      deepLink: map['deepLink'] ?? '',
    );
  }
  // Helper to convert hex to Color
  static Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}


//  final rawList = group['data']?['data'] ?? [];
// Main Widget
class BrandGrid extends StatefulWidget {
 final Map<String, dynamic> group;
  const BrandGrid({Key? key, required this.group}) : super(key: key);

  @override
  State<BrandGrid> createState() => _BrandGridState();
}

class _BrandGridState extends State<BrandGrid> {

  @override
  Widget build(BuildContext context) {
    final rawList = widget.group['data']?['data'];
    final brands = (rawList is List)
        ? rawList.map((item) => Brand.fromMap(item as Map<String, dynamic>)).toList()
        : <Brand>[];

    return SizedBox(
      height: 240,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  'Discover top brands',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 0),
                        blurRadius: 8.0,
                        color: Colors.black.withOpacity(0.17),

                      ),
                    ],

                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => AllBrandsScreen(brands: brands), transition: Transition.rightToLeft);
                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),



              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  return BrandCard(brand: brands[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Brand Card Widget
class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to brand products
        // Get.toNamed(brand.deepLink);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  ModernCategoryScreen(brandId: brand.id,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: CachedNetworkImage(
          imageUrl: brand.image,
          placeholder: (context, url) => CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.grey[300]),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.business),
        ),
      ),
    );
  }
}

class AllBrandsScreen extends StatefulWidget {
  final List<Brand> brands;
  const AllBrandsScreen({Key? key, required this. brands}) : super(key: key);

  @override
  State<AllBrandsScreen> createState() => _AllBrandsScreenState();
}

class _AllBrandsScreenState extends State<AllBrandsScreen> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Brands',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // You can change this to 3 for a different layout
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: widget.brands.length,
          itemBuilder: (context, index) {
            return BrandCard(brand: widget. brands[index]);
          },
        ),
      )
    );
  }
}