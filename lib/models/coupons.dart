// coupon.dart
import 'package:flutter/material.dart';

enum CouponStatus { available, used, expired }

/// Single source of truth for a coupon. `statusDate` means different
/// things depending on `status` (expiry date, used date, expired date) —
/// deliberately one field, not three, since a coupon only ever has one
/// of those dates meaningfully set at a time.
class Coupon {
  const Coupon({
    required this.brandName,
    required this.codeLabel,
    required this.description,
    required this.discountLabel,
    required this.code,
    required this.statusDate,
    required this.status,
    this.logo,
  });

  final String brandName;
  final String codeLabel;
  final String description;
  final String discountLabel;
  final String code;
  final DateTime statusDate;
  final CouponStatus status;
  final ImageProvider? logo;
}
