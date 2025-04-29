import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../utils/loadImageBasedOnExtension.dart'; // Assuming you're using GetX for routing

Widget buildBrandStripWidget(Map<String, dynamic> widget) {
  final style = widget['style'];
  final brands = widget['data']['data'] as List;
  final cardStyle = style['cardStyle'];
  final double borderRadius = cardStyle['borderRadius']?.toDouble() ?? 16.0;
  final double padding = cardStyle['padding']?.toDouble() ?? 16.0;
  final double scaleOnTap =
      cardStyle['animation']?['scale']?.toDouble() ?? 1.05;
  final int animationDuration =
      cardStyle['animation']?['duration']?.toInt() ?? 200;
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  return SizedBox(
    // height: 120.0,
    height: style['height']?.toDouble() ?? 140.0,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
          horizontal: style['spacing']?.toDouble() ?? 20.0),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        final brand = brands[index];
        final gradient = brand['gradient'];
        final heroTag = "brandLogo_${brand['id']}";

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick(); // Haptic feedback
            /*   Get.to(() => BrandDetailPage(
              brand: brand,
              heroTag: heroTag,
            )); */ // Navigate to detail page using deepLink
          },
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: animationDuration),
            tween: Tween<double>(begin: 1.0, end: 1.0),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(
                    right: style['spacing']?.toDouble() ?? 20.0,
                    bottom: 12,
                    top: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _hexToColor(gradient['end']),

                    /*  gradient: LinearGradient(
                      colors: [
                        _hexToColor(gradient['start']),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),*/
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Hero(
                            tag: heroTag,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: loadImageBasedOnExtension(
                                brand['logo'],
                                width: 48,
                                height: 48,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(borderRadius),
                                bottomLeft: Radius.circular(borderRadius)),
                            gradient: LinearGradient(
                              colors: [
                                _hexToColor(gradient['start']),
                                _hexToColor(gradient['end']),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          width: double.infinity,
                          child: Text(
                            textAlign: TextAlign.center,
                            brand['count'] ?? '',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}

// import 'package:flutter/material.dart';
//
// class BrandStripWidget extends StatelessWidget {
//   final Map<String, dynamic> style;
//   final List<dynamic> data;
//
//   const BrandStripWidget({
//     super.key,
//     required this.style,
//     required this.data,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: style['height']?.toDouble() ?? 120,
//       margin: EdgeInsets.symmetric(
//         vertical: style['margin']?.toDouble() ?? 16,
//       ),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.symmetric(
//           horizontal: style['margin']?.toDouble() ?? 16,
//         ),
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           final brand = data[index];
//           return Container(
//             width: 100,
//             margin: EdgeInsets.only(
//               right: style['spacing']?.toDouble() ?? 16,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () {
//                   // Navigate using brand['deepLink']
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         height: 48,
//                         width: 48,
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Color(
//                             int.parse(
//                               brand['color'].substring(1, 7),
//                               radix: 16,
//                             ) +
//                             0xFF000000,
//                           ).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Image.network(
//                           brand['logo'],
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(
//                               Icons.business,
//                               color: Color(
//                                 int.parse(
//                                   brand['color'].substring(1, 7),
//                                   radix: 16,
//                                 ) +
//                                 0xFF000000,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         brand['name'],
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         textAlign: TextAlign.center,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
