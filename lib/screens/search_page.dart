import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronic_store/utils/background_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';


class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchhController controller = Get.put(SearchhController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // backgroundColor: Colors.white,
      body: Container(
      /*  decoration:  BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white,Colors.blue.shade800],begin: Alignment.bottomCenter,end: Alignment.topCenter)
        ),*/
        child: Column(
          children: [

            const SizedBox(height: 36),
            SizedBox(
              height: 56,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child:     IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color:Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                      child: Text('Search',style: TextStyle(color: Colors.black,fontSize: 22),)),
                ],
              ),
            ),
            Container(
              height: 48,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                focusNode: controller.searchFocusNode,
                controller: controller.textController,

                // controller: TextEditingController(text: controller.query.value),
                onChanged: (value) {
                  controller.query.value = value;
                  controller.search(value);
                },

                onSubmitted: (value) => controller.search(value),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                 /* suffixIcon: controller.query.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: controller.clearSearch,
                  )*/
                      // : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.query.isEmpty) {
                  return _buildInitialState(context);
                } else if (controller.isSearching.value) {
                  return _buildLoadingState();
                } else {
                  return _buildResults(context);
                }
              }),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInitialState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text(
              'Popular Searches',
              // 'Popular Searches',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.black
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final term = controller.suggestions[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.selectSuggestion(term),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      term,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),
                    ),
                  ),
                );
              },
              childCount: controller.suggestions.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
          ),
        ),
        // Browse categories
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
            child: Text(
              'Browse Categories',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final category = ['Mobiles', 'Refrigerators', 'Tv', 'Accessories'][index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => controller.selectSuggestion(category),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          [Icons.phone_android, Icons.kitchen, Icons.electrical_services, Icons.watch][index],
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(category,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),

                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 4,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (controller.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try different keywords',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = controller.results[index];
                return _buildProductCard(context, product);
              },
              childCount: controller.results.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildProductCard(BuildContext context, dynamic product) {
    final price = product['price']?.toDouble() ?? 0.0;
    final discount = product['discountPercentage']?.toDouble() ?? 0.0;
    final discountedPrice = price - (price * discount / 100);

    return GestureDetector(
      onTap: () => Get.toNamed('/product-details', arguments: product),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl: product['images']?.isNotEmpty == true
                          ? product['images'][0]
                          : 'https://via.placeholder.com/300',
                      fit: BoxFit.contain,
                      placeholder: (_, __) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 40,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Product details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['brand'] ?? '',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product['name'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Price
                      if (discount > 0)
                        Row(
                          children: [
                            Text(
                              '₹${discountedPrice.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '₹$price',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),

                          ],
                        )
                      else
                        Text(
                          '₹$price',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // Favorite button

          ],
        ),
      ),
    );
  }
}

