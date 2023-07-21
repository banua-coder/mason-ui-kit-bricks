import 'package:intl/intl.dart';

class PriceUtil {
  static String formatCurrency(
    dynamic value, {
    String name = 'Indonesian Rupiah',
    String symbol = 'Rp',
    int decimalDigits = 0,
  }) =>
      NumberFormat.currency(
        locale: 'id_ID',
        decimalDigits: decimalDigits,
        name: name,
        symbol: symbol,
      ).format(value ?? 0);
}
