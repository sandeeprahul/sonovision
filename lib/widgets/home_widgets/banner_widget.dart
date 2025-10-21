import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:electronic_store/extensions.dart';
import 'package:electronic_store/price_extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';


import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../product_details_widgets/count_down_timer_widget.dart';

class BannerCarouselNew extends StatefulWidget {
  final List<dynamic> banners;
  final Map<String, dynamic> style;

  const BannerCarouselNew({
    Key? key,
    required this.banners,
    required this.style,
  }) : super(key: key);

  @override
  State<BannerCarouselNew> createState() => _BannerCarouselNewState();
}

class _BannerCarouselNewState extends State<BannerCarouselNew> {
  @override
  Widget build(BuildContext context) {
    // Calculate height based on screen size for better visual appeal
    final double screenHeight = MediaQuery.of(context).size.height;
    final double height = screenHeight * 0.28; // 28% of screen height

    final double aspectRatio = (widget.style['aspectRatio'] ?? 2.5).toDouble();
    final double margin = (widget.style['margin'] ?? 20).toDouble();
    final double spacing = (widget.style['spacing'] ?? 16).toDouble();
    final cardStyle = widget.style['cardStyle'] ?? {};
    final double borderRadius = 6.0;
    // final double borderRadius = (cardStyle['borderRadius'] ?? 20).toDouble();
    final double elevation = (cardStyle['elevation'] ?? 8).toDouble();
    final overlayGradient = cardStyle['overlayGradient'] ?? {};
    final titleStyle = cardStyle['titleStyle'] ?? {};
    final subtitleStyle = cardStyle['subtitleStyle'] ?? {};

    return widget.banners.isEmpty?const SizedBox(): Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          options:CarouselOptions(
            autoPlay: true,
            height: 280,
            aspectRatio: aspectRatio,
            enableInfiniteScroll: true,
            viewportFraction: 0.75, // Show parts of adjacent items
            enlargeCenterPage: true,
            enlargeFactor: 0.39,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            padEnds: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 200),
            pauseAutoPlayOnTouch: true,
          ),
          itemBuilder: (context, index, _) {
            final banner = widget.banners[index];
            final image = banner['image'];
            final title = banner['title'];
            final subtitle = banner['subtitle']
                ?.toString()
                .replaceAll(RegExp(r'[^0-9.]'), '');
            // final subtitle = banner['subtitle'];
            final badge = banner['badge'];
            final deepLink = banner['deeplink'];
            final id = banner['id'];
            // final formattedSubtitle = num.tryParse(subtitle.toString())?.toINR() ?? subtitle.toString();

            final value = num.tryParse(subtitle.toString());
            final formattedSubtitle = value != null
                ? value.toINR() // your extension
                : subtitle.toString();


            return GestureDetector(
              onTap: () {
                final productId = Uri.parse(deepLink ?? '').pathSegments.last;
                var productJson = {'_id': productId};
                Get.toNamed('/product-details', arguments: productJson);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 10), // ⬅️ Margin between items

                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.transparent,
                  // color: Theme.of(context).colorScheme.surface,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      // Image with shimmer loading effect
                      Padding(

                        padding: const EdgeInsets.only(bottom: 62,left: 16,right: 16,top: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: AspectRatio(
                            aspectRatio:3 / 2, // Set your desired aspect ratio here

                            child: CachedNetworkImage(
                              imageUrl: image,
                              // fit: BoxFit.cover,

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
                      ),


                      Positioned(
                        bottom: 0,
                        left: 0,right: 0,
                        child: Container(
                          margin: const EdgeInsets.only(bottom:4 ),
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
                              /*Padding(
                                padding:  const EdgeInsets.only(left: 12,right: 12,top: 12),
                                child: AspectRatio(
                                  aspectRatio:3 / 2, // Set your desired aspect ratio here

                                  child: CachedNetworkImage(
                                    imageUrl: image,
                                    // fit: BoxFit.cover,

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
                              ),*/
                              const SizedBox(height: 6),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  // title ?? '',
                                  title.length > 70 ? '${title.substring(0, 70)}...' : title,

                                textAlign: TextAlign.center,
                                  // title.length > 35 ? '${title.substring(0, 35)}...' : title,
                                  maxLines: 2,

                                  overflow: TextOverflow.ellipsis,

                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontSize: 12,

                                    fontWeight: _parseFontWeight(titleStyle['fontWeight']) ?? FontWeight.bold,
                                    /*color: _parseColor(titleStyle['color']) ??
                                        Theme.of(context).colorScheme.onSurface,*/
                                      color: Colors.black

                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Subtitle with Material 3 typography
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formattedSubtitle ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                   color: Colors.black
                                   /*   color: _parseColor(subtitleStyle['color']) ??

                                          Theme.of(context).colorScheme.onSurface.withOpacity(0.8),*/
                                    ),
                                  ),
                                  const SizedBox(width: 6,),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _parseColor(badge['color']) ??
                                          Theme.of(context).colorScheme.primaryContainer,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF5F6D),
                                          Color(0xFFFFC371),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      badge['text'] ?? '',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: _parseColor(badge['textColor']) ??
                                            Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  )
                                ],
                              ),


                              const SizedBox(height: 6),

                            ],
                          ),
                        ),
                      ),

                      // Badge with Material 3 shape
                      if (badge != null)
                        Visibility(
                          visible: false,
                          child: Positioned(
                            top: badge['position'] == 'top-right' ? 16 : null,
                            //
                            bottom: badge['position'] == 'bottom-right' ? 16 : null,

                            // top: 6 ,
                            // bottom:16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _parseColor(badge['color']) ??
                                    Theme.of(context).colorScheme.primaryContainer,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF5F6D),
                                    Color(0xFFFFC371),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
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
                        ),
                      // Countdown Timer on Top-Right
                   /*   Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            // Title and subtitle...
                            // Text('${saleEnd.day}')
                              CountdownTimer(endTime: saleEnd), // Only one timer
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
              ),
            );
          },

          /*CarouselOptions(
            autoPlay: true,
            height: 280,
            // height: height,
            aspectRatio: aspectRatio,
            enableInfiniteScroll: true,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            padEnds: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 200),
            pauseAutoPlayOnTouch: true,
          ),*/
        ),
      ],
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



