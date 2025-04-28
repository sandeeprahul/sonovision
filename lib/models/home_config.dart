import 'package:flutter/material.dart';
import 'dart:convert';

class HomeConfig {
  final String version;
  final String saleEndTime;
  final List<WidgetConfig> widgets;
  final ThemeConfig theme; // ✅ Add this line

  HomeConfig({
    required this.version,
    required this.saleEndTime,
    required this.widgets,
    required this.theme, // ✅ Add this line

  });

  factory HomeConfig.fromJson(Map<String, dynamic> json) {
    return HomeConfig(
      version: json['version'] as String,
      saleEndTime: json['saleEndTime'] as String,
      widgets: (json['widgets'] as List)
          .map((widget) => WidgetConfig.fromJson(widget as Map<String, dynamic>))
          .toList(),
      theme: ThemeConfig.fromJson(json['theme']), // ✅ Add this line

    );
  }
}

class ThemeConfig {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final TextColors text;

  ThemeConfig({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.text,
  });

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    return ThemeConfig(
      primary: Color(int.parse(json['colors']['primary'].substring(1), radix: 16) + 0xFF000000),
      secondary: Color(int.parse(json['colors']['secondary'].substring(1), radix: 16) + 0xFF000000),
      accent: Color(int.parse(json['colors']['accent'].substring(1), radix: 16) + 0xFF000000),
      background: Color(int.parse(json['colors']['background'].substring(1), radix: 16) + 0xFF000000),
      text: TextColors.fromJson(json['colors']['text'] as Map<String, dynamic>),
    );
  }
}

class TextColors {
  final Color primary;
  final Color secondary;
  final Color light;

  TextColors({
    required this.primary,
    required this.secondary,
    required this.light,
  });

  factory TextColors.fromJson(Map<String, dynamic> json) {
    return TextColors(
      primary: Color(int.parse(json['primary'].substring(1), radix: 16) + 0xFF000000),
      secondary: Color(int.parse(json['secondary'].substring(1), radix: 16) + 0xFF000000),
      light: Color(int.parse(json['light'].substring(1), radix: 16) + 0xFF000000),
    );
  }
}

class WidgetConfig {
  final String widgetType;
  final String? type;
  final String? label;
  final Map<String, dynamic> style;
  final dynamic data; // Can be either Map<String, dynamic> or List<dynamic>

  WidgetConfig({
    required this.widgetType,
    this.type,
    this.label,
    required this.style,
    this.data,
  });

  factory WidgetConfig.fromJson(Map<String, dynamic> json) {
    return WidgetConfig(
      widgetType: json['widgetType'] as String,
      type: json['type'] as String?,
      label: json['label'] as String?,
      style: Map<String, dynamic>.from(json['style'] ?? {}),
      data: json['data'], // Keep it dynamic, don't cast immediately
    );
  }
}
