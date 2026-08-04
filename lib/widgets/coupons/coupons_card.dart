// coupon_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/coupons.dart';
import 'coupon_details_card.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({super.key, required this.coupon});

  final Coupon coupon;

  String get _formattedDate =>
      '${coupon.statusDate.day}/${coupon.statusDate.month}/${coupon.statusDate.year}';

  String get _statusLine {
    switch (coupon.status) {
      case CouponStatus.available:
        return 'Expires on $_formattedDate';
      case CouponStatus.used:
        return 'Used on $_formattedDate';
      case CouponStatus.expired:
        return 'Expired on $_formattedDate';
    }
  }

  bool get _isExpired => coupon.status == CouponStatus.expired;

  Future<void> _copyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: coupon.code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    showCouponDetailDialog(
      context: context,
      brandName: coupon.brandName,
      codeLabel: coupon.codeLabel,
      description: coupon.description,
      discountLabel: coupon.discountLabel,
      expiryDate: coupon.statusDate,
      code: coupon.code,
      logo: coupon.logo,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only an available coupon has a live, redeemable code — used and
    // expired coupons render as a flat, non-interactive summary row.
    if (coupon.status == CouponStatus.available) {
      return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openDetail(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.all(16),
                child: _HeaderRow(
                  coupon: coupon,
                  statusLine: _statusLine,
                  muted: false,
                ),
              ),
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      coupon.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    InkWell(
                      onTap: () => _copyCode(context),
                      child: const Row(
                        children: [
                          Text(
                            'Copy code',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _HeaderRow(
        coupon: coupon,
        statusLine: _statusLine,
        muted: _isExpired,
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.coupon,
    required this.statusLine,
    required this.muted,
  });

  final Coupon coupon;
  final String statusLine;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Logo(brandName: coupon.brandName, image: coupon.logo, muted: muted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coupon.brandName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: muted ? Colors.grey.shade500 : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                coupon.codeLabel,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 4),
              Text(
                statusLine,
                style: TextStyle(
                  fontSize: 12,
                  color: muted ? Colors.grey.shade500 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Text(
          coupon.discountLabel,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: muted ? Colors.grey.shade400 : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.brandName, required this.muted, this.image});

  final String brandName;
  final bool muted;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: muted ? Colors.grey.shade400 : Colors.black,
      backgroundImage: image,
      child: image == null
          ? Text(
              brandName.isNotEmpty ? brandName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
