import 'package:electronic_store/price_extensions.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/brands_category_products_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/category_products_controller.dart';
import '../models/product_details_data_from_brands_category.dart';
import '../models/product_of_brands.dart';
import '../utils/cart_bottom_sheet.dart';

class ProductsFromBrandCategoryScreen extends StatefulWidget {
  final String? filterTitle;
  final String? filterId;
  final List<PriceRange> priceRanges; // all ranges
  final String categoryId;
  final String categoryName;
  final String imageUrl;
  final String? brandName;
  final String? brandId;
  final List<FilterValue> selectedFilters;
  final List<FilterValue> allFilters;
  final PriceRange? selectedRange; // chosen range
// from backend

  const ProductsFromBrandCategoryScreen({
    Key? key,
    this.brandName,
    this.filterId,
    this.filterTitle,
    this.brandId,
    this.selectedRange,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    this.selectedFilters = const [],
    this.allFilters = const [],
    this.priceRanges = const [],
  }) : super(key: key);

  @override
  State<ProductsFromBrandCategoryScreen> createState() =>
      _ProductsFromBrandCategoryScreenState();
}

class _ProductsFromBrandCategoryScreenState
    extends State<ProductsFromBrandCategoryScreen> {
  final List<String> _filters = ['All', 'Popular', 'New', 'Price ↑', 'Price ↓'];
  String _selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  late List<FilterValue> activeFilters;
   PriceRange? activeRange;

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    if(widget.selectedRange!=null){
      activeRange = widget.selectedRange!; // default
    }

    categoryProductsController =
        Get.put(BrandsCategoryProductsController(widget.categoryId));
    activeFilters = List.from(widget.selectedFilters);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadProducts();
    });
    _scrollController.addListener(_onScroll);
  }
  void _changeRange(PriceRange newRange) {
    setState(() {
      activeRange = newRange;
    });
    _loadProducts();
  }

  Future<void> _toggleFilter(FilterValue filter) async {
    setState(() {
      if (activeFilters.any((f) => f.id == filter.id)) {
        activeFilters.removeWhere((f) => f.id == filter.id);
      } else {
        activeFilters.add(filter);
      }
    });
    await _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  late final BrandsCategoryProductsController categoryProductsController;

  Future<void> _loadProducts() async {
    print("_loadProducts ${widget.categoryId}");
    setState(() {
      _isLoading = true;
    }); // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 100));

    if (activeFilters.isEmpty) {
      // no filter → load normally
      categoryProductsController.fetchProductsByCategory(
        widget.categoryId,
        widget.brandId ?? '',
      );
    } else {
      // multiple filters → call API for each filter id
      for (final f in activeFilters) {
        categoryProductsController.fetchProductsByCategory(
            widget.categoryId, widget.brandId ?? '',
            filterName: widget.filterTitle,
            filterId: f.id,
            selectedFilters: activeFilters);
      }
    }




    // categoryProductsController.fetchProductsByCategory(widget.categoryId,widget.brandId??'',filterId:widget.filterId,filterName: widget.filterTitle );

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  void _removeFilter(int index) async {
    setState(() {
      activeFilters.removeAt(index);
    });
    await _loadProducts();
  }

  Future<void> _loadMoreProducts() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Implement pagination
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Widget buildFilterChips() {
  //   return Obx(() {
  //     return Wrap(
  //       spacing: 8,
  //       children: _filters.map((filter) {
  //         return ChoiceChip(
  //           label: Text(filter),
  //           selected: categoryProductsController.selectedFilter.value == filter,
  //           onSelected: (_) => categoryProductsController.applyFilter(filter),
  //         );
  //       }).toList(),
  //     );
  //   });
  // }

  void openFilterBottomSheet() {
    Get.bottomSheet(Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Filter Header
            Row(
              children: [
                Icon(Icons.tune_rounded,
                    size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  // onPressed: () => categoryProductsController.resetFilters(),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Brand Filter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 6),
                  child: Text(
                    'Brand',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: categoryProductsController.selectedBrand.value,
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[600]),
                      items: categoryProductsController.availableBrands
                          .map((String brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(
                            brand,
                            style: TextStyle(
                              fontSize: 14,
                              color: brand == 'All'
                                  ? Colors.grey[500]
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // categoryProductsController.selectBrand(newValue!);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Sort Filter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 6),
                  child: Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: categoryProductsController.selectedFilter.value,
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[600]),
                      items: ['All', 'Price ↑', 'Price ↓', 'Popular', 'New']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 14,
                              color: value == 'All'
                                  ? Colors.grey[500]
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // categoryProductsController.applyFilter(newValue!);
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Price Range Filter
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 6),
                  child: Text(
                    'Price Range',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      RangeSlider(
                        values: RangeValues(
                          categoryProductsController.selectedMinPrice.value,
                          categoryProductsController.selectedMaxPrice.value,
                        ),
                        min: categoryProductsController.minPrice.value,
                        max: categoryProductsController.maxPrice.value,
                        divisions: 10,
                        labels: RangeLabels(
                          '₹${categoryProductsController.selectedMinPrice.value.toStringAsFixed(0)}',
                          '₹${categoryProductsController.selectedMaxPrice.value.toStringAsFixed(0)}',
                        ),
                        onChanged: (RangeValues values) {
                          // categoryProductsController.updatePriceRange(
                          //     values.start, values.end);
                        },
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${categoryProductsController.minPrice.value.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            '₹${categoryProductsController.maxPrice.value.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      );
    }));
  }

  SliverToBoxAdapter _buildActiveFiltersChips() {
    return SliverToBoxAdapter(
      child: Obx(() {
        List<Widget> chips = [];

        if (categoryProductsController.selectedMinPrice.value !=
                categoryProductsController.minPrice.value ||
            categoryProductsController.selectedMaxPrice.value !=
                categoryProductsController.maxPrice.value) {
          chips.add(
            Chip(
              label: Text(
                '₹${categoryProductsController.selectedMinPrice.value.toInt()} - ₹${categoryProductsController.selectedMaxPrice.value.toInt()}',
              ),
              onDeleted: () {
                // categoryProductsController.resetFilters();
                // _removeFilter();
              },
            ),
          );
        }

        if (categoryProductsController.selectedBrand.value != 'All') {
          chips.add(
            Chip(
              label: Text(categoryProductsController.selectedBrand.value),
              onDeleted: () {
                categoryProductsController.selectedBrand.value = 'All';
                categoryProductsController.applyInitialFilters();
              },
            ),
          );
        }

        if (chips.isEmpty)
          return SizedBox.shrink(); // Don't render anything if no chips

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: chips,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.black),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: openFilterBottomSheet,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Filters'),
              ],
            )),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // _buildSliverAppBar(),
          // _buildFiltersBar(),
          // _buildActiveFiltersChips(),


          if(activeRange!=null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Active filter chip
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      InputChip(

                        label: Text("${activeRange!.label}",),
                        selected: true,

                        onDeleted: () {
                          setState(() {
                            activeRange = widget.priceRanges.first; // reset
                          });
                          _loadProducts();
                        },
                      ),
                    ],
                  ),
                ),


                // 🔹 Price range chips (horizontal list)
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: widget.priceRanges.length,
                    itemBuilder: (context, index) {
                      final range = widget.priceRanges[index];
                      final isSelected = range.id == activeRange!.id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(range.label),
                          selected: isSelected,
                          selectedColor: Colors.blue.shade200,
                          backgroundColor: Colors.grey.shade200,
                          onSelected: (_) => _changeRange(range),
                        ),
                      );
                    },
                  ),
                ),
                Obx(() {
                  final products = categoryProductsController.filteredProducts;
                  print("BBBBBBBB");
                  print(products.length);
                  return SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final product = products[i];
                        return Text(product.name ?? "No name");
                      },
                    ),
                  );
                })
              ],
            ),
          ),
          ///working new

