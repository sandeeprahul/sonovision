import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import '../controllers/home_controller.dart';
import 'animated_hint_textfield_widget.dart';

class HomeScreenTwo extends StatefulWidget {
  const HomeScreenTwo({Key? key}) : super(key: key);

  @override
  State<HomeScreenTwo> createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  final List<Map<String, dynamic>> banners = [
    {'title': 'Big Sale Today!', 'color': Colors.redAccent},
    {'title': 'New Products', 'color': Colors.green},
    {'title': 'Exclusive Offers!', 'color': Colors.blueAccent},
  ];

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: SafeArea(
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

    return SingleChildScrollView(
      child: Stack(
        children: [
          profileWidget(),
          Column(
            children: [
              const SizedBox(
                height: 76,
              ),
              _buildSearchBar(),
              ...widgets
                  .map((widget) =>
                      _buildDynamicWidget(context, widget, saleEndTime))
                  .toList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicWidget(
      BuildContext context, Map<String, dynamic> widget, DateTime saleEndTime) {
    switch (widget['widgetType']) {
      case 'banners':
        return _buildBanners(widget['data'] as List<dynamic>);

      case 'sale':
        return _buildSaleBanner(
            widget['data'] as Map<String, dynamic>, saleEndTime);

      case 'group':
        return _buildGroupWidget(context, widget);

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGroupWidget(BuildContext context, Map<String, dynamic> widget) {
    switch (widget['type']) {
      case 'product':
        return _buildProductGroup(context, widget);

      case 'category':
        return _buildCategoryGroup(widget);

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          child: const AnimatedHintTextField()),
    );
  }

  Widget _buildBannersssssss(List<dynamic> banners) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      height: 76,
      // color: Colors.white,
      child: CarouselSlider.builder(
        itemCount: banners.length,
        options: CarouselOptions(
          height: 76,
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        itemBuilder: (context, index, realIndex) {
          final banner = banners[index];
          return Container(
            // margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: banner['image'],
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBanners(List<dynamic> bannersssss) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 16),
      height: 76,
      child: CarouselSlider.builder(
        itemCount: banners.length,
        options: CarouselOptions(
          height: 76,
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        itemBuilder: (context, index, realIndex) {
          final banner = banners[index];
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: banner['color'], // expects Color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              banner['title'], // expects a String title
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaleBanner(Map<String, dynamic> saleData, DateTime saleEndTime) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: saleData['image'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flash Sale',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Up to 50% off',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCountdownTimer(saleEndTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGroup(BuildContext context, Map<String, dynamic> group) {
    final products = group['data'] as List<dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,),
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
        SizedBox(height: 12,),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
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
                    Stack(
                      children: [
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
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'],
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                      decoration: TextDecoration.lineThrough,
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
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGroup(Map<String, dynamic> group) {
    final categories = group['data'] as List<dynamic>;
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final itemWidth = (screenWidth - (5 * 16)) / 4;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, ),
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
                      'See all',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ))
              ],
            ),
          ),
          SizedBox(height: 6,),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(6),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: itemWidth,
                height: itemWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: itemWidth * 0.8,
                      height: itemWidth * 0.8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: category['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildCountdownTimer(DateTime endTime) {
    return StreamBuilder<DateTime>(
      stream:
          Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final difference = endTime.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes.remainder(60);
        final seconds = difference.inSeconds.remainder(60);

        return Row(
          children: [
            _buildTimeBox(hours.toString().padLeft(2, '0'), 'H'),
            const Text(':', style: TextStyle(color: Colors.white)),
            _buildTimeBox(minutes.toString().padLeft(2, '0'), 'M'),
            const Text(':', style: TextStyle(color: Colors.white)),
            _buildTimeBox(seconds.toString().padLeft(2, '0'), 'S'),
          ],
        );
      },
    );
  }

  Widget _buildTimeBox(String time, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget profileWidget() {
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
                IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.white,)),
                Text('Hi,Sahithi',    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                      child: Image.network(
                          width: 60, // Must be equal to or smaller than CircleAvatar diameter
                          height: 60,
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=2576&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D')),
                ),
                const SizedBox(width: 8,),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
