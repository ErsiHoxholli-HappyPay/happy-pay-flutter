import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/partners/partners_screen.dart';
import '../../data/offer.dart';
import '../offers/offers_screen.dart';
import '../offers/offer_details_screen.dart';
import '../../widgets/offer_widgets/offer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool happyOffers = true;
  @override
  Widget build(BuildContext context) {
    final filteredOffers = offers
        .where(
          (offer) => happyOffers ? offer.points != null : offer.points == null,
        )
        .toList();
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Loyalty",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
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
                              const Text(
                                "3,765",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.visibility_outlined, size: 18),
                            ],
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "🔥 Earn 1,235 more points for Level 1 rewards",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    // BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: _smallButton(Icons.card_giftcard, "Coupons"),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: _smallButton(Icons.qr_code, "Show barcode"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                    // HISTORY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Points history",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text("View all ›", style: TextStyle(fontSize: 12)),
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

                          _blackButton("View all partners"),
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
                        _greyCard("Lucky Spin"),
                        const SizedBox(width: 10),
                        _greyCard("Step Counter"),
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

                          _blackButton("Invite"),
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Loyalty",
          ),

          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),

          BottomNavigationBarItem(icon: Icon(Icons.payments), label: "Loans"),

          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: "QR pay"),
        ],
      ),
    );
  }

  Widget _smallButton(IconData icon, String text) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
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

  Widget _blackButton(String text) {
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

  Widget _greyCard(String text) {
    return Expanded(
      child: Container(
        height: 120,
        color: Colors.grey.shade200,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              height: 60,
              color: Colors.grey,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