// ✅ This part shows currently active filters with delete option
          if (activeFilters.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: activeFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = activeFilters[index];
                    return Chip(
                      label: Text(f.value),
                      onDeleted: () => _removeFilter(index), // ❌ delete here
                      backgroundColor: Colors.blue.shade100,
                    );
                  },
                ),
              ),
            ),

          ///working old
          // if (activeFilters.isNotEmpty)
          //   SliverToBoxAdapter(
          //     child: SizedBox(
          //       height: 50,
          //       child: ListView.separated(
          //         scrollDirection: Axis.horizontal,
          //         padding: const EdgeInsets.symmetric(horizontal: 8),
          //         itemCount: widget.allFilters.length,
          //         separatorBuilder: (_, __) => const SizedBox(width: 8),
          //         itemBuilder: (context, index) {
          //           final f = widget.allFilters[index];
          //           final isSelected = activeFilters.any((af) => af.id == f.id);
          //
          //           return ChoiceChip(
          //             label: Text(f.value),
          //             selected: isSelected,
          //
          //             selectedColor: Colors.blue.shade200,
          //             backgroundColor: Colors.grey.shade200,
          //             onSelected: (_) => _toggleFilter(f),
          //
          //
          //           );
          //         },
          //       ),
          //     ),
          //   ),

