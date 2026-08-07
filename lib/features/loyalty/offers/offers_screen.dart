import 'package:flutter/material.dart';
import '../../../widgets/back_button.dart';
import '../../../data/offer.dart';
import '/widgets/offer_widgets/offer_card.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  bool happyOffers = false;

  @override
  Widget build(BuildContext context) {
    final filtered = offers.where((offer) {
      return happyOffers ? offer.points != null : offer.points == null;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9E9E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const AppBackButton(),
                    ),
                  ),
                  const Text(
                    "Offers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // SEGMENTED CONTROL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E9E9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            happyOffers = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: !happyOffers
                                ? Colors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              "Partner's offers",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: !happyOffers
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            happyOffers = true;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: happyOffers
                                ? Colors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Center(
                            child: Text(
                              "haPPy offers",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: happyOffers
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // OFFERS
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                physics: const BouncingScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  return OfferCard(offer: filtered[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
