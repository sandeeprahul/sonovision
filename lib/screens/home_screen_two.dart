import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import '../controllers/home_controller.dart';
import '../utils/CartHelper.dart';
import '../utils/cart_bottom_sheet.dart';
import '../utils/loadImageBasedOnExtension.dart';
import '../widgets/_buildCategoryGroup.dart';
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
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.error.isNotEmpty) {
                return _buildErrorWidget(controller);
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildHomeContent(context, controller),
              );
            }),
          ),
        ],
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
    final widgets = controller.homeData.value['widgets'] as List<dynamic>;
    final saleEndTime =
        DateTime.parse(controller.homeData.value['saleEndTime']);

    return RefreshIndicator(
      onRefresh: () {
        return controller.refreshHomeData();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Add SliverAppBar
          SliverAppBar(
            expandedHeight: 170.0,
            backgroundColor: Colors.transparent,
            // backgroundColor: Colors.grey.withAlpha(2),
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              // collapseMode: CollapseMode.pin,
              background: Stack(
                children: [
                  profileWidget(context),

/*
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      textAlign: TextAlign.start,
                      'Your Hub for\nSmart Electronics', // Replace with dynamic username if needed
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        fontSize: 24
                      ),
                    ),
                  ),*/
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
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _buildDynamicWidget(context, widget),
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
        return FlashSaleWidget(
          widgetData: widget,
        );

      case 'group':
        return _buildGroupWidget(context, widget);
      case 'banners':
        final bannerData = widget['data']?['data'] ?? [];
        final style = widget['style'] ?? {};

        return BannerCarouselNew(banners: bannerData, style: style);
      case 'dealOfDay':
        return _buildDealOfDay(widget);
    /*  case 'brandStrip':
        return buildBrandStripWidget(widget);*/
      case 'recentlyViewed':
        return _buildRecentlyViewed(widget);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDealOfDay(Map<String, dynamic> widget) {
    final style = widget['style'];
    final deal = widget['data'];

    return Container(
      margin:
          EdgeInsets.symmetric(vertical: style['margin']?.toDouble() ?? 8.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  // textAlign: TextAlign.center,
                  'Deal of the Day',
                  style: TextStyle(
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
                print("PRODUCT ID: ${deal['product']['id']}");
                  var productJson = {
                    '_id': deal['product']['id'],
                    // other fields if needed
                  };

                  Get.toNamed('/product-details', arguments: productJson);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      style['cardStyle']['borderRadius']?.toDouble() ?? 16.0,
                    ),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
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
                                  children: [
                                    Text(
                                      '₹${deal['product']?['price']}' ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '\$${deal['product']?['strikePrice']}' ??
                                          '',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        decoration: TextDecoration.lineThrough,
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
                        top: 16,
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
                            '${deal['product']?['discount']}% OFF' ?? '',
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
                        CartHelper.addToCart(
                          productId: '680ef09a4fbe39d34f56dd7d',
                          name: 'Galaxy S24',
                          image:
                              'https://sonovision.in/wp-content/uploads/2022/08/samsung-s225g-white.jpg',
                          color: 'Black',
                          price: 150000.0,
                        );
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
    final style = widget['style'];
    final products = widget['data']['data'] as List;

    return Container(
      margin:
          EdgeInsets.symmetric(vertical: style['margin']?.toDouble() ?? 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recently Viewed',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),

              /*    style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),*/
            ),
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
                  onTap: (){
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
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        style['cardStyle']['borderRadius']?.toDouble() ?? 16.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
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
                          CachedNetworkImage(
                            imageUrl: product['image'],
                            fit: BoxFit.contain,
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

      case 'category':
        return buildCategoryGroupWidget(widget);
      /*   case 'category':
        return _buildCategoryGroup(widget);*/

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSearchBar() {
    return const AnimatedSearchBar(
      style: {
        "margin": 16,
        "height": 56,
        "borderRadius": 20,
        "placeholder": "Search products, categories...",
      },
    );
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

  Future<void> _getCurrentLocation() async {
    // Request location permission
    var status = await Permission.location.request();

    if (status.isGranted) {
      try {
        // Use platform-specific location settings
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 0,
        );
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
        _getAddressFromLatLng(latitude, longitude);
      } catch (e) {
        Get.snackbar('Error', 'Could not get location: $e');
      }
    } else if (status.isDenied) {
      Get.defaultDialog(
        title: "Permission Denied",
        middleText:
            "Location permission is required to get your current position.",
        confirm: ElevatedButton(
          onPressed: () {
            openAppSettings(); // Open settings to enable manually
            Get.back();
          },
          child: const Text("Open Settings"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      Get.defaultDialog(
        title: "Permission Permanently Denied",
        middleText: "Please enable location permission from app settings.",
        confirm: ElevatedButton(
          onPressed: () {
            openAppSettings();
            Get.back();
          },
          child: const Text("Open Settings"),
        ),
        cancel: TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
      );
    }
  }

  Widget profileWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.05),
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
          padding: const EdgeInsets.all(12),

          child: Stack(

            children: [
              const Positioned(
                right: 20,
                bottom: 20,
                child: Icon(
                  Icons.graphic_eq,
                  size: 150,
                  color: Colors.white24,
                ),
              ),
              Column(
                // mainAxisSize: MainAxisSize.min,
                children: [

                  Stack(
                    children: [
                      // Glassy floating bubble behind

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon(Icons.location_on,color:Colors.white.withOpacity(0.9) ,),
                            IconButton(
                              onPressed: () {
                                _getCurrentLocation();
                              },
                              icon: const Icon(Icons.location_on),
                              color: Colors.white.withOpacity(0.9),
                              iconSize: 20,
                            ),
                            // const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                _getCurrentLocation();
                              },
                              child: TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: Colors.transparent,
                                ),
                                label: Text(
                                  '$_addressLine1, $_addressLine2',
                                  style:
                                      Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            // decoration: TextDecoration.underline,
                                            // decorationColor: Colors.white,
                                            fontSize: 12,
                                          ),
                                ),
                                iconAlignment: IconAlignment.end,
                              ),
                            ),

                            const Spacer(),
                            InkWell(
                              onTap: (){
                                Get.to(() => NotificationsPage());

                              },
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(

                                    colors: [

                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.2),
                                    ],
                                  ),
                                ),
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.transparent,
                                  child: ClipOval(
                                      child: Icon(Icons
                                          .notifications) /*Image.network(
                                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=2576&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.cover,
                                    ),*/
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const AnimatedSearchBar(
                    style: {
                      "margin": 16,
                      "height": 56,
                      "borderRadius": 20,
                      "placeholder": "Search products, categories...",
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileWidgetd() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      height: 156,
      child: Stack(
        children: [
          /*         Positioned(
            right: -12,bottom: -12,
              child
              :  CircleAvatar(radius: 56,backgroundColor: Colors.blue.shade900,)),*/
          const Positioned(
            right: -36,
            bottom: -36,
            child: RotatedBox(
                quarterTurns: 90,
                child: Icon(
                  Icons.bubble_chart,
                  size: 200,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    )),
                Text(
                  'Hi,Sahithi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                      child: Image.network(
                          width: 60,
                          // Must be equal to or smaller than CircleAvatar diameter
                          height: 60,
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=2576&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
