import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class FlashSaleWidget extends StatelessWidget {
  final Map<String, dynamic> widgetData;

  const FlashSaleWidget({super.key, required this.widgetData});

  @override
  Widget build(BuildContext context) {
    final style = widgetData['style'];
    final products = widgetData['data']['products'] as List;
    final endTime = DateTime.parse(widgetData['data']['endTime']);

    return Container(
      margin: EdgeInsets.symmetric(vertical: (style['margin'] ?? 20.0).toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(endTime),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            // height: (style['height'] ?? 280.0).toDouble(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: (style['spacing'] ?? 20.0).toDouble()),
              separatorBuilder: (_, __) => SizedBox(width: (style['spacing'] ?? 16.0).toDouble()),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(context, products[index], style['cardStyle']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime endTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Flash Sale',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
          ),
          // _buildCountdownTimer(endTime),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(DateTime endTime) {
    final remaining = endTime.difference(DateTime.now());
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[600],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$hours:$minutes:$seconds',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product, Map<String, dynamic> cardStyle) {
    final borderRadius = (cardStyle['borderRadius'] ?? 16.0).toDouble();
    final padding = (cardStyle['padding'] ?? 12.0).toDouble();
    final badge = cardStyle['badge'];
    final progressBar = cardStyle['progressBar'];

    final stockLeft = product['stockLeft'] ?? 0;
    final stockTotal = 100.0; // you may replace this with real total stock
       final remainingText = '${stockLeft.toInt()} left';

    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: product['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: badge['position'] == 'top-left' ? 8 : null,
                right: badge['position'] == 'top-right' ? 8 : null,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(_hexToColor(badge['color'])),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    remainingText,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),

              Positioned(
                left: badge['position'] == 'top-left' ? 8 : null,
                right: badge['position'] == 'top-right' ? 8 : null,
                bottom: 8,
                child:  Container(
                  padding: const EdgeInsets.only(left: 12,right: 12,top: 2,bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: const Row(
                    children: [
                      Text('4.2',style: TextStyle(fontSize: 10,color: Colors.black),),
                      Icon(Icons.star_border_rounded,size: 12,color: Colors.blue,)
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${product['flashPrice']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${product['price']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                // _buildProgressBar(stockLeft, stockTotal, progressBar,borderRadius)
                /*
                const SizedBox(height: 6),
                _buildProgressBar(stockLeft, stockTotal, progressBar),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double stockLeft, double stockTotal, Map<String, dynamic> progressBar, borderRadius) {
    final percent = 1.0 - (stockLeft / stockTotal);
    final remainingText = '${stockLeft.toInt()} left out of ${stockTotal.toInt()}';

    return Container(
      padding: const EdgeInsets.only(left: 12,right: 12,top: 4,bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.grey.shade100.withOpacity(0.5),
      ),
      child: Text('4.2'),
    );
  }

  int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return int.parse(hex, radix: 16);
  }
}



// import 'package:flutter/material.dart';
//
// class FlashSaleWidget extends StatelessWidget {
//   final String label;
//   final Map<String, dynamic> style;
//   final Map<String, dynamic> data;
//
//   const FlashSaleWidget({
//     super.key,
//     required this.label,
//     required this.style,
//     required this.data,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: style['margin']?.toDouble() ?? 16,
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.bolt,
//                 color: Colors.amber[700],
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//               ),
//               const Spacer(),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to all flash sales
//                 },
//                 child: const Text('View All'),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: style['height']?.toDouble() ?? 240,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: EdgeInsets.symmetric(
//               horizontal: style['margin']?.toDouble() ?? 16,
//               vertical: 8,
//             ),
//             itemCount: data['products'].length,
//             itemBuilder: (context, index) {
//               final product = data['products'][index];
//               return Container(
//                 width: 180,
//                 margin: EdgeInsets.only(
//                   right: style['spacing']?.toDouble() ?? 16,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(12),
//                     onTap: () {
//                       // Navigate using product['deepLink']
//                     },
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(12),
//                               ),
//                               child: Image.network(
//                                 product['image'],
//                                 height: 140,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     height: 140,
//                                     color: Colors.grey[200],
//                                     child: const Icon(Icons.error_outline),
//                                   );
//                                 },
//                               ),
//                             ),
//                             Positioned(
//                               top: 8,
//                               left: 8,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 8,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red,
//                                   borderRadius: BorderRadius.circular(16),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.local_fire_department,
//                                       color: Colors.white,
//                                       size: 16,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     Text(
//                                       '${product['stockLeft']} left',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(12),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product['name'],
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const SizedBox(height: 8),
//                               Row(
//                                 children: [
//                                   Text(
//                                     '₹${product['flashPrice']}',
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     '₹${product['price']}',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       decoration: TextDecoration.lineThrough,
//                                       color: Colors.grey[600],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }