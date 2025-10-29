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

class OffersCarouselNew extends StatefulWidget {
  final List<dynamic> banners;
  final Map<String, dynamic> style;

  const OffersCarouselNew({
    Key? key,
    required this.banners,
    required this.style,
  }) : super(key: key);

  @override
  State<OffersCarouselNew> createState() => _OffersCarouselNewState();
}

class _OffersCarouselNewState extends State<OffersCarouselNew> {
  @override
  Widget build(BuildContext context) {


    // final double aspectRatio = (widget.style['aspectRatio'] ?? 2.5).toDouble();
    // final double margin = (widget.style['margin'] ?? 20).toDouble();
    // final double spacing = (widget.style['spacing'] ?? 16).toDouble();
    // final cardStyle = widget.style['cardStyle'] ?? {};
    // final double borderRadius = 6.0;
    // // final double borderRadius = (cardStyle['borderRadius'] ?? 20).toDouble();
    // final double elevation = (cardStyle['elevation'] ?? 8).toDouble();
    // final overlayGradient = cardStyle['overlayGradient'] ?? {};
    // final titleStyle = cardStyle['titleStyle'] ?? {};
    // final subtitleStyle = cardStyle['subtitleStyle'] ?? {};
    final height = double.parse("${widget.style['height']}" )?? 200.0;

    return widget.banners.isEmpty?const SizedBox(): Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          options:CarouselOptions(
            autoPlay: widget.banners.length>1?true:false,
            height: height,
            // aspectRatio: aspectRatio,
            enableInfiniteScroll: true,
            viewportFraction: 1, // Show parts of adjacent items//0.75
            // enlargeCenterPage: true,
            // enlargeFactor: 0.9,
            // enlargeStrategy: CenterPageEnlargeStrategy.height,
            padEnds: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 200),
            pauseAutoPlayOnTouch: true,
          ),
          itemBuilder: (context, index, _) {
            final banner = widget.banners[index];
            final image = banner['image'];
            // final title = banner['title'];
            // final subtitle = banner['subtitle']
            //     ?.toString()
            //     .replaceAll(RegExp(r'[^0-9.]'), '');
            // // final subtitle = banner['subtitle'];
            // final badge = banner['badge'];
            // final deepLink = banner['deeplink'];
            // final id = banner['id'];
            // // final formattedSubtitle = num.tryParse(subtitle.toString())?.toINR() ?? subtitle.toString();
            //
            // final value = num.tryParse(subtitle.toString());
            // final formattedSubtitle = value != null
            //     ? value.toINR() // your extension
            //     : subtitle.toString();


            return GestureDetector(
              onTap: () {
                //            "type": "sale",
                // final productId = Uri.parse(deepLink ?? '').pathSegments.last;
                // var productJson = {'_id': productId};
                // Get.toNamed('/product-details', arguments: productJson);
              },
              child: Container(
                // color: Colors.yellow,
                // margin: const EdgeInsets.symmetric(horizontal: 4,vertical: 20), // ⬅️ Margin between items

                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(borderRadius),
                  // aspectRatio:3 / 2, // Set your desired aspect ratio here

                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.contain,

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
            );
          },


        ),
      ],
    );
  }


}



