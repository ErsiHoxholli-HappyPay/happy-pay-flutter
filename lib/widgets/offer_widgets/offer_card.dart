import 'package:flutter/material.dart';
import '../../models/offer.dart';
import '../../features/offers/offer_details_screen.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final double? imageHeight;
  final double? cardWidth;

  const OfferCard({
    super.key,
    required this.offer,
    this.imageHeight,
    this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OfferDetailsScreen(
                offer: offer,
              ),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 3,
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Stack(
                children: [

                  Image.network(
                    offer.image,
                    height: imageHeight ?? 145,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  if (offer.points != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${offer.points} Points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [

                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        offer.partner.logo,
                      ),
                    ),

                    const SizedBox(width: 8),


                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            offer.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),

                          Text(
                            offer.partner.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
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
      ),
    );
  }
}