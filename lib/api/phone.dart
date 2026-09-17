// lib/api/phone.dart

/// Returns +355 followed by 9 digits, or null if the input is not valid.
String? toApiPhone(String typed) {
  var digits = typed.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  return digits.length == 9 ? '+355$digits' : null;
}
