import 'package:flutter/material.dart';
import '../../widgets/back_button.dart';
import '../../models/offer.dart';

class PartnerScreen extends StatelessWidget {
  final Offer offer;

  const PartnerScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 10),

            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    offer.partner.logo,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 20,
                  left: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const AppBackButton(),
                  ),
                ),
              ],
            ),

            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      offer.partner.name,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      offer.partner.description,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [

                        _social(
                          Icons.language,
                          () {},
                        ),

                        const SizedBox(width: 10),

                        _social(
                          Icons.email,
                          () {},
                        ),

                        const SizedBox(width: 10),

                        _social(
                          Icons.camera_alt,
                          () {},
                        ),
                        
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Store locations",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Column(
                      children: offer.partner.locations
                          .map(
                            (location) => Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                title: Text(
                                  location.name,
                                ),
                                subtitle: Text(
                                  location.address,
                                ),
                                trailing: const Icon(
                                  Icons.store,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _social(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 54,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon),
      ),
    );
  }
}