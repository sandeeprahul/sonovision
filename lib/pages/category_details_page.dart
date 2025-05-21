import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/cart_bottom_sheet.dart';
import 'product_details_page.dart';

class CategoryDetailsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryDetailsPage({
    Key? key,
    required this.categoryId,
    required this.categoryName,
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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
     var  _producsts = [
        {
          "_id": "680ef09a4fbe39d34f56dd7d",
          "name": "Galaxy S24",
          "brand": "Samsung",
          "price": 150000,
          "discountPercentage": 10,
          "images": [
            "https://sonovision.in/wp-content/uploads/2024/03/ICY-BLUE-300x300.jpg",
          ],
          "stock": 80,
        },
        {
          "_id": "680ef8674fbe39d34f56dd8b",
          "name": "Top load Washing machine",
          "brand": "Samsung",
          "price": 40000,
          "discountPercentage": 5,
          "images": [
            "https://sonovision.in/wp-content/uploads/2024/03/ACE-TURBO-DRY.jpg"
          ],
          "stock": 80,
        },
      ];
      _products = [
        {
          "_id": "680ef09a4fbe39d34f56dd7d",
          "name": "Galaxy S24",
          "brand": "Samsung",
          "categoryId": "680eeed3712a366bf3002809",
          "price": 150000,
          "discountPercentage": 10,
          "description": "Samsung galaxy S24",
          "highlights": "SPen AI",
          "deliveryTime": "7-10 days",
          "isFeatured": true,
          "colors": [
            "Red",
            "Black",
            "White",
            "Blue",
            "Green",
            "Grey"
          ],
          "images": [
            "https://sonovision.in/wp-content/uploads/2024/03/ICY-BLUE-300x300.jpg",
            "https://sonovision.in/wp-content/uploads/2023/07/vivo-x90-pro-300x300.jpg"
          ],
          "stock": 80,
          "storeCode": "SONO55",
          "specifications": {
            "battery": "6700",
            "display": "Amoled",
            "displaySize": "6.7",
            "frontCamera": "56",
            "mainCamera": "68",
            "networkType": "5G",
            "os": "Android",
            "processor": "Exynos",
            "ram": "12",
            "storage": "250"
          },
          "createdAt": "2025-04-28T03:06:02.119Z",
          "updatedAt": "2025-04-28T03:13:44.983Z",
          "__v": 0
        },
        {
          "_id": "680ef8674fbe39d34f56dd8b",
          "name": "Top load Washing machine",
          "brand": "Samsung",
          "categoryId": "680eeed3712a366bf3002811",
          "price": 40000,
          "discountPercentage": 5,
          "description": "Top load Washing machine Top load Washing machine",
          "highlights": "Top load Washing machine 7kg",
          "deliveryTime": "7-10 days",
          "isFeatured": true,
          "colors": [
            "Grey",
            "Navy",
            "Brown",
            "Red",
            "Green"
          ],
          "images": [
            "https://sonovision.in/wp-content/uploads/2024/03/ACE-TURBO-DRY.jpg"
          ],
          "stock": 80,
          "storeCode": "SONO55",
          "specifications": {
            "capacity": "7",
            "loadType": "Front Load",
            "starRating": "5 Star",
            "type": "Fully Automatic"
          },
          "createdAt": "2025-04-28T03:39:19.272Z",
          "updatedAt": "2025-04-28T03:42:03.995Z",
          "__v": 0
        }
      ];
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          _buildFiltersBar(),
          _buildProductGrid(),
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
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
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
                checkmarkColor: Colors.white, // <-- sets the icon color when selected


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
          childAspectRatio: 0.7,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildProductCard(_products[index]),
          childCount: _products.length,
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final originalPrice = product['price'] as num;
    final discountPercentage = product['discountPercentage'] as num;
    final discountedPrice = originalPrice - (originalPrice * discountPercentage / 100);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'product-${product['_id']}-${product['images'][0]}',
                      child: CachedNetworkImage(
                        imageUrl: product['images'][0],
                        fit: BoxFit.cover,
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
                                      imageUrl: product['images'][0],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          product['brand'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${product['price']}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                  color: Colors.black

                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (product['discountPercentage'] > 0)
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
                                                  '${product['discountPercentage']}% OFF',
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
                                  ),
                                ],
                              ),
                              Positioned(
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
                                            content: Text('${product['name']} added to cart'),
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
                              ),
                            ],
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
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
                    product['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,

                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product['brand'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,

                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${discountedPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 14,
                    ),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {

                        CartBottomSheet.show();

                        // Get.snackbar("Cart", "${product['name']} added to cart",snackPosition:SnackPosition.BOTTOM,overlayBlur: 2);
                      },
                      child: const Text("Add", style: TextStyle(fontSize: 12)),
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
