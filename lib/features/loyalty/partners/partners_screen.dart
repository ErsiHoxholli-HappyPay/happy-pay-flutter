import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/widgets/partners_card.dart';
import 'package:happy_pay_flutter/features/loyalty/offers/partner_screen.dart';
import '../../../data/offer.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Partners'),
        centerTitle: true,
        elevation: 1,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        padding: const EdgeInsets.all(16),
        children: offers
            .map(
              (offer) => PartnersCard(
                logoUrl: offer.partner.logo,
                partnerName: offer.partner.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PartnerScreen(offer: offer),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
