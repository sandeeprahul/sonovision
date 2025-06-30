import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';

class ProductReview {
  final String id;
  final String? userId;
  final String productId;
  final String orderId;
  final int rating;
  final String review;
  final List<String> files;
  final DateTime createdAt;

  ProductReview({
    required this.id,
    this.userId,
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.review,
    required this.files,
    required this.createdAt,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['_id'],
      userId: json['user_id']??'',
      productId: json['product_id'],
      orderId: json['order_id'],
      rating: json['rating'],
      review: json['review'],
      files: List<String>.from(json['files'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

