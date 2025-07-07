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
/*      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        // automaticallyImplyLeading: false,
        title:  const Text('Search'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color:Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),*/
      // backgroundColor: Colors.white,
      body: BackgroundContainer(
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
                        color:Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                      child: Text('Search',style: TextStyle(color: Colors.white,fontSize: 22),)),
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
                  suffixIcon: controller.query.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: controller.clearSearch,
                  )
                      : null,
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
        // Recent searches
        if (controller.history.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                'Recent Searches',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (controller.history.isNotEmpty)
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final term = controller.history[index];
                return ListTile(
                  leading: Icon(
                    Icons.history_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: Text(term),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => controller.history.removeAt(index),
                  ),
                  onTap: () => controller.selectSuggestion(term),
                );
              },
              childCount: controller.history.length,
            ),
          ),
        // Popular searches
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Text(
              'Popular Searches',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
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
                      style: Theme.of(context).textTheme.bodyMedium,
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final category = ['Mobiles', 'Appliances', 'Electronics', 'Accessories'][index];
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
                        Text(category),
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
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: product['images']?.isNotEmpty == true
                          ? product['images'][0]
                          : 'https://via.placeholder.com/300',
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: Theme.of(context).colorScheme.surfaceVariant,
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
                      /*      const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${discount.toStringAsFixed(0)}% OFF',
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),*/
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
        /*    Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {

                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
class SearchPagej extends StatelessWidget {
  SearchPagej({Key? key}) : super(key: key);

  final SearchhController controller = Get.put(SearchhController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: controller.search,
            style: const TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Search products...',
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: Obx(() => controller.query.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: controller.clearSearch,
                    )
                  : const SizedBox()),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.query.value.isEmpty) {
          return _buildSuggestions(context);
        } else if (controller.results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 70, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('No results found', style: TextStyle(fontSize: 18, color: Colors.grey[700], fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Try a different keyword', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.results.length,
            itemBuilder: (context, index) {
              final product = controller.results[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      product['image'],
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  subtitle: Text(
                    product['category'],
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Text(
                    '\$${product['price']}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    // TODO: Navigate to product details
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.history.isNotEmpty) ...[
            const Text('Recent Searches', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(controller.history.length, (index) {
                final item = controller.history[index];
                return ActionChip(
                  label: Text(item),
                  backgroundColor: Colors.grey[200],
                  onPressed: () => controller.selectSuggestion(item),
                  avatar: const Icon(Icons.history, size: 18, color: Colors.grey),
                );
              }),
            ),
            const SizedBox(height: 24),
          ],
          const Text('Suggestions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: List.generate(controller.suggestions.length, (index) {
              final suggestion = controller.suggestions[index];
              return Chip(
                label: Text(suggestion),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                avatar: const Icon(Icons.search, size: 18, color: Colors.grey),
                onDeleted: null,
                deleteIcon: null,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                elevation: 0,
                shadowColor: Colors.transparent,
                clipBehavior: Clip.antiAlias,

                // onPressed: () => controller.selectSuggestion(suggestion),
              );
            }),
          ),
        ],
      ),
    );
  }
}
