// coupon_detail_dialog.dart
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Opens the coupon detail modal as a centered dialog over a dimmed
/// background, matching the "Details" screen in the design.
Future<void> showCouponDetailDialog({
  required BuildContext context,
  required String brandName,
  required String codeLabel,
  required String description,
  required String discountLabel,
  required DateTime expiryDate,
  required String code,
  ImageProvider? logo,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: _CouponDetailContent(
        brandName: brandName,
        codeLabel: codeLabel,
        description: description,
        discountLabel: discountLabel,
        expiryDate: expiryDate,
        code: code,
        logo: logo,
      ),
    ),
  );
}

class _CouponDetailContent extends StatelessWidget {
  const _CouponDetailContent({
    required this.brandName,
    required this.codeLabel,
    required this.description,
    required this.discountLabel,
    required this.expiryDate,
    required this.code,
    this.logo,
  });

  final String brandName;
  final String codeLabel;
  final String description;
  final String discountLabel;
  final DateTime expiryDate;
  final String code;
  final ImageProvider? logo;

  String get _formattedExpiry =>
      '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';

  Future<void> _copyCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _Logo(brandName: brandName, image: logo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          brandName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          codeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
              child: Column(
                children: [
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  const _DashedDivider(),
                  const SizedBox(height: 20),
                  Text(
                    discountLabel,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Expires on $_formattedExpiry',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 20),
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: code.replaceAll(' ', ''),
                    height: 70,
                    drawText: false,
                    errorBuilder: (context, error) => Text(
                      'Invalid code for barcode: $error',
                      style: const TextStyle(color: Colors.red, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    code,
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
}

class _Logo extends StatelessWidget {
  const _Logo({required this.brandName, this.image});

  final String brandName;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.black,
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

/// Small dashed rule, matching the separator in the design. Built with
/// a LayoutBuilder instead of a package since it's a single fixed line.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  static const _dashWidth = 6.0;
  static const _dashGap = 4.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / (_dashWidth + _dashGap))
            .floor();
        return Row(
          children: List.generate(
            dashCount,
            (_) => Padding(
              padding: const EdgeInsets.only(right: _dashGap),
              child: Container(
                width: _dashWidth,
                height: 1,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        );
      },
    );
  }
}
