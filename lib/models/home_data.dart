import 'dart:convert';

class HomeData {
  final String version;
  final DateTime saleEndTime;
  final ThemeData theme;
  final List<Widget> widgets;
  final Animations animations;
  final Accessibility accessibility;

  HomeData({
    required this.version,
    required this.saleEndTime,
    required this.theme,
    required this.widgets,
    required this.animations,
    required this.accessibility,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      version: json['version'],
      saleEndTime: DateTime.parse(json['saleEndTime']),
      theme: ThemeData.fromJson(json['theme']),
      widgets: (json['widgets'] as List).map((w) => Widget.fromJson(w)).toList(),
      animations: Animations.fromJson(json['animations']),
      accessibility: Accessibility.fromJson(json['accessibility']),
    );
  }
}

class ThemeData {
  final Colors colors;
  final Typography typography;
  final AnimationConfig animations;

  ThemeData({
    required this.colors,
    required this.typography,
    required this.animations,
  });

  factory ThemeData.fromJson(Map<String, dynamic> json) {
    return ThemeData(
      colors: Colors.fromJson(json['colors']),
      typography: Typography.fromJson(json['typography']),
      animations: AnimationConfig.fromJson(json['animations']),
    );
  }
}

class Colors {
  final String primary;
  final String secondary;
  final String accent;
  final String background;
  final TextColors text;

  Colors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.text,
  });

  factory Colors.fromJson(Map<String, dynamic> json) {
    return Colors(
      primary: json['primary'],
      secondary: json['secondary'],
      accent: json['accent'],
      background: json['background'],
      text: TextColors.fromJson(json['text']),
    );
  }
}

class TextColors {
  final String primary;
  final String secondary;
  final String light;

  TextColors({
    required this.primary,
    required this.secondary,
    required this.light,
  });

  factory TextColors.fromJson(Map<String, dynamic> json) {
    return TextColors(
      primary: json['primary'],
      secondary: json['secondary'],
      light: json['light'],
    );
  }
}

class Typography {
  final String heading;
  final String body;
  final String price;

  Typography({
    required this.heading,
    required this.body,
    required this.price,
  });

  factory Typography.fromJson(Map<String, dynamic> json) {
    return Typography(
      heading: json['heading'],
      body: json['body'],
      price: json['price'],
    );
  }
}

class AnimationConfig {
  final double duration;
  final String curve;

  AnimationConfig({
    required this.duration,
    required this.curve,
  });

  factory AnimationConfig.fromJson(Map<String, dynamic> json) {
    return AnimationConfig(
      duration: json['duration'].toDouble(),
      curve: json['curve'],
    );
  }
}

class Widget {
  final String widgetType;
  final Style style;
  final dynamic data;
  final String? type;
  final String? label;

  Widget({
    required this.widgetType,
    required this.style,
    required this.data,
    this.type,
    this.label,
  });

  factory Widget.fromJson(Map<String, dynamic> json) {
    return Widget(
      widgetType: json['widgetType'],
      style: Style.fromJson(json['style']),
      data: json['data'],
      type: json['type'],
      label: json['label'],
    );
  }
}

class Style {
  final double? height;
  final double? margin;
  final double? spacing;
  final String? viewType;
  final CardStyle? cardStyle;
  final int? columns;
  final double? aspectRatio;
  final double? padding;
  final String? timerColor;

  Style({
    this.height,
    this.margin,
    this.spacing,
    this.viewType,
    this.cardStyle,
    this.columns,
    this.aspectRatio,
    this.padding,
    this.timerColor,
  });

  factory Style.fromJson(Map<String, dynamic> json) {
    return Style(
      height: json['height']?.toDouble(),
      margin: json['margin']?.toDouble(),
      spacing: json['spacing']?.toDouble(),
      viewType: json['viewType'],
      cardStyle: json['cardStyle'] != null ? CardStyle.fromJson(json['cardStyle']) : null,
      columns: json['columns'],
      aspectRatio: json['aspectRatio']?.toDouble(),
      padding: json['padding']?.toDouble(),
      timerColor: json['timerColor'],
    );
  }
}

class CardStyle {
  final double borderRadius;
  final double elevation;
  final double padding;
  final Animation? animation;
  final TextStyle? titleStyle;
  final TextStyle? priceStyle;
  final Badge? badge;
  final Gradient? gradient;

  CardStyle({
    required this.borderRadius,
    required this.elevation,
    required this.padding,
    this.animation,
    this.titleStyle,
    this.priceStyle,
    this.badge,
    this.gradient,
  });

  factory CardStyle.fromJson(Map<String, dynamic> json) {
    return CardStyle(
      borderRadius: json['borderRadius'].toDouble(),
      elevation: json['elevation'].toDouble(),
      padding: json['padding'].toDouble(),
      animation: json['animation'] != null ? Animation.fromJson(json['animation']) : null,
      titleStyle: json['titleStyle'] != null ? TextStyle.fromJson(json['titleStyle']) : null,
      priceStyle: json['priceStyle'] != null ? TextStyle.fromJson(json['priceStyle']) : null,
      badge: json['badge'] != null ? Badge.fromJson(json['badge']) : null,
      gradient: json['gradient'] != null ? Gradient.fromJson(json['gradient']) : null,
    );
  }
}

class Animation {
  final double scale;
  final double duration;

  Animation({
    required this.scale,
    required this.duration,
  });

  factory Animation.fromJson(Map<String, dynamic> json) {
    return Animation(
      scale: json['scale'].toDouble(),
      duration: json['duration'].toDouble(),
    );
  }
}

class TextStyle {
  final double fontSize;
  final String fontWeight;
  final String color;

  TextStyle({
    required this.fontSize,
    required this.fontWeight,
    required this.color,
  });

  factory TextStyle.fromJson(Map<String, dynamic> json) {
    return TextStyle(
      fontSize: json['fontSize'].toDouble(),
      fontWeight: json['fontWeight'],
      color: json['color'],
    );
  }
}

class Badge {
  final String text;
  final String color;
  final String position;

  Badge({
    required this.text,
    required this.color,
    required this.position,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      text: json['text'],
      color: json['color'],
      position: json['position'],
    );
  }
}

class Gradient {
  final String start;
  final String end;

  Gradient({
    required this.start,
    required this.end,
  });

  factory Gradient.fromJson(Map<String, dynamic> json) {
    return Gradient(
      start: json['start'],
      end: json['end'],
    );
  }
}

class Animations {
  final String scroll;
  final bool lazyLoading;
  final bool pullToRefresh;

  Animations({
    required this.scroll,
    required this.lazyLoading,
    required this.pullToRefresh,
  });

  factory Animations.fromJson(Map<String, dynamic> json) {
    return Animations(
      scroll: json['scroll'],
      lazyLoading: json['lazyLoading'],
      pullToRefresh: json['pullToRefresh'],
    );
  }
}

class Accessibility {
  final String contrast;
  final bool darkMode;
  final FontSize fontSize;

  Accessibility({
    required this.contrast,
    required this.darkMode,
    required this.fontSize,
  });

  factory Accessibility.fromJson(Map<String, dynamic> json) {
    return Accessibility(
      contrast: json['contrast'],
      darkMode: json['darkMode'],
      fontSize: FontSize.fromJson(json['fontSize']),
    );
  }
}

class FontSize {
  final int min;
  final int max;

  FontSize({
    required this.min,
    required this.max,
  });

  factory FontSize.fromJson(Map<String, dynamic> json) {
    return FontSize(
      min: json['min'],
      max: json['max'],
    );
  }
}
