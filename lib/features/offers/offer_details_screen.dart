import 'package:flutter/material.dart';
import '../../widgets/offer_widgets/voucher_claim_dialog.dart';
import '../../widgets/back_button.dart';
import '../../models/offer.dart';
import 'partner_screen.dart';

class OfferDetailsScreen extends StatelessWidget {
  final Offer offer;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          offer.image,
                          width: double.infinity,
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 60,
                          left: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const AppBackButton(),
                          ),
                        ),
                      ],
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage:
                                      NetworkImage(offer.partner.logo),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    offer.partner.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PartnerScreen(offer: offer),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),

                            if (offer.points != null) ...[
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${offer.points} Points",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 20),

                            Text(
                              offer.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Text(
                              offer.description,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.55,
                                color: Color(0xff757575),
                              ),
                            ),

                            const Spacer(),

                            if (offer.terms != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  offer.terms!,
                                  style: const TextStyle(
                                    height: 1.4,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () {
                                  if (offer.points != null) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => VoucherClaimDialog(
                                        title: offer.title,
                                        points: offer.points!,
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PartnerScreen(
                                          offer: offer,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  offer.points != null
                                      ? "Get voucher for ${offer.points} points"
                                      : "Learn more",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}