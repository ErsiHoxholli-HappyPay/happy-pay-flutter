// ignore_for_file: prefer_initializing_formals, unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/coupons.dart' as coupon_data;
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/features/booklets/buying_booklets.dart';
import 'package:happy_pay_flutter/features/coupons/coupons_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

// ---------------------------------------------------------------------------
// Data model — single source of truth for a booklet card and its modal.
// ---------------------------------------------------------------------------
class BookletData {
  final String title;
  final int points;
  final String description;
  final String giftText;
  final List<String> offerRows;

  const BookletData({
    required this.title,
    required this.points,
    required this.description,
    required this.giftText,
    required this.offerRows,
  });
}

const _booklets = [
  BookletData(
    title: 'Level 2 Booklet',
    points: 10000,
    description: 'Personalized offers and benefits created for your needs.',
    giftText:
        'Collect 10,000 points and receive a GIFT of 8 haPPy coupons with a total value of 8,000 ALL, 10% discount in Neptun & 15% in Mr Optica.',
    offerRows: [
      'R200 ALL at Spar',
      'R200 ALL at Jumbo',
      'R200 ALL at Neptune',
      '10% discount (Except IT and mobile products)',
      'R200 ALL at Mirage',
      'R200 ALL at FSA Milengo, Gece, Farina, Prenatal, Oksel, Carpisa',
      'R200 ALL at Max Optica',
      'R200 ALL at Cornfield & Springfield',
    ],
  ),
  BookletData(
    title: 'Level 1 Booklet',
    points: 5000,
    description: 'Personalized offers and benefits created for your needs.',
    giftText:
        'Collect 5,000 points and receive a GIFT of 10 haPPy coupons with a total value of 4,000 ALL, 5% discount in Neptun & 10% in Mr Optica.',
    offerRows: [
      'R00 ALL at Spar',
      'R00 ALL at Jumbo',
      'R00 ALL at Neptune',
      '5% discount (Except IT and mobile products)',
      'R00 ALL at Mirage',
      'R00 ALL at FSA Milengo, Gece, Farina, Prenatal, Oksel, Carpisa, Cornfield, Springfield',
      'R00 ALL at Max Optica',
    ],
  ),
];

class BookletsScreen extends StatelessWidget {
  const BookletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          title: const Text('Booklets', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 16.0),
          color: Colors.grey[200],
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              for (var i = 0; i < _booklets.length; i++) ...[
                if (i != 0) const SizedBox(height: 32),
                _BookletCard(data: _booklets[i]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Card — tap opens the detail modal for this booklet's data.
// ---------------------------------------------------------------------------
class _BookletCard extends StatelessWidget {
  final BookletData data;

  const _BookletCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _BookletDetailSheet.show(context, data),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TitleRow(title: data.title, points: data.points),
              const SizedBox(height: 16),
              Text(
                data.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                data.giftText,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              _LogoCarousel(count: data.offerRows.length),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;
  final int points;

  const _TitleRow({required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$points points',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _LogoCarousel extends StatelessWidget {
  final int count;

  const _LogoCarousel({required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail modal
// ---------------------------------------------------------------------------
class _BookletDetailSheet extends StatelessWidget {
  final BookletData data;
  final NavigatorState _parentNav;

  const _BookletDetailSheet({
    required this.data,
    required NavigatorState parentNav,
  }) : _parentNav = parentNav;

  static Future<void> show(BuildContext context, BookletData data) {
    final nav = Navigator.of(context);
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookletDetailSheet(data: data, parentNav: nav),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          SafeArea(
            top: false,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      child: Image.asset(
                        'lib/assets/happy-mascot1.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${data.points} Points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Scrollable offer list
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.giftText,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 20),
                        for (final row in data.offerRows) ...[
                          _OfferRow(label: row),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                ),
                // Fixed bottom: hint + buy button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Builder(
                    builder: (context) {
                      final userPoints =
                          AppSession.currentUser?.happyPoints ?? 0;
                      final canAfford = userPoints >= data.points;
                      return Column(
                        children: [
                          Text(
                            canAfford
                                ? 'Buy this booklet with your points'
                                : 'Keep collecting points to get this booklet',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: canAfford
                                ? () => _showBuyingDialog(context)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              disabledBackgroundColor: Colors.grey[400],
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: const Text(
                              'Buy Booklet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Foreground close button floating over the sheet
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.close, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBuyingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => BuyingBookletDialog(
        data: data,
        onGoHome: () {
          Navigator.of(dialogCtx).pop();
          _parentNav.pop();
        },
        onSeeCoupons: () {
          Navigator.of(dialogCtx).pop();
          _parentNav.pop();
          _parentNav.push(
            MaterialPageRoute(
              builder: (_) => CouponsScreen(coupons: coupon_data.coupons),
            ),
          );
        },
      ),
    );
  }
}

class _OfferRow extends StatelessWidget {
  final String label;
  const _OfferRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
