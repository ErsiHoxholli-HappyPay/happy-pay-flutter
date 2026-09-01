import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../widgets/back_button.dart';
import '../wallet/new_payment/payment_sent_screen.dart';
import '../wallet/new_payment/send_amount_screen.dart' show TransferParties;
import '../wallet/widgets/review_info_row.dart';

class ReviewQrPaymentScreen extends StatelessWidget {
  final String merchantName;
  final double amount;
  final String reference;
  final String category;

  const ReviewQrPaymentScreen({
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
    final amountStr = amount.toStringAsFixed(0);
    final remaining =
        (AppSession.walletBalance - amount)
            .toStringAsFixed(0);

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
                        "Review payment",
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

            TransferParties(
              senderName: myName,
              recipientName: merchantName,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    ReviewInfoRow(
                      label: "Wallet balance",
                      value:
                          "L${AppSession.walletBalance.toStringAsFixed(0)}",
                    ),
                    ReviewInfoRow(
                      label: "Product price",
                      value: "L$amountStr",
                    ),
                    ReviewInfoRow(
                      label: "Fees",
                      value: "No fees",
                      valueColor: Colors.grey,
                    ),
                    ReviewInfoRow(
                      label: "Total to pay",
                      value: "L$amountStr",
                      bold: true,
                    ),
                    const SizedBox(height: 12),
                    ReviewInfoRow(
                      label: "Reference",
                      value: reference,
                    ),
                    ReviewInfoRow(
                      label: "Category",
                      value: category,
                      leadingIcon: Icons.shopping_bag_outlined,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius:
                            BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Remaining balance",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            "L$remaining",
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                14,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentSentScreen(
                        amount: amountStr,
                        contactName: merchantName,
                        successTitle: "Successfully paid!",
                        successMessage:
                            "You paid L$amountStr to $merchantName.",
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
                    "Pay now",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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

