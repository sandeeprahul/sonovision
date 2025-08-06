// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// class CategoryListScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> categories;
//
//   CategoryListScreen({required this.categories});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Categories'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             childAspectRatio: 1.0,
//           ),
//           itemCount: categories.length,
//           itemBuilder: (context, index) {
//             final category = categories[index];
//             return GestureDetector(
//               onTap: () {
//                 // Navigate to a detailed category page (optional)
//                 Navigator.pushNamed(
//                   context,
//                   '/categoryDetails', // Replace with your route
//                   arguments: category,
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   // color: Colors.white,
//                  /* boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 6,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],*/
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: CachedNetworkImage(
//                         imageUrl: category['image'],
//                         fit: BoxFit.cover,
//                         width: 200,
//                         height: 120,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       category['name'],
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${category['count']}+',
//                       style: const TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:electronic_store/utils/background_container_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../models/category.dart';
import 'category_details_page.dart';

class CategoryListScreen extends StatelessWidget {
  final List<Category> categories;

  const CategoryListScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0,right: 12),
          child: Column(
            children: [
          /*    const SizedBox(
                height: 12,
              ),*/
              SizedBox(
                height: 56,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,

                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(CupertinoIcons.back,color: Colors.black,)),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12,right: 12,bottom: 12),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.90,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryRowItem(
                        name: categories[index].name,
                        image: categories[index].icon,
                        item:category
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryDetailsPage(
                                categoryId: category.id,
                                categoryName: category.name,
                                imageUrl:
                                    "http://sonovision.asquare.org.in/images/${category.icon}",
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          // height: 65,
                      /*    decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12)

                          ),*/
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                // Background Image
                                CachedNetworkImage(
                                  imageUrl:
                                      "http://sonovision.asquare.org.in/images/${category.icon}",
                                  //http://sonovision.asquare.org.in/images/kitchen_appliances.jpeg
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),

                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.6),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ),

                                // Text content
                                Positioned(
                                  left: 12,
                                  right: 12,
                                  bottom: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black45,
                                              blurRadius: 4,
                                              offset: Offset(1, 1),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      /*  Text(
                                        '${category.sortOrder}+',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),*/
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CategoryRowItem extends StatelessWidget {
  final String name;
  final String image;
  final Category item;

  const CategoryRowItem({required this.name, required this.image, required this. item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 6,right: 6),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.grey[200],
          border: Border.all(color: Colors.grey)
      ),
      //
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailsPage(
                categoryId: item.id,
                categoryName: item.name,
                imageUrl:
                "http://sonovision.asquare.org.in/images/${item.icon}",
              ),
            ),
          );
        },
        child: Row(
          children: [
            // Image on the left
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child:    ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl:
                  "http://sonovision.asquare.org.in/images/$image",
                  //http://sonovision.asquare.org.in/images/kitchen_appliances.jpeg
                  fit: BoxFit.cover,
                  width: 40,
                  height:40,
                ),
              ),/*,Image.asset(
                image,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image, size: 40),
              ),
            ),*/
            ),
            SizedBox(width: 4),
            // Category name on the right
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
            ),
            // Optional chevron icon
            // Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}