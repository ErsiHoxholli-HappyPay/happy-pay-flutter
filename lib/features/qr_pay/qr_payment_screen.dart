import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../widgets/back_button.dart';
import '../wallet/new_payment/send_amount_screen.dart' show PartyAvatar;
import 'review_qr_payment_screen.dart';

class QrPaymentScreen extends StatelessWidget {
  final String merchantName;
  final double amount;
  final String reference;
  final String category;

  const QrPaymentScreen({
    super.key,
    required this.merchantName,
    required this.amount,
    required this.reference,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final myName =
        AppSession.currentUser?.name ?? 'My Name';

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                8,
                16,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Pay",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PartyAvatar(name: myName),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ),
                PartyAvatar(
                  name: merchantName,
                  verified: true,
                ),
              ],
            ),

            const SizedBox(height: 28),

            const Text(
              "Total to pay",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "L${amount.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 24),

            // Reference + balance rows
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reference",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        reference,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Wallet balance",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        "L${AppSession.walletBalance.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                8,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ReviewQrPaymentScreen(
                        merchantName: merchantName,
                        amount: amount,
                        reference: reference,
                        category: category,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                14,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    "Pay in installments",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

