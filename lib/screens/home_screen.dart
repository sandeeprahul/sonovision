// import 'package:flutter/material.dart';
// import '../widgets/featured_banner.dart';
// import '../widgets/product_group.dart';
// import '../data/sample_data.dart';
// import '../theme/app_theme.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: AppTheme.primaryColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Center(
//                 child: Text(
//                   'E',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text(
//               'ElectroStore',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart_outlined),
//             onPressed: () {},
//           ),
//           IconButton(
//             icon: const Icon(Icons.person_outline),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search electronics...',
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey[100],
//                 ),
//               ),
//             ),
//             FeaturedBanner(banners: SampleData.banners),
//             const SizedBox(height: 24),
//             ProductGroup(
//               title: 'Categories',
//               items: SampleData.categories,
//               isCategory: true,
//             ),
//             const SizedBox(height: 24),
//             ProductGroup(
//               title: 'Flash Deals',
//               items: SampleData.flashDeals,
//               onViewAll: () {},
//             ),
//             const SizedBox(height: 24),
//             ProductGroup(
//               title: 'Weekly Best Sellers',
//               items: SampleData.weeklyBestSellers,
//               onViewAll: () {},
//             ),
//             const SizedBox(height: 24),
//             ProductGroup(
//               title: 'Top Products',
//               items: SampleData.topProducts,
//               onViewAll: () {},
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: AppTheme.primaryColor,
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.category_outlined),
//             activeIcon: Icon(Icons.category),
//             label: 'Categories',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_outline),
//             activeIcon: Icon(Icons.favorite),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart_outlined),
//             activeIcon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             activeIcon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
