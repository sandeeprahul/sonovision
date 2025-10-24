import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/category_controller.dart';
import '../brands_category_screen.dart';
import '../pages/category_details_page.dart';
import '../pages/category_list_screen.dart';
import 'package:get/get.dart';

import '../screens/categories_screen.dart';

Widget buildCategoryGroupWidget(Map<String, dynamic> group) {

  final rawList = group['data']?['data'] ?? [];

  final categories = List<Map<String, dynamic>>.from(rawList);
  // Ensure there's at least one item to replace
  final int visibleItemCount = categories.length > 1 ? categories.length - 1 : 0;

  return LayoutBuilder(
    builder: (context, constraints) {
      final CategoryController controller = Get.put(CategoryController());

      final screenWidth = constraints.maxWidth;
      // final itemWidth = (screenWidth - (5 * 16)) / 4;

      return Obx(
         () {
           if (controller.isLoading.value) {
             return const Center(child: CircularProgressIndicator());
           }

           final categories = controller.categories;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      group['label'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the CategoryListScreen
                     /*   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  ModernCategoryScreen(
                            ),
                          ),
                        );*//* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BrandsCategoriesScreen(
                            ),
                          ),
                        );*/   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryListScreen(
                              categories: categories,
                            ),
                          ),
                        );
                        //ApplianceStoreApp
                      },
                      child: Text(
                        'More',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 6),
             //  GridView.builder(
             //    shrinkWrap: true,
             //    physics: const NeverScrollableScrollPhysics(),
             //    padding: const EdgeInsets.all(6),
             //    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
             //      crossAxisCount: 4,
             //      childAspectRatio: 1.0,
             //      crossAxisSpacing: 6,
             //      mainAxisSpacing: 6,
             //    ),
             //    itemCount: 8, // +1 for "See All"
             //    // itemCount: categories.length, // +1 for "See All"
             //    // itemCount: categories.length,
             //    itemBuilder: (context, index) {
             // /*     if (index == visibleItemCount) {
             //        // Show "See All" tile
             //        return GestureDetector(
             //          onTap: () {
             //            Navigator.push(
             //              context,
             //              MaterialPageRoute(
             //                builder: (context) => CategoryListScreen(
             //                  categories: categories,
             //                ),
             //              ),
             //            );
             //          },
             //          child: Container(
             //            width: itemWidth,
             //            height: itemWidth,
             //            decoration: BoxDecoration(
             //              color: Colors.grey.shade100,
             //              borderRadius: BorderRadius.circular(8),
             //              border: Border.all(color: Colors.grey.shade300),
             //            ),
             //            child: Column(
             //              mainAxisAlignment: MainAxisAlignment.center,
             //              children: [
             //                Icon(Icons.grid_view_rounded,
             //                    size: itemWidth * 0.4,
             //                    color: Theme.of(context).primaryColor),
             //                const SizedBox(height: 8),
             //                Text(
             //                  'See All',
             //                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
             //                    fontWeight: FontWeight.bold,
             //                    fontSize: 11,
             //                    color: Theme.of(context).primaryColor,
             //                  ),
             //                  textAlign: TextAlign.center,
             //                ),
             //              ],
             //            ),
             //          ),
             //        );
             //      }*/
             //
             //      final category = categories[index];
             //      return InkWell(
             //        onTap: (){
             //          Navigator.push(
             //            context,
             //            MaterialPageRoute(
             //              builder: (context) => CategoryDetailsPage(
             //                categoryId: category.id,
             //                categoryName: category.name,
             //                imageUrl:  "http://sonovision.asquare.org.in/images/${category.icon}",
             //              ),
             //            ),
             //          );
             //        },
             //        child: Container(
             //          width: itemWidth,
             //          height: itemWidth,
             //          decoration: BoxDecoration(
             //            borderRadius: BorderRadius.circular(8),
             //            boxShadow: [
             //              BoxShadow(
             //                // color: Colors.black,
             //                color: Colors.black.withOpacity(0.064),
             //                blurRadius: 10,
             //                offset: const Offset(0, 5),
             //              ),
             //            ],
             //          ),
             //          child: Column(
             //            mainAxisAlignment: MainAxisAlignment.center,
             //            children: [
             //              SizedBox(
             //                width: itemWidth * 0.8,
             //                height: itemWidth * 0.8,
             //                child: ClipRRect(
             //                  borderRadius: BorderRadius.circular(8),
             //                  child: CachedNetworkImage(
             //                    imageUrl: "http://sonovision.asquare.org.in/images/${category.icon}",//http://sonovision.asquare.org.in/images/kitchen_appliances.jpeg
             //                    fit: BoxFit.cover,
             //                  ),
             //                ),
             //              ),
             //              const SizedBox(height: 8),
             //              Text(
             //                category.name,
             //                style: Theme.of(context).textTheme.labelMedium?.copyWith(
             //                  fontWeight: FontWeight.w600,
             //                  fontSize: 11,
             //                  color: Colors.black87,
             //                ),
             //                textAlign: TextAlign.center,
             //                maxLines: 1,
             //                overflow: TextOverflow.ellipsis,
             //              ),
             //            ],
             //          ),
             //        ),
             //      );
             //    },
             //  ),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(6),
                  scrollDirection: Axis.horizontal,
                  itemCount: 8, // +1 for "See All"
                  // itemCount: categories.length, // +1 for "See All"
                  // itemCount: categories.length,
                  itemBuilder: (context, index) {
                    /*if (index == visibleItemCount) {
                      // Show "See All" tile
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                builder: (context) => CategoryListScreen(
                  categories: categories,
                ),
                            ),
                          );
                        },
                        child: Container(
                          width: itemWidth,
                          height: itemWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                Icon(Icons.grid_view_rounded,
                    size: itemWidth * 0.4,
                    color: Theme.of(context).primaryColor),
                const SizedBox(height: 8),
                Text(
                  'See All',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                            ],
                          ),
                        ),
                      );
                    }*/

                    final category = categories[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailsPage(
                              categoryId: category.id,
                              categoryName: category.name,
                              imageUrl: "http://sonovision.asquare.org.in/images/${category.icon}",
                            ),
                          ),
                        );
                      },
                      child: Container(
                        // width: itemWidth,
                        margin: const EdgeInsets.only(left: 8,right: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.064),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(

                              // width: itemWidth * 0.8,
                              width:  60,
                              height:  60,
                              // height: itemWidth * 0.8,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: "http://sonovision.asquare.org.in/images/${category.icon}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 4),
                            // Text(
                            //   category.name,
                            //   style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            //     fontWeight: FontWeight.w600,
                            //     fontSize: 14,
                            //     color: Colors.black87,
                            //   ),
                            //   textAlign: TextAlign.center,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            // const SizedBox(width: 4),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16,),
            ],
          );
        }
      );
    },
  );
}
