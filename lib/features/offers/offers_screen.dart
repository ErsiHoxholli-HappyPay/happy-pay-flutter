import 'package:flutter/material.dart';
//import '../../widgets/back_button.dart';
import '../../data/offer.dart';
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
      return happyOffers
          ? offer.points != null
          : offer.points == null;
    }).toList();

    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [

            // Header

            // Segmented button

            ToggleButtons(
              isSelected: [
                !happyOffers,
                happyOffers,
              ],
              onPressed: (index) {
                setState(() {
                  happyOffers = index == 1;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Partner Offers"),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text("Happy Offers"),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: filtered.length,
                itemBuilder: (_, index) =>
                    OfferCard(
                      offer: filtered[index],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}