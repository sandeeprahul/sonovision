import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';


import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerCarouselNew extends StatelessWidget {
  final List<dynamic> banners;
  final Map<String, dynamic> style;

  const BannerCarouselNew({
    Key? key,
    required this.banners,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = (style['height'] ?? 220).toDouble();
    final double aspectRatio = (style['aspectRatio'] ?? 2.5).toDouble();
    final double margin = (style['margin'] ?? 20).toDouble();
    final double spacing = (style['spacing'] ?? 16).toDouble();
    final cardStyle = style['cardStyle'] ?? {};
    final double borderRadius = (cardStyle['borderRadius'] ?? 20).toDouble();
    final double elevation = (cardStyle['elevation'] ?? 8).toDouble();
    final overlayGradient = cardStyle['overlayGradient'] ?? {};
    final titleStyle = cardStyle['titleStyle'] ?? {};
    final subtitleStyle = cardStyle['subtitleStyle'] ?? {};

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: CarouselSlider.builder(
        itemCount: banners.length,

        itemBuilder: (context, index, _) {
          final banner = banners[index];
          final image = banner['image'];
          final title = banner['title'];
          final subtitle = banner['subtitle'];
          final badge = banner['badge'];
          final deepLink = banner['deeplink'];
          final id = banner['id'];

          return GestureDetector(
            onTap: () {
              // Navigate to product detail with id from deeplink or id
              final productId = Uri.parse(deepLink ?? '').pathSegments.last;

              var productJson = {
                '_id': productId,
                // other fields if needed
              };
              Get.toNamed('/product-details', arguments: productJson);
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // optional

                  child: Image.network(
                    banners[index]['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,              ),
                ),

                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _parseColor(overlayGradient['start']) ?? Colors.transparent,
                        _parseColor(overlayGradient['end']) ?? Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Text & Badge
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: (12).toDouble(),
                          fontWeight: _parseFontWeight(titleStyle['fontWeight']),
                          color: _parseColor(titleStyle['color']) ?? Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle ?? '',
                        style: TextStyle(
                          fontSize: ( 10).toDouble(),
                          color: _parseColor(subtitleStyle['color']) ?? Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badge
                if (badge != null)
                  Positioned(
                    top: badge['position'] == 'top-right' ? 12 : null,
                    bottom: badge['position'] == 'bottom-right' ? 12 : null,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _parseColor(badge['color']) ?? Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badge['text'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          height: height,
          aspectRatio: aspectRatio,
          enableInfiniteScroll: true,
          viewportFraction: 0.999,
          enlargeCenterPage: true,
          padEnds: false,

        ),
      ),
    );
  }

  // Helper methods
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;

    if (colorString.toLowerCase() == 'transparent') {
      return Colors.transparent;
    }

    // Handle rgba(r,g,b,a)
    if (colorString.startsWith('rgba')) {
      final match = RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([\d.]+)\)').firstMatch(colorString);
      if (match != null) {
        final r = int.parse(match.group(1)!);
        final g = int.parse(match.group(2)!);
        final b = int.parse(match.group(3)!);
        final a = (double.parse(match.group(4)!) * 255).round();
        return Color.fromARGB(a, r, g, b);
      }
    }

    // Handle hex: #RRGGBB or #AARRGGBB
    colorString = colorString.replaceAll('#', '');
    if (colorString.length == 6) {
      colorString = 'FF$colorString'; // Add full alpha if missing
    }
    return Color(int.parse(colorString, radix: 16));
  }

  FontWeight _parseFontWeight(dynamic weight) {
    switch (weight?.toString().toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w600':
        return FontWeight.w600;
      case 'normal':
      default:
        return FontWeight.normal;
    }
  }
}


// class BannerCarousel extends StatelessWidget {
//   final List<dynamic> banners;
//   final Map<String, dynamic> style;
//
//   const BannerCarousel({
//     Key? key,
//     required this.banners,
//     required this.style,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final cardStyle = style['cardStyle'] ?? {};
//     final overlayGradient = cardStyle['overlayGradient'] ?? {};
//     final titleStyle = cardStyle['titleStyle'] ?? {};
//     final subtitleStyle = cardStyle['subtitleStyle'] ?? {};
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.yellow,
//       ),
//       // margin: EdgeInsets.all(style['margin']?.toDouble() ?? 16.0),
//       height:  170.0,
//       // height: style['height']?.toDouble() ?? 220.0,
//       child: CarouselSlider.builder(
//
//         itemCount: banners.length,
//         options: CarouselOptions(
//           // height: style['height']?.toDouble() ?? 220.0,
//           autoPlay: true,
//
//           enlargeCenterPage: true,
//           // viewportFraction: 0.955,
//           autoPlayInterval: const Duration(seconds: 3),
//         ),
//         itemBuilder: (context, index, realIndex) {
//           final banner = banners[index];
//           final borderRadius = BorderRadius.circular(
//               cardStyle['borderRadius']?.toDouble() ?? 20.0);
//
//           return InkWell(
//             onTap: (){
//               final staticProduct = {
//                 '_id': banner['id'],
//               };
//
//
//               Get.toNamed('/product-details', arguments: staticProduct);
//             },
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 // Background image
//                 Image.network(
//                   banner['image'],
//                   // banner['image'],
//                   fit: BoxFit.cover,
//                   loadingBuilder: (context, child, progress) {
//                     if (progress == null) return child;
//                     return const Center(child: CircularProgressIndicator());
//                   },
//                 ),
//
//                 // Gradient overlay
//               /*  Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         _parseColor(overlayGradient['start']) ??
//                             Colors.transparent,
//                         _parseColor(overlayGradient['end']) ??
//                             Colors.black.withOpacity(0.7),
//                       ],
//                     ),
//                   ),
//                 ),*/
//
//                 // Badge (top-right default)
//                 if (banner['badge'] != null)
//                   Positioned(
//                     top: 12,
//                     right: 12,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color:
//                             _parseColor(banner['badge']['color']) ?? Colors.red,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         banner['badge']['text'],
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 10,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 // Text content
//                 Positioned(
//                   left: 16,
//                   right: 16,
//                   bottom: 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         banner['title'] ?? '',
//                         style: TextStyle(
//                           color:
//                               _parseColor(titleStyle['color']) ?? Colors.white,
//                           fontSize: 10,
//                           // fontSize: titleStyle['fontSize']?.toDouble() ?? 22,
//                           fontWeight:
//                               _parseFontWeight(titleStyle['fontWeight']) ??
//                                   FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         banner['subtitle'] ?? '',
//                         style: TextStyle(
//                           color: _parseColor(subtitleStyle['color']) ??
//                               Colors.white70,
//                           fontSize: 8,
//                           // fontSize: subtitleStyle['fontSize']?.toDouble() ?? 18,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // Converts rgba or hex strings to Color
//   Color? _parseColor(String? colorString) {
//     if (colorString == null) return null;
//
//     if (colorString.startsWith('#')) {
//       colorString = colorString.replaceFirst('#', '');
//       if (colorString.length == 6) {
//         colorString = 'FF$colorString';
//       }
//       return Color(int.parse('0x$colorString'));
//     }
//
//     if (colorString.startsWith('rgba')) {
//       final rgba =
//           colorString.replaceAll(RegExp(r'rgba|\(|\)|\s'), '').split(',');
//       if (rgba.length == 4) {
//         return Color.fromRGBO(
//           int.parse(rgba[0]),
//           int.parse(rgba[1]),
//           int.parse(rgba[2]),
//           double.parse(rgba[3]),
//         );
//       }
//     }
//
//     return null;
//   }
//
//   FontWeight? _parseFontWeight(String? weight) {
//     switch (weight?.toLowerCase()) {
//       case 'bold':
//         return FontWeight.bold;
//       case 'w500':
//         return FontWeight.w500;
//       case 'w600':
//         return FontWeight.w600;
//       default:
//         return null;
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class BannerWidget extends StatefulWidget {
//   final Map<String, dynamic> style;
//   final List<dynamic> data;
//
//   const BannerWidget({
//     super.key,
//     required this.style,
//     required this.data,
//   });
//
//   @override
//   State<BannerWidget> createState() => _BannerWidgetState();
// }
//
// class _BannerWidgetState extends State<BannerWidget> {
//   int _currentIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(
//         vertical: widget.style['margin']?.toDouble() ?? 16,
//       ),
//       child: Column(
//         children: [
//           CarouselSlider.builder(
//             itemCount: widget.data.length,
//             options: CarouselOptions(
//               height: widget.style['height']?.toDouble() ?? 180,
//               aspectRatio: widget.style['aspectRatio']?.toDouble() ?? 2.5,
//               viewportFraction: 0.92,
//               enlargeCenterPage: true,
//               autoPlay: true,
//               onPageChanged: (index, reason) {
//                 setState(() => _currentIndex = index);
//               },
//             ),
//             itemBuilder: (context, index, realIndex) {
//               final banner = widget.data[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 15,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Stack(
//                     children: [
//                       Image.network(
//                         banner['image'],
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             color: Colors.grey[200],
//                             child: const Icon(Icons.error_outline, size: 40),
//                           );
//                         },
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.7),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 20,
//                         left: 20,
//                         right: 20,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               banner['title'],
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               banner['subtitle'],
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: widget.data.asMap().entries.map((entry) {
//               return Container(
//                 width: 8,
//                 height: 8,
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _currentIndex == entry.key
//                       ? Theme.of(context).primaryColor
//                       : Colors.grey[300],
//                 ),
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
