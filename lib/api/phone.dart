// lib/api/phone.dart

/// Returns an E.164 number (`+<dialCode><national>`), or null if invalid.
/// If the user typed a leading `+`, the typed number is used as-is.
String? toApiPhone(String typed, String dialCode) {
  final trimmed = typed.trim();
  final code = dialCode.replaceAll(RegExp(r'[^0-9]'), '');
  var digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');

  if (trimmed.startsWith('+')) {
    return digits.length >= 8 && digits.length <= 15 ? '+$digits' : null;
  }

  while (digits.startsWith('0')) {
    digits = digits.substring(1);
  }
  if (digits.length < 6 || digits.length + code.length > 15) return null;
  return '+$code$digits';
}
