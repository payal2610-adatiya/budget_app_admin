import 'package:intl/intl.dart';

class Formatters {
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }

  static String formatDateForApi(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatNumber(double number) {
    return NumberFormat('#,##0.00').format(number);
  }

  static String formatCompactNumber(double number) {
    if (number >= 1000000) {
      return '₹${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '₹${(number / 1000).toStringAsFixed(1)}K';
    }
    return '₹${number.toStringAsFixed(0)}';
  }
}