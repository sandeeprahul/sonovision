import 'package:intl/intl.dart';


extension IndianCurrencyExtension on num {
  String toINR({bool withSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: withSymbol ? '₹' : '',
      decimalDigits: 0,
    );
    return formatter.format(this);
  }
}

String maskPrice(dynamic price, {int starsCount = 3}) {
  if (price == null) return '';

  final priceStr = price.toString();
  if (priceStr.length <= starsCount) {
    return '*' * priceStr.length;
  }

  final visiblePart = priceStr.substring(0, priceStr.length - starsCount);
  return '$visiblePart${'*' * starsCount}';
}