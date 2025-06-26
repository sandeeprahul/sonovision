import 'package:electronic_store/models/product_details_data.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/category_products_controller.dart';
import '../utils/cart_bottom_sheet.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String imageUrl;

  const CategoryDetailsPage({
    Key? key,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  final List<String> _filters = ['All', 'Popular', 'New', 'Price ↑', 'Price ↓'];
  String _selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
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

  late final CategoryProductsController categoryProductsController = Get.put(CategoryProductsController(widget.categoryId));

  Future<void> _loadProducts() async {
    print("_loadProducts ${widget.categoryId}");
    setState(() => _isLoading = true);
    // TODO: Replace with actual API call
    categoryProductsController .fetchProductsByCategory(widget.categoryId);
        // Get.put(CategoryProductsController(widget.categoryId));

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadMoreProducts() async {
    if (!_isLoading) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      // TODO: Implement pagination
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          _buildFiltersBar(),
          if(categoryProductsController.products.isNotEmpty)
          _buildProductGrid(),

          if(categoryProductsController.products.isEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('No products found')),
            ),
          ),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
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

  Widget _buildFiltersBar() {
    return SliverToBoxAdapter(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final filter = _filters[index];
            final isSelected = filter == _selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,

                onSelected: (selected) {
                  setState(() => _selectedFilter = filter);
                  _loadProducts(); // Reload with new filter
                },
                checkmarkColor: Colors.white,
                // <-- sets the icon color when selected

                backgroundColor: Colors.grey[200],
                selectedColor: Colors.black87,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
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
              _buildProductCard(categoryProductsController.products[index]),
          childCount: categoryProductsController.products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductDetailsData product) {
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
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: product.images[0],
                                        // height: 150,
                                        width: double.infinity,
                                        // fit: BoxFit.contain,
                                      ),
                                    ),
                                    /*           Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.brand,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                '₹${product.price}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                    color: Colors.black

                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              if (product.discountPercentage > 0)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red[50],
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    '${product.discountPercentage}% OFF',
                                                    style: TextStyle(
                                                      color: Colors.red[700],
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),*/
                                  ],
                                ),
                                /* Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // TODO: Implement add to cart functionality
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${product.name} added to cart'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        customBorder: const CircleBorder(),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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

                        borderRadius: BorderRadius.circular(8)),*/// width: double.infinity,
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
                            color: product.colors.isEmpty ? '' : product.colors[0],
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
}
