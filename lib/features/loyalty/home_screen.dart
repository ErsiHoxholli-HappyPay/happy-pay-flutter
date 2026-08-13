import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/loyalty/booklets/booklets.dart';
import 'package:happy_pay_flutter/features/loyalty/booklets/booklets_screen.dart';
import 'package:happy_pay_flutter/features/loyalty/level_rewards_info.dart';
import 'package:happy_pay_flutter/features/loyalty/barcode_screen.dart';
import 'package:happy_pay_flutter/features/loyalty/points_history.dart';
import 'package:happy_pay_flutter/features/loyalty/referal.dart';
import 'package:happy_pay_flutter/features/loyalty/steps/steps_permission.dart';
import 'package:happy_pay_flutter/widgets/lucky_spin/lucky_spin.dart';
import 'package:happy_pay_flutter/features/loyalty/partners/partners_screen.dart';
import '../../data/offer.dart';
import '../../data/coupons.dart';
import '../../data/session.dart';
import 'offers/offers_screen.dart';
import 'offers/offer_details_screen.dart';
import '../../widgets/offer_widgets/offer_card.dart';
import 'coupons/coupons_screen.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool happyOffers = false;
  @override
  Widget build(BuildContext context) {
    final user = AppSession.currentUser;
    final points = user?.happyPoints ?? 0;
    final filteredOffers = offers
        .where(
          (offer) => happyOffers ? offer.points != null : offer.points == null,
        )
        .toList();
    final currentPoints = points;
    int pointsRemainingForNextLevel(int currentPoints) {
      if (currentPoints < 5000) {
        return 5000 - currentPoints;
      } else if (currentPoints < 10000) {
        return 10000 - currentPoints;
      } else if (currentPoints < 20000) {
        return 20000 - currentPoints;
      } else {
        return 0;
      }
    }

    double levelProgress(int p) => (p / 10000).clamp(0.0, 1.0);

    String currentLevelLabel(int p) {
      if (p < 5000) return 'Level 0';
      if (p < 10000) return 'Level 1';
      return 'Level 2';
    }

    String nextLevelLabel(int p) {
      if (p < 5000) return 'Level 1';
      if (p < 10000) return 'Level 2';
      return 'Level 3';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: [
                        const Expanded(
                          child: AppHeader(title: "Loyalty", currentIndex: 0),
                        ),

                        const SizedBox(width: 12),

                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    // POINTS
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "haPPy points",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentPoints.toString().replaceAllMapped(
                                  RegExp(r'(\d)(?=(\d{3})+$)'),
                                  (m) => '${m[1]},',
                                ),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.visibility_outlined, size: 18),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "🔥 Earn ${pointsRemainingForNextLevel(currentPoints)} more points for Level 1 rewards",
                                style: TextStyle(fontSize: 12),
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => const Info(),
                                  );
                                },
                                icon: const Icon(Icons.info, size: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: _couponsButton(Icons.card_giftcard, "Coupons"),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: _barcodeButton(Icons.qr_code, "Show barcode"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    //Booklets
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Earn more points with our booklets',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          BookletsCard(
                            pointsRemaining: pointsRemainingForNextLevel(
                              currentPoints,
                            ),
                            progress: levelProgress(currentPoints),
                            currentLevelLabel: currentLevelLabel(currentPoints),
                            nextLevelLabel: nextLevelLabel(currentPoints),
                            buttonLabel: 'View booklets',
                            onButtonPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BookletsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // HISTORY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Points history",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PointsHistoryScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "View All >",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _historyItem("Max Optika", "+3 points"),

                    _historyItem("Spar", "+15 points"),

                    _historyItem("Neptun", "+22 points"),

                    const SizedBox(height: 25),
                    // OFFERS HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Offers",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OffersScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Show all →",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    // TOGGLE
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _offerToggle(
                              "Partner's offers",
                              !happyOffers,
                            ),
                          ),

                          Expanded(
                            child: _offerToggle("haPPy offers", happyOffers),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    // HORIZONTAL OFFERS
                    SizedBox(
                      height: 155,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 2, bottom: 3),
                        itemCount: filteredOffers.length,
                        itemBuilder: (context, index) {
                          final offer = filteredOffers[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              bottom: 3,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        OfferDetailsScreen(offer: offer),
                                  ),
                                );
                              },
                              child: OfferCard(
                                offer: offer,
                                imageHeight: 70,
                                cardWidth: 265,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),
                    // PARTNERS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              6,
                              (index) => Container(
                                margin: const EdgeInsets.all(4),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "haPPy partners",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const Text(
                            "Earn points and enjoy unique\nbenefits from our strategic partners.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),

                          const SizedBox(height: 15),

                          _partnersButton("View all partners"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Earn more points",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _greyCard(
                          "Lucky Spin",
                          onTap: () => LuckySpinSheet.show(context),
                        ),
                        const SizedBox(width: 10),
                        _greyCard("Steps", onTap: () => Steps.show(context)),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Column(
                        children: [
                          const Text(
                            "Invite your friends\nand earn points!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 15),

                          _inviteButton("Invite"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  Widget _couponsButton(IconData icon, String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CouponsScreen(coupons: coupons)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _barcodeButton(IconData icon, String text) {
    return ElevatedButton(
      onPressed: () {
        BarcodeSheet.show(context, barcodeValue: 'AB1234567890');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 34),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _historyItem(String name, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Container(width: 35, height: 35, color: Colors.grey),

          const SizedBox(width: 10),

          Text(name),

          const Spacer(),

          Text(points),
        ],
      ),
    );
  }

  Widget _offerToggle(String text, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          happyOffers = text.contains("haPPy");
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,

          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _partnersButton(String text) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PartnersScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _inviteButton(String text) {
    return ElevatedButton(
      onPressed: () {
        Referral.show(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _greyCard(String text, {VoidCallback? onTap}) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
          color: Colors.grey.shade200,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 60, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(text, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
