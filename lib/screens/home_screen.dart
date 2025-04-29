// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../widgets/home_widgets/search_widget.dart';
// import '../widgets/home_widgets/quick_links_widget.dart';
// import '../widgets/home_widgets/banner_widget.dart';
// import '../widgets/home_widgets/category_grid_widget.dart';
// import '../widgets/home_widgets/deal_of_day_widget.dart';
// import '../widgets/home_widgets/brand_strip_widget.dart';
// import '../widgets/home_widgets/flash_sale_widget.dart';
// import '../widgets/home_widgets/product_grid_widget.dart';
// import '../widgets/home_widgets/new_launches_widget.dart';
// import '../widgets/home_widgets/bundle_deals_widget.dart';
// import '../widgets/home_widgets/recently_viewed_widget.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   Map<String, dynamic>? _homeData;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadHomeData();
//   }
//
//   Future<void> _loadHomeData() async {
//     try {
//       final String jsonString = await rootBundle.loadString('assets/new_home.json');
//       setState(() {
//         _homeData = json.decode(jsonString);
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       debugPrint('Error loading home data: $e');
//     }
//   }
//
//   Widget _buildWidget(Map<String, dynamic> widget) {
//     switch (widget['widgetType']) {
//       case 'search':
//         return SearchWidget(style: widget['style']);
//
//       case 'quickLinks':
//         return QuickLinksWidget(
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'banners':
//         return BannerWidget(
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'group':
//         if (widget['type'] == 'category') {
//           return CategoryGridWidget(
//             label: widget['label'],
//             style: widget['style'],
//             data: widget['data'],
//           );
//         } else if (widget['type'] == 'product') {
//           return ProductGridWidget(
//             label: widget['label'],
//             style: widget['style'],
//             data: widget['data'],
//           );
//         }
//         return const SizedBox.shrink();
//
//       case 'dealOfDay':
//         return DealOfDayWidget(
//           label: widget['label'],
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'brandStrip':
//         return BrandStripWidget(
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'flashSale':
//         return FlashSaleWidget(
//           label: widget['label'],
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'newLaunches':
//         return NewLaunchesWidget(
//           label: widget['label'],
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'bundleDeals':
//         return BundleDealsWidget(
//           label: widget['label'],
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       case 'recentlyViewed':
//         return RecentlyViewedWidget(
//           label: widget['label'],
//           style: widget['style'],
//           data: widget['data'],
//         );
//
//       default:
//         return const SizedBox.shrink();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (_homeData == null) {
//       return const Center(child: Text('Failed to load home data'));
//     }
//
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: _loadHomeData,
//         child: ListView.builder(
//           itemCount: _homeData!['widgets'].length,
//           itemBuilder: (context, index) {
//             final widget = _homeData!['widgets'][index];
//             return _buildWidget(widget);
//           },
//         ),
//       ),
//     );
//   }
// }