// ✅ This part shows ALL filters (tappable ChoiceChips)
          SliverToBoxAdapter(
            child: Wrap(
              spacing: 8,
              children: widget.allFilters.map((f) {
                final isSelected = activeFilters.any((af) => af.id == f.id);
                return ChoiceChip(
                  label: Text(f.value),
                  selected: isSelected,
                  selectedColor: Colors.blue.shade200,
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (_) => _toggleFilter(f), // toggle add/remove
                );
              }).toList(),
            ),
          ),
          Obx(() {
            // print(
            //     'isLoading: ${categoryProductsController.isLoading.value}, products length: ${categoryProductsController.allProducts.length}');

            final isLoading = categoryProductsController.isLoading.value;
            final products = categoryProductsController.allProducts;
            // final products = categoryProductsController.allProducts;
            // final filterProducts = categoryProductsController.filteredProducts;

            if (isLoading) {
              return const SliverToBoxAdapter(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )),
              );
            }
            if (categoryProductsController.isError.value) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "An error occurred. Please try again later.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            if (products.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "No products found\nPlease wait or try again later",
                    textAlign: TextAlign.center,
                  ),
                )),
              );
            }


            return _buildProductGrid(); // ✅ If products are loaded
          }),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80), // This acts as bottom margin/padding
          ),
          // if (categoryProductsController.isLoading.value)
          //   const SliverToBoxAdapter(
          //     child: Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: Center(child: CircularProgressIndicator()),
          //     ),
          //   ),
          //
          // if (categoryProductsController.products.isEmpty)
          //   const SliverToBoxAdapter(
          //     child: Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: Center(child: Text('No products found')),
          //     ),
          //   ),
          // if (_isLoading)
          //   const SliverToBoxAdapter(
          //     child: Padding(
          //       padding: EdgeInsets.all(16.0),
          //       child: Center(child: CircularProgressIndicator()),
          //     ),
          //   ),
          //
          // if (categoryProductsController.products.isNotEmpty)
          //   _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 160.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          '',
          // widget.categoryName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            //widget. imageUrl
            image: DecorationImage(
                image: NetworkImage(widget.imageUrl), fit: BoxFit.cover),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black87, Colors.black54],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = categoryProductsController.allProducts;

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              _buildProductCard(products[index]),
          childCount: products.length,
        ),
      ),
    );
  }

  Widget _buildProductCardf(ProductDetailsDataFromBrandsCategory product) {
    final originalPrice = product.price as num;
    final discountPercentage = product.discountPercentage as num;
    final discountedPrice =
        originalPrice - (originalPrice * discountPercentage / 100);

    return GestureDetector(
      //          arguments: product['_id'],
      onTap: () {
        var productDetails = {
          '_id': product.id,
        };
        Get.toNamed('/product-details', arguments: productDetails);
      },
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          /*  boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],*/
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: const Color(0xfff9f5f4),
                      child: Hero(
                        tag: 'product-${product.id}-${product.images[0]}',
                        child: CachedNetworkImage(
                          imageUrl: product.images[0],
                          // fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (discountPercentage > 0)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${discountPercentage.toStringAsFixed(0)}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  /*    Text(
                      product.brand,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,

                      ),
                    ),*/
                  const SizedBox(height: 4),
                  Text(
                    '₹${discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xffaa6d6a),
                        fontWeight: FontWeight.bold),
                  ),
                  // if (discountPercentage > 0) ...[
                  //   const SizedBox(width: 4),
                  //   Text(
                  //     '₹${originalPrice.toStringAsFixed(2)}',
                  //     style: TextStyle(
                  //       decoration: TextDecoration.lineThrough,
                  //       color: Colors.grey[600],
                  //       fontSize: 10,
                  //     ),
                  //   ),
                  // ],
                  const SizedBox(height: 4),

                  SizedBox(
                    /*    padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.black,

                          borderRadius: BorderRadius.circular(8)),*/ // width: double.infinity,
                    child: InkWell(
                      /*      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),*/
                      onTap: () {
                        final controller = Get.put(CartController());

                        final exists = controller.cartItems
                            .any((item) => item.productId == product.id);

                        if (exists) {
                          Get.snackbar(
                            'Info',
                            'Item already in cart',
                            overlayBlur: 2,
                            overlayColor: Colors.black26,
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(milliseconds: 1500),
                          );
                        } else {
                          controller.addItem(CartItem(
                            name: product.name,
                            image: product.images[0],
                            color:
                                product.colors.isEmpty ? '' : product.colors[0],
                            price: product.price,
                            productId: product.id,
                          ));
                          CartBottomSheet.show();
                        }
                        // CartBottomSheet.show();

                        // Get.snackbar("Cart", "${product['name']} added to cart",snackPosition:SnackPosition.BOTTOM,overlayBlur: 2);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                // color: Color(0xffaa6d6a),
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black,
                            // color: Color(0xffaa6d6a),
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductDetailsDataFromBrandsCategory product) {
    print(product.name);
    print(product.id);
    final originalPrice = product.price as num;
    final discountPercentage = product.discountPercentage ?? 0;
    // final discountPercentage = product.discountPercentage as   num;
    final discountedPrice =
        originalPrice - (originalPrice * discountPercentage / 100);

    return Opacity(
      opacity: product.isActive ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !product.isActive,
        child: GestureDetector(
          onTap: () {
            var productDetails = {'_id': product.id};
            Get.toNamed('/product-details', arguments: productDetails);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                product.images.isNotEmpty
                    ? Stack(
                        children: [
                          Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceVariant
                                  .withOpacity(0.3),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: Hero(
                                tag:
                                    'product-${product.id}-${product.images[0]}',
                                child: CachedNetworkImage(
                                  imageUrl: product.images[0],
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Discount Badge
                          if (discountPercentage > 0)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF5F6D),
                                      Color(0xFFFFC371),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${discountPercentage.toStringAsFixed(0)}% OFF',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                          // Favorite Button
                          Visibility(
                            visible: false,
                            child: Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  onPressed: () {},
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 160,
                      ),

                // Product Info Section
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand Name
                      if (product.brand != null &&
                          product.brand!.name.isNotEmpty)
                        Text(
                          product.brand!.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),

                      // Product Name
                      const SizedBox(height: 4),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),

                      // Price Section
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            discountedPrice.toINR(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (discountPercentage > 0)
                            Text(
                              originalPrice.toINR(),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),

                      // Add to Cart Button
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final controller = Get.put(CartController());
                            final exists = controller.cartItems
                                .any((item) => item.productId == product.id);

                            if (exists) {
                              Get.snackbar(
                                'Info',
                                'Item already in cart',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.white,
                                colorText: Colors.black,
                                margin: const EdgeInsets.all(12),
                              );
                            } else {
                              controller.addItem(CartItem(
                                name: product.name,
                                image: product.images[0],
                                color: product.colors.isEmpty
                                    ? ''
                                    : product.colors[0],
                                price: product.price,
                                productId: product.id,
                              ));
                              CartBottomSheet.show();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_outlined, size: 16),
                              SizedBox(width: 6),
                              Text(
                                  product.isActive
                                      ? 'Add to Cart'
                                      : 'Out of Stock',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
