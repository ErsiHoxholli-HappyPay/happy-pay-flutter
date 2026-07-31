import 'package:flutter/material.dart';
import '../../widgets/back_button.dart';
import '../../models/offer.dart';

class OfferDetailsScreen extends StatelessWidget {

  final Offer offer;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(

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

                const Positioned(
                  top: 50,
                  left: 20,
                  child: AppBackButton(),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(offer.logo),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        offer.subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  if (offer.points != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${offer.points} Points',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    offer.description,
                    style: const TextStyle(
                      height: 1.5,
                    ),
                  ),

                  if (offer.terms != null) ...[

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Text(offer.terms!),
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        offer.points != null
                            ? 'Get voucher for ${offer.points} points'
                            : 'View Offer',
                      ),
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