// lib/widgets/custom_image_loader.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget loadImageBasedOnExtension(String? imageUrl, {double? width, double? height, BoxFit fit = BoxFit.contain}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return const Icon(Icons.broken_image);
  }

  final uri = Uri.tryParse(imageUrl);
  final ext = uri?.path.split('.').last.toLowerCase();

  if (ext == 'svg') {
    return SvgPicture.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (context) => const Center(child: Icon(Icons.broken_image)),
    );
  }

  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit,
    placeholder: (context, url) => const Center(child: Icon(Icons.broken_image)),
    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
  );
}
