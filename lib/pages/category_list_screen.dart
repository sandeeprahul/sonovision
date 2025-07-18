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
      // appBar: AppBar(
      //
      //   title: const Text('Categories'),
      //     leading: IconButton(onPressed: (){
      //       Get.back();
      //     }, icon: const Icon(CupertinoIcons.back)),
      //     flexibleSpace: Container(
      //       decoration: BoxDecoration(
      //         color: Colors.white,
      //       /*  gradient: LinearGradient(
      //           colors: [
      //             Colors.black,
      //             Colors.black.withOpacity(0.5),
      //             Colors.black.withOpacity(0.05),
      //           ],
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //         ),*/
      //       ),
      //     ),
      //     backgroundColor: Colors.transparent, // Make background transparent to see gradient
      //     elevation: 0,
      // ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(CupertinoIcons.back,color: Colors.black,)),
                ),
                Align(
                  alignment: Alignment.center,

                  child: Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
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
