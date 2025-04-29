import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerCarousel extends StatelessWidget {
  final List<dynamic> banners;
  final Map<String, dynamic> style;

  const BannerCarousel({
    Key? key,
    required this.banners,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardStyle = style['cardStyle'] ?? {};
    final overlayGradient = cardStyle['overlayGradient'] ?? {};
    final titleStyle = cardStyle['titleStyle'] ?? {};
    final subtitleStyle = cardStyle['subtitleStyle'] ?? {};

    return SizedBox(
      // margin: EdgeInsets.all(style['margin']?.toDouble() ?? 16.0),
      height: style['height']?.toDouble() ?? 220.0,
      child: CarouselSlider.builder(
        itemCount: banners.length,
        options: CarouselOptions(
          height: style['height']?.toDouble() ?? 220.0,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.955,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        itemBuilder: (context, index, realIndex) {
          final banner = banners[index];
          final borderRadius = BorderRadius.circular(
              cardStyle['borderRadius']?.toDouble() ?? 20.0);

          return Material(
            // elevation: cardStyle['elevation']?.toDouble() ?? 8.0,
            // borderRadius: borderRadius,
            borderRadius: BorderRadius.circular(24),

            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.network(
                  banner['image'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _parseColor(overlayGradient['start']) ??
                            Colors.transparent,
                        _parseColor(overlayGradient['end']) ??
                            Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Badge (top-right default)
                if (banner['badge'] != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            _parseColor(banner['badge']['color']) ?? Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        banner['badge']['text'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),

                // Text content
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner['title'] ?? '',
                        style: TextStyle(
                          color:
                              _parseColor(titleStyle['color']) ?? Colors.white,
                          fontSize: 20,
                          // fontSize: titleStyle['fontSize']?.toDouble() ?? 22,
                          fontWeight:
                              _parseFontWeight(titleStyle['fontWeight']) ??
                                  FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        banner['subtitle'] ?? '',
                        style: TextStyle(
                          color: _parseColor(subtitleStyle['color']) ??
                              Colors.white70,
                          fontSize: 14,
                          // fontSize: subtitleStyle['fontSize']?.toDouble() ?? 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Converts rgba or hex strings to Color
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;

    if (colorString.startsWith('#')) {
      colorString = colorString.replaceFirst('#', '');
      if (colorString.length == 6) {
        colorString = 'FF$colorString';
      }
      return Color(int.parse('0x$colorString'));
    }

    if (colorString.startsWith('rgba')) {
      final rgba =
          colorString.replaceAll(RegExp(r'rgba|\(|\)|\s'), '').split(',');
      if (rgba.length == 4) {
        return Color.fromRGBO(
          int.parse(rgba[0]),
          int.parse(rgba[1]),
          int.parse(rgba[2]),
          double.parse(rgba[3]),
        );
      }
    }

    return null;
  }

  FontWeight? _parseFontWeight(String? weight) {
    switch (weight?.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      default:
        return null;
    }
  }
}

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
