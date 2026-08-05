// coupons_screen.dart
import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import '../../models/coupons.dart';
import '../../widgets/coupons/coupons_card.dart';
import '../../widgets/coupons/segmented_button.dart';

class CouponsScreen extends StatefulWidget {
  const CouponsScreen({super.key, required this.coupons});

  final List<Coupon> coupons;

  @override
  State<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  static const _labels = ['Available', 'Used', 'Expired'];
  static const _statusByIndex = [
    CouponStatus.available,
    CouponStatus.used,
    CouponStatus.expired,
  ];

  int _activeIndex = 0;

  List<Coupon> get _filteredCoupons => widget.coupons
      .where((c) => c.status == _statusByIndex[_activeIndex])
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Coupons'),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SegmentedPromoControl(
                labels: _labels,
                activeIndex: _activeIndex,
                onSegmentSelected: (i) => setState(() => _activeIndex = i),
              ),
            ),
            Expanded(
              child: _filteredCoupons.isEmpty
                  ? Center(
                      child: Text(
                        'No ${_labels[_activeIndex].toLowerCase()} coupons',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredCoupons.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, i) =>
                          CouponCard(coupon: _filteredCoupons[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
