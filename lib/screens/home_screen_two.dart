import 'package:electronic_store/screens/search_page.dart';
import 'package:electronic_store/widgets/home_widgets/offers_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/cart_controller.dart';
import '../pages/category_details_page.dart';
import '../pages/login_page.dart';
import '../premium_profile_page.dart';
import '../price_extensions.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../controllers/home_controller.dart';
import '../utils/CartHelper.dart';
import '../utils/cart_bottom_sheet.dart';
import '../utils/loadImageBasedOnExtension.dart';
import '../widgets/_buildCategoryGroup.dart';
import '../widgets/home_brands_wdget.dart';
import '../widgets/home_widgets/banner_widget.dart';

// import '../widgets/home_widgets/brand_strip_widget.dart';
import '../widgets/home_widgets/brand_strip_widget.dart';
import '../widgets/home_widgets/flash_sale_widget.dart';
import '../widgets/home_widgets/search_widget.dart';
import 'notifications_page.dart';

class HomeScreenTwo extends StatefulWidget {
  const HomeScreenTwo({Key? key}) : super(key: key);

  @override
  State<HomeScreenTwo> createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark, // Android: black icons/text

    ));
    return Scaffold(
      // extendBodyBehindAppBar: true, // this is key
      /*   appBar: AppBar(title: Text('Home'),
        leading:         IconButton(onPressed: (){}, icon: Icon(Icons.menu)),


        actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
      ],),*/
      backgroundColor: const Color(0xfff6f5ef),
      // backgroundColor: Colors.grey.shade100,
      body: Obx(
         () {
           if (controller.isLoading.value) {
             return const Center(child: CircularProgressIndicator());
           }

           if (controller.error.isNotEmpty) {
             return _buildErrorWidget(controller);
           }


           return Stack(
            children: [
              // Image.asset(
              //   'assets/sonovision_bg_homepage.png',
              //   height: double.infinity,
              //   // height: double.infinity,
              //   fit: BoxFit.cover,
              // ),
              SafeArea(
                child: _buildHomeContent(context, controller),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildErrorWidget(HomeController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(controller.error.value),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.refreshHomeData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, HomeController controller) {
    final widgets =
        (controller.homeData.value['widgets'] ?? []) as List<dynamic>;
    /*final saleEndTime =
        DateTime.parse(controller.homeData.value['saleEndTime']);*/

    return RefreshIndicator(
      onRefresh: () {
        return controller.refreshHomeData();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Add SliverAppBar

          SliverAppBar(
            expandedHeight: 96.0,
            backgroundColor: Colors.black,

            // backgroundColor: Colors.transparent,
            // backgroundColor: Colors.grey.withAlpha(2),
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              // collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  profileWidget(context),
                ],
              ),
            ),
          ),
          // Add SliverList for main content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                ...widgets.map((widget) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: _buildDynamicWidget(context, widget),
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicWidget(
      BuildContext context, Map<String, dynamic> widget) {
    switch (widget['widgetType']) {
      /* case 'search':
        return _buildSearchBar();*/
      case 'flashSale':

        ///recently viewed
        return FlashSaleWidget(
          widgetData: widget,
        );

      case 'group':
        return _buildGroupWidget(context, widget);
        // case 'horizontal':
        // return _buildGroupWidget(context, widget);
      case 'banners':
        final bannerData = widget['data']?['data'] ?? [];
        final style = widget['style'] ?? {};


        return OffersCarouselNew(banners: bannerData, style: style);

        case 'offers':
        final bannerData = widget['data']?['data'] ?? [];
        final style = widget['style'] ?? {};


        return BannersCarouselNew(banners: bannerData, style: style);
      case 'dealOfDay':
        return _buildDealOfDay(widget);
      /*  case 'brandStrip':
        return buildBrandStripWidget(widget);*/
      case 'recentlyViewed':
        return widget['type']=='category'?_buildRecentlyViewedCategoryWidget(widget):_buildRecentlyViewed(widget);
      default:
        return const SizedBox.shrink();
    }
  }
  String _formatWidgetType(String key) {
    // Converts 'dealOfDay' → 'Deal of the Day'
    final buffer = StringBuffer();
    for (int i = 0; i < key.length; i++) {
      final char = key[i];
      if (i == 0) {
        buffer.write(char.toUpperCase());
      } else if (char.toUpperCase() == char && char != '_') {
        buffer.write(' ');
        buffer.write(char);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  Widget _buildDealOfDay(Map<String, dynamic> widget) {
    final style = widget['style'];
    final deal = widget['data'];

    final widgetType = widget['widgetType'];
    final title = _formatWidgetType(widgetType); // Convert camelCase to readable

    return Container(
      margin:
          EdgeInsets.symmetric(vertical: style['margin']?.toDouble() ?? 8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  // textAlign: TextAlign.center,
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      // color: Colors.black,
                      // fontSize: style['cardStyle']?['titleStyle']?['fontSize']
                      //         ?.toDouble() ??
                      //     20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  var productJson = {
                    '_id': deal['product']['id'],
                    // other fields if needed
                  };

                  Get.toNamed('/product-details', arguments: productJson);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ),
                    /*    borderRadius: BorderRadius.circular(
                      style['cardStyle']['borderRadius']?.toDouble() ?? 16.0,
                    ),*/
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                style['cardStyle']['borderRadius']
                                        ?.toDouble() ??
                                    16.0,
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: CachedNetworkImage(
                                // imageUrl:
                                //     'https://sonovision.in/wp-content/uploads/2022/08/samsung-s225g-white.jpg',
                                imageUrl: deal['product']?['image'] ?? '',

                                //
                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deal['product']?['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,

                                  ),
                                ),
                                const SizedBox(height: 8),
                                /*     Text(
                                  deal['product']?['description']??'',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 16),*/
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Text(
                                '₹${deal['product']?['price']}',
                                      // '₹${maskPrice(deal['product']?['price'],starsCount: 3) ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                 /*   Text(
                                      '₹${deal['product']?['price']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),*/
                                   /* const SizedBox(width: 8),
                                    if (deal['product']?['strikePrice'] != null &&
                                        deal['product']?['strikePrice'] != deal['product']?['price'])
                                      Text(
                                        '₹${deal['product']?['strikePrice']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),*/
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      if (deal['product']?['discount'] != null &&
                          deal['product']?['discount'] != 0)
                        Positioned(
                          top: 20,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${deal['product']?['discount']}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          Positioned(
              bottom: 34,
              right: 34,
              child: CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        final controller = Get.put(CartController());
                        // final product = productDetailsController.product.value!;
                        // {deal['product']['id']}
                        final exists = controller.cartItems.any(
                            (item) => item.productId == deal['product']['id']);

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
                            name: deal['product']['name'],
                            image: deal['product']['image'],
                            color: 'Black',
                            price: (deal['product']['price'] as num).toDouble(), // ✅ converts int → double
                            productId: deal['product']['id'],
                          ));
                          CartBottomSheet.show();
                        }
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 18,
                      ))))
        ],
      ),
    );
  }

  Widget _buildRecentlyViewed(Map<String, dynamic> widget) {
    final type = widget['type'];

    final style = widget['style'];
    final title =  widget['label'];
    final products = widget['data']['data'] as List;


    return Container(
      // color: Colors.white, .
    /*  margin:
          const EdgeInsets.symmetric(vertical:  20.0),*/
        margin:
          EdgeInsets.symmetric(vertical: style['margin']?.toDouble() ?? 20.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             children: [
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$title',
                  // 'Trending Products',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),

                  /*    style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),*/
                ),
                         ),

             ],
           ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180.0,
            // height: style['height']?.toDouble() ?? 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: style['spacing']?.toDouble() ?? 20.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    final productJson = {
                      '_id': product['id'],
                      // other fields if needed
                    };

                    Get.toNamed('/product-details', arguments: productJson);
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      right: style['spacing']?.toDouble() ?? 20.0,
                      bottom: 6
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        6.0,
                        // style['cardStyle']['borderRadius']?.toDouble() ?? 16.0,
                        // 10.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        style['cardStyle']['borderRadius']?.toDouble() ?? 16.0,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          product['image']==null?Center(
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ):   Padding(
                            padding: const EdgeInsets.only(top: 22,bottom: 42,),
                            child: CachedNetworkImage(
                              imageUrl: product['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                          /*   Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),*/
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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

        ],
      ),
    );
  }
  Widget _buildRecentlyViewedCategoryWidget(Map<String, dynamic> widget) {
    final type = widget['type'];

    final title =  widget['label'];
    final id =  widget['id'];
    final products = widget['data']['data'] as List;


    return Container(
      // color: Colors.white, .
    /*  margin:
          const EdgeInsets.symmetric(vertical:  20.0),*/
        margin:
          EdgeInsets.symmetric(vertical:  20.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,

             children: [
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$title',
                  // 'Trending Products',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),

                  /*    style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),*/
                ),
                         ),
               TextButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => CategoryDetailsPage(
                         categoryId: id,
                         categoryName: title, imageUrl: '',
                         // imageUrl:
                         // "http://sonovision.asquare.org.in/images/${item.icon}",
                       ),
                     ),
                   );
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
          const SizedBox(height: 16),
          SizedBox(
            height: 180.0,
            // height: style['height']?.toDouble() ?? 120.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    final productJson = {
                      '_id': product['id'],
                      // other fields if needed
                    };

                    Get.toNamed('/product-details', arguments: productJson);
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      right: 20.0,
                      bottom: 6
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        6.0,
                        // style['cardStyle']['borderRadius']?.toDouble() ?? 16.0,
                        // 10.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                       16.0,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          product['image']==null?Center(
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ):   Padding(
                            padding: const EdgeInsets.only(top: 22,bottom: 42,),
                            child: CachedNetworkImage(
                              imageUrl: product['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                          /*   Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),*/
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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

        ],
      ),
    );
  }


  Widget _buildGroupWidget(BuildContext context, Map<String, dynamic> widget) {
    switch (widget['type']) {
      case 'product':
        return _buildProductGroup(context, widget);

      case 'brand':
        return BrandGrid(group: widget,);

      case 'category':
        return buildCategoryGroupWidget(widget);



      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProductGroup(BuildContext context, Map<String, dynamic> group) {
    final products = group['data'] as List<dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                group['label'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                  onTap: () {
                    print("ONTAP");

                    final staticProduct = {
                      'id': '20250426',
                      'name': 'Galaxy S24',
                      'brand': 'Samsung',
                      'category': 'Mobile Phones',
                      'categoryId': 'mobile_phones',
                      'price': 150000,
                      'discountPercentage': 10,
                      'description': 'Samsung galaxy S24',
                      'highlights': 'SPen AI',
                      'deliveryTime': '7-10 days',
                      'isFeatured': true,
                      'colors': [
                        'Red',
                        'Black',
                        'White',
                        'Blue',
                        'Green',
                        'Grey'
                      ],
                      'images': [
                        'https://sonovision.in/wp-content/uploads/2022/08/samsung-s225g-white.jpg'
                      ],
                      'stock': 80,
                      'storeCode': 'SONO55',
                      'specifications': {
                        'battery': '6700',
                        'display': 'Amoled',
                        'displaySize': '6.7',
                        'frontCamera': '56',
                        'mainCamera': '68',
                        'networkType': '5G',
                        'os': 'Android',
                        'processor': 'Exzonys',
                        'ram': '12',
                        'storage': '250'
                      }
                    };

                    Get.toNamed('/product-details', arguments: staticProduct);

                    print("ONTAP2");
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        Stack(children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: product['image'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product['discount'],
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ),
                        ]),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '₹${product['price']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹${product['strikeOffPrice']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product['rating'].toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }

  String? _addressLine1 = "Fetching...";
  String? _addressLine2 = "";
  String? _city;
  String? _postalCode;

  var latitude = 0.0;
  var longitude = 0.0;

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        print(
            'Full Address: ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}');

        setState(() {
          _addressLine1 = place.street;
          _addressLine2 = place.subLocality;
          _city = place.locality;
          _postalCode = place.postalCode;
        });
      }
    } catch (e) {
      print('Failed to get address: $e');
    }
  }

  Widget profileWidget(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  controller.getCurrentLocation();
                },
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Text(
                      'Fetching...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    );
                  }
                  return Text(
                    textAlign: TextAlign.start,
                    controller.addressLine1.value,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.white,
                          fontSize: 14,
                        ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  Get.to(SearchPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.search_outlined,
                        color: Colors.black,
                        size: 20,
                      ),

                      // Icon(Icons.search_rounded, color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          //style['placeholder'] ??
                          'Search "Product","Categories"..',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: IconButton(
                onPressed: () {
                  controller.getCurrentLocation();
                },
                icon: const Icon(Icons.location_on),
                color: Colors.white.withOpacity(0.9),
                iconSize: 20,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: IconButton(
                onPressed: () {
                  Get.to(() => NotificationPage(), transition: Transition.rightToLeft);
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 6),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: IconButton(
                onPressed: () {
                  if (AuthController.to.token.value.isEmpty) {
                    Get.off(const LoginPage());
                    return;
                  }else{
                    Get.to( PremiumProfilePage());

                  }
                  // controller.getCurrentLocation();
                },
                icon: const Icon(Icons.person_outlined),
                color: Colors.black,
                iconSize: 20,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
