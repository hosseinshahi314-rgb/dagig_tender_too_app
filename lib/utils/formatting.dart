import 'package:intl/intl.dart';

String formatNumber(double number) {
  if (number == 0) return '0';
  final intNumber = number.toInt();
  final formatter = NumberFormat('#,###', 'en_US');
  String result = formatter.format(intNumber);
  // تبدیل کاما به جداکننده فارسی (٬)
  return result.replaceAll(',', '٬');
}