import 'package:intl/intl.dart';

class Number {
  static final NumberFormat _numberFormat = NumberFormat.decimalPattern("id");

  static final NumberFormat _currencyFormat = NumberFormat.simpleCurrency(
    locale: "id",
    decimalDigits: 0,
  );

  static String formatNumber(int value) {
    return _numberFormat.format(value);
  }

  static String formatCurrency(int value) {
    return _currencyFormat.format(value);
  }
}
