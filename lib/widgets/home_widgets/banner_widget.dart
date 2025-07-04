import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';


import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

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
    // Calculate height based on screen size for better visual appeal
    final double screenHeight = MediaQuery.of(context).size.height;
    final double height = screenHeight * 0.28; // 28% of screen height

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
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          CarouselSlider.builder(
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
                  final productId = Uri.parse(deepLink ?? '').pathSegments.last;
                  var productJson = {'_id': productId};
                  Get.toNamed('/product-details', arguments: productJson);
                },
                child: Material(
                  // elevation: elevation,
                  borderRadius: BorderRadius.circular(12),
                  // color: Theme.of(context).colorScheme.surface,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      // Image with shimmer loading effect
                      Padding(

                        padding: const EdgeInsets.only(bottom: 56,left: 12,right: 12,top: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.surfaceContainer,
                                    Theme.of(context).colorScheme.surfaceContainerHighest,
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (ctx, url, error) => Icon(
                              Icons.error,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ),


                      Positioned(
                        bottom: 0,
                        left: 0,right: 0,
                        child: SizedBox(
                          height: 60,
                          // width: MediaQuery.of(context).size.width/1.2,
                          child: Container(
                            // margin: EdgeInsets.only(bottom: ,left: 2,right: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular( 12.0),

                                // color: Colors.black

                            ),
                            // padding: const EdgeInsets.all(20.0),
                            child: Column(
                              // mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Title with Material 3 typography
                                Text(
                                  // title ?? '',
                                  title.length > 35 ? '${title.substring(0, 35)}...' : title,
                                  maxLines: 1,

                                  overflow: TextOverflow.ellipsis,

                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontSize: 14,

                                    fontWeight: _parseFontWeight(titleStyle['fontWeight']) ?? FontWeight.bold,
                                    /*color: _parseColor(titleStyle['color']) ??
                                        Theme.of(context).colorScheme.onSurface,*/
                                      color: Colors.black

                                  ),
                                ),
                                const SizedBox(height: 2),

                                // Subtitle with Material 3 typography
                                Text(
                                  subtitle ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                 color: Colors.black
                                 /*   color: _parseColor(subtitleStyle['color']) ??

                                        Theme.of(context).colorScheme.onSurface.withOpacity(0.8),*/
                                  ),
                                ),
                                const SizedBox(height: 2),

                              ],
                            ),
                          ),
                        ),
                      ),

                      // Badge with Material 3 shape
                      if (badge != null)
                        Positioned(
                          top: badge['position'] == 'top-right' ? 16 : null,
                          bottom: badge['position'] == 'bottom-right' ? 16 : null,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _parseColor(badge['color']) ??
                                  Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              badge['text'] ?? '',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: _parseColor(badge['textColor']) ??
                                    Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              height: 280,
              // height: height,
              aspectRatio: aspectRatio,
              enableInfiniteScroll: true,
              viewportFraction: 1.0,
              enlargeCenterPage: true,
              enlargeFactor: 0.2,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              padEnds: false,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              pauseAutoPlayOnTouch: true,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods remain the same
  Color? _parseColor(String? colorString) {
    if (colorString == null) return null;

    if (colorString.toLowerCase() == 'transparent') {
      return Colors.transparent;
    }

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

    colorString = colorString.replaceAll('#', '');
    if (colorString.length == 6) {
      colorString = 'FF$colorString';
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



