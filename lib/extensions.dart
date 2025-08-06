import 'package:intl/intl.dart';

extension DateParsing on String {
  /// Convert ISO date string like '2024-06-25T10:30:00Z' to formatted date
  String get toFormattedDate {
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return this; // fallback if parsing fails
    }
  }
}

