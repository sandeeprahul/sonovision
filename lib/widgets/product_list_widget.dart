// import 'package:electronic_store/widgets/product_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../models/product.dart';
// import '../screens/home_screen_two.dart';
//
// class ProductList extends StatelessWidget {
//   final String title;
//   final List<Product> products;
//   final int listType;
//
//   const ProductList({
//     Key? key,
//     required this.title,
//     required this.products,
//     required this.listType,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pushNamed(
//                   context,
//                   '/products',
//                   arguments: {'title': title, 'products': products},
//                 ),
//                 child: Text('See All'),
//               ),
//             ],
//           ),
//         ),
//         if (listType == 0) _buildHorizontalList(),
//         if (listType == 1) _buildVerticalList(),
//         if (listType == 2) _buildStaggeredList(),
//       ],
//     );
//   }
//
//   Widget _buildHorizontalList() {
//     return SizedBox(
//       height: 280,
//       child: ListView.builder(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//         scrollDirection: Axis.horizontal,
//         itemCount: products.length,
//         itemBuilder: (context, index) => ProductCard(
//           product: products[index],
//           width: 180,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVerticalList() {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       itemCount: products.length,
//       itemBuilder: (context, index) => ProductCard(
//         product: products[index],
//         isHorizontal: true,
//       ),
//     );
//   }
//   Widget _buildStaggeredList() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: StaggeredGrid.count(
//         crossAxisCount: 2,
//         mainAxisSpacing: 16,
//         crossAxisSpacing: 16,
//         children: products.map((product) {
//           return StaggeredGridTile.fit(
//             crossAxisCellCount: 1,
//             child: ProductCard(
//               product: product,
//               width: double.infinity,
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
