import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/cart_controller.dart';
import '../controllers/product_details_controller.dart';
import '../screens/product_list_screen.dart';
import '../utils/cart_bottom_sheet.dart';
import '../widgets/horizontal_product_list.dart';
import '../widgets/product_details_widgets/availability_options_widget.dart';
import '../widgets/product_details_widgets/store_availability_card.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key}) : super(key: key);

  // const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  late final Map<String, dynamic> product;


  int _currentImageIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    product = Get.arguments as Map<String, dynamic>;

  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _pageController.dispose();

    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_isAppBarExpanded) {
      setState(() => _isAppBarExpanded = true);
    } else if (_scrollController.offset <= 200 && _isAppBarExpanded) {
      setState(() => _isAppBarExpanded = false);
    }
  }

  final productDetailsController = Get.put(ProductDetailsController());
//_id
  @override
    Widget build(BuildContext context) {
    productDetailsController.fetchProduct(product['_id']);


      final theme = Theme.of(context);

  
      return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.primaryColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              Get.toNamed('/cart');
                            },
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              color: theme.primaryColor,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideX(begin: -0.3, duration: 300.ms),
  
                        // Cart count badge
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Obx(() {
                            final controller = Get.put(CartController());
                            return controller.cartItems.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                        minWidth: 20, minHeight: 20),
                                    child: Text(
                                      '${controller.cartItems.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final controller = Get.put(CartController());
  
                          const productId = '680ef09a4fbe39d34f56dd7d';
                          final exists = controller.cartItems
                              .any((item) => item.productId == productId);
  
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
                              name: 'Galaxy S24',
                              image:
                                  'https://sonovision.in/wp-content/uploads/2022/08/samsung-s225g-white.jpg',
                              color: 'Black',
                              price: 150000.0,
                              productId: productId,
                            ));
                            CartBottomSheet.show();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(begin: 0.3, duration: 300.ms),
                  ],
                ),
              ),
            ),
          ),
        appBar: AppBar(
          elevation: _isAppBarExpanded ? 4 : 0,
          backgroundColor:
              _isAppBarExpanded ? theme.primaryColor : Colors.transparent,
          title: AnimatedOpacity(
            opacity: _isAppBarExpanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Obx(
               () {
                 if(productDetailsController.isLoading.value){
                   return const SizedBox.shrink();
                 }

                return Text(
                  productDetailsController.product.value!.name,
                  style: const TextStyle(color: Colors.white),
                );
              }
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: _isAppBarExpanded ? Colors.white : Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: _isAppBarExpanded ? Colors.white : Colors.black,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: _isAppBarExpanded ? Colors.white : Colors.black,
              ),
              onPressed: () {},
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                _isAppBarExpanded ? Brightness.light : Brightness.dark,
          ),
        ),
        body: Obx(
           () {
             if (productDetailsController.isLoading.value) {
               return const Center(child: CircularProgressIndicator());
             }
             final product = productDetailsController.product.value!;
             final Map<String, dynamic> specifications =
                 product.specifications ?? {};
             final originalPrice = product.price;
             final discountPercentage = product.discountPercentage;
             final discountedPrice =
                 originalPrice - (originalPrice * discountPercentage / 100);
             return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                // controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Carousel
                    const SizedBox(
                      height: 74,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 400, // ✅ Add height to avoid zero-size error

                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _isAppBarExpanded ? Colors.black : Colors.red,
                                _isAppBarExpanded
                                    ? Colors.black.withOpacity(0.05)
                                    : Colors.red.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: product.images.length,
                              onPageChanged: (index) {
                                // setState(() => _currentImageIndex = index);
                              },
                              itemBuilder: (context, index) {
                                final image = product.images[index];
                                return Hero(
                                  tag: 'product-${product.id}-$image',
                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                       /* Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: _currentImageIndex,
                              count: product.images.length,
                              effect: const ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 4,
                                expansionFactor: 4,
                                activeDotColor: Colors.red,
                                dotColor: Colors.grey,
                              ),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                    Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _currentImageIndex,
                        count: product.images.length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 4,
                          expansionFactor: 4,
                          activeDotColor: Colors.red,
                          dotColor: Colors.grey,
                        ),
                      ),
                    ),
                    // Product Info Section
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style:
                                          theme.textTheme.headlineSmall!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.brand,
                                      style: theme.textTheme.titleMedium!.copyWith(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.blue[700], size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.2',
                                      // '${widget.product['rating']}'??'4.2',
                                      style: TextStyle(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₹${discountedPrice.toStringAsFixed(2)}',
                                style: theme.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${product.price}',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${product.discountPercentage}% OFF',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: theme.textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ReadMoreText(
                            // 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam ',

                            "${product.description}  " ,
                            trimLines: 3,
                            colorClickableText: theme.primaryColor,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',

                            style: theme.textTheme.bodyLarge!
                                .copyWith(color: Colors.black, fontSize: 12
                                    // height: 1.5,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const StoreAvailabilityCard(
                      storeCount: 15,
                      // No onTap for read-only display
                    ),

                    // Specifications Section
                    if (specifications.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Specifications',
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...specifications.entries.map((entry) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        entry.key
                                                .toString()
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            entry.key.toString().substring(1),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        entry.value.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                    // Highlights Section
                    if (product.highlights != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Highlights',
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...product.highlights
                                .split('\n')
                                .map<Widget>((highlight) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: theme.primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        highlight.trim(),
                                        style: theme.textTheme.bodyLarge!.copyWith(
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    // const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Related Products',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    HorizontalProductList(),
                  ],
                ),
              ),
            );
          }
        ));
  }
}
