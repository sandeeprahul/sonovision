import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final List<String> banners = [
    'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-7inch_GEO_EMEA?wid=5120&hei=2880&fmt=p-jpg&qlt=80&.v=1693009283816',
    'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp14-m3-max-space-select-202310?wid=452&hei=420&fmt=jpeg&qlt=95&.v=1697311053229',
    'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/MQD83?wid=572&hei=572&fmt=jpeg&qlt=95&.v=1660803972361',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        viewportFraction: 1.0,
        // Changed from 0.92 to 1.0
        enlargeCenterPage: false,
        // Changed from true to false
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
      items: banners.map((banner) {
        return Container(
          width: MediaQuery.of(context).size.width,
          // Added explicit width
          margin: const EdgeInsets.symmetric(horizontal: 0),
          // Removed horizontal margin
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(banner), // Use banner directly as image URL
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
