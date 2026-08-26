// lib/utils/currency_format.dart

String formatLempira(double amount) {
  final digits = amount.toInt().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'L$buffer';
}
