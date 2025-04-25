import 'package:intl/intl.dart';

String priceFormatter(int value) {
  // Create a NumberFormat instance
  var formatter = NumberFormat('#,##0');

// Format the number
  String formattedNumber = formatter.format(value);
  return formattedNumber;
}
