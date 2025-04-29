import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget _buildSpecification(String title, String? value) {
  if (value == null || value.isEmpty) {
    return const SizedBox.shrink(); // Return an empty widget if no value
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    ),
  );
}

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _currentImageIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
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

  Widget _buildSpecification(String title, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink(); // Return empty if no value
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontSize: 16,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> specifications = widget.product['specifications'] ?? {};
    final theme = Theme.of(context);
    final originalPrice = widget.product['price'];
    final discountPercentage = widget.product['discountPercentage'];
    final discountedPrice = originalPrice - (originalPrice * discountPercentage / 100);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: _isAppBarExpanded ? 4 : 0,
        backgroundColor: _isAppBarExpanded ? theme.primaryColor : Colors.transparent,
        title: AnimatedOpacity(
          opacity: _isAppBarExpanded ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(widget.product['name'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
            color: _isAppBarExpanded ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border,
              color: _isAppBarExpanded ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share,
              color: _isAppBarExpanded ? Colors.white : Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: _isAppBarExpanded ? Brightness.light : Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Product Image Carousel
              Stack(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() => _currentImageIndex = index);
                      },
                    ),
                    items: widget.product['images'].map<Widget>((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Hero(
                            tag: 'product-${widget.product['id']}-$image',
                            child: CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _currentImageIndex,
                        count: widget.product['images'].length,
                        effect: const ExpandingDotsEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 4,
                          expansionFactor: 4,
                          activeDotColor: Colors.white,
                          dotColor: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Info Section
              Container(
                padding: const EdgeInsets.all(16),
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
                                widget.product['name'],
                                style: theme.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.product['brand'],
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.green[700], size: 18),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.product['rating']}',
                                style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          '₹${widget.product['price']}',
                          style: theme.textTheme.titleMedium!.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${widget.product['discountPercentage']}% OFF',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Delivery Info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_shipping_outlined, color: theme.primaryColor),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Free Delivery',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Delivery in ${widget.product['deliveryTime']}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Description Section
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
                      widget.product['description'],
                      trimLines: 3,
                      colorClickableText: theme.primaryColor,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: theme.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
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
                                  entry.key.toString(),
                                  style: TextStyle(
                                    color: Colors.grey[600],
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
              if (widget.product['highlights'] != null)
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
                      ...widget.product['highlights'].split('\n').map<Widget>((highlight) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle,
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

              const SizedBox(height: 80), // Space for bottom bar
              SizedBox(height: 16),

              // Highlights
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Highlights: ${widget.product['highlights']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Specifications Section
              Text(
                'Specifications',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),


              // Dynamically display all specifications
              for (var entry in specifications.entries)
                _buildSpecification(entry.key, entry.value.toString()),

              // Availability Section
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stock: ${widget.product['stock']} items available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ],
          ),
        ));

  }
}

// class ProductDetailsPage extends StatelessWidget {
//   final Map<String, dynamic> product;
//
//   ProductDetailsPage({required this.product});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get the specifications from the product
//     final Map<String, dynamic> specifications = product['specifications'] ?? {};
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['name']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Product images
//               SizedBox(
//                 height: 200,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: product['images'].length,
//                   itemBuilder: (context, index) {
//                     return Image.network(product['images'][index]);
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 16),
//               // Product Details
//               Text(
//                 product['name'],
//                 style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 product['brand'],
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//               const SizedBox(height: 8),
//               Text('Price: ₹${product['price']}'),
//               const SizedBox(height: 8),
//               Text('Discount: ${product['discountPercentage']}%'),
//               const SizedBox(height: 8),
//               Text('Delivery Time: ${product['deliveryTime']}'),
//               const SizedBox(height: 16),
//
//               // Specifications Section
//               Text(
//                 'Specifications',
//                 style: Theme.of(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//
//               // Dynamically display all specifications
//               for (var entry in specifications.entries)
//                 _buildSpecification(entry.key, entry.value.toString()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class ProductDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> product;
//
//   const ProductDetailsPage({Key? key, required this.product}) : super(key: key);
//
//   @override
//   _ProductDetailsPageState createState() => _ProductDetailsPageState();
// }
//
// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   String selectedColor = '';
//   int quantity = 1;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedColor = widget.product['colors'][0];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double discountedPrice = widget.product['price'] *
//         (1 - widget.product['discountPercentage'] / 100);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.product['name']),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.favorite_border),
//             onPressed: () {
//               // Add to wishlist functionality
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: () {
//               Navigator.pushNamed(context, '/cart');
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image Carousel
//             CarouselSlider(
//               options: CarouselOptions(
//                 height: 300,
//                 viewportFraction: 1.0,
//                 enlargeCenterPage: false,
//                 autoPlay: true,
//               ),
//               items: widget.product['images'].map<Widget>((image) {
//                 return Builder(
//                   builder: (BuildContext context) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(image),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }).toList(),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Name and Brand
//                   Text(
//                     widget.product['name'],
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                   Text(
//                     widget.product['brand'],
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Price Information
//                   Row(
//                     children: [
//                       Text(
//                         '₹${discountedPrice.toStringAsFixed(2)}',
//                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           color: Theme.of(context).primaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '₹${widget.product['price']}',
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           decoration: TextDecoration.lineThrough,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           '${widget.product['discountPercentage']}% OFF',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Color Selection
//                   Text(
//                     'Select Color',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     children: widget.product['colors'].map<Widget>((color) {
//                       return ChoiceChip(
//                         label: Text(color),
//                         selected: selectedColor == color,
//                         onSelected: (bool selected) {
//                           setState(() {
//                             selectedColor = color;
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Specifications
//                   Text(
//                     'Specifications',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   ...widget.product['specifications'].entries.map((entry) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               entry.key.toString().toUpperCase(),
//                               style: const TextStyle(
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               entry.value.toString(),
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                   const SizedBox(height: 16),
//
//                   // Delivery Time
//                   Row(
//                     children: [
//                       const Icon(Icons.local_shipping_outlined),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Delivery in ${widget.product['deliveryTime']}',
//                         style: Theme.of(context).textTheme.bodyLarge,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Description
//                   Text(
//                     'Description',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(widget.product['description']),
//                   const SizedBox(height: 16),
//
//                   // Highlights
//                   Text(
//                     'Highlights',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(widget.product['highlights']),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               offset: const Offset(0, -4),
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Theme.of(context).primaryColor),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(Icons.shopping_cart_outlined,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Buy Now functionality
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Theme.of(context).primaryColor,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'BUY NOW',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
