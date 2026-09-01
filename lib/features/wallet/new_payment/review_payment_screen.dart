import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../widgets/back_button.dart';
import '../../wallet/widgets/review_info_row.dart';
import 'payment_sent_screen.dart';
import 'send_amount_screen.dart' show TransferParties;

class ReviewPaymentScreen extends StatelessWidget {
  final String amount;
  final String contactName;
  final String note;

  const ReviewPaymentScreen({
    super.key,
    required this.amount,
    required this.contactName,
    required this.note,
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

            // -----------------------------------------------
            // HEADER
            // -----------------------------------------------

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

            // -----------------------------------------------
            // SENDER → RECEIVER
            // -----------------------------------------------

            TransferParties(
              senderName: myName,
              recipientName: contactName,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------
            // REVIEW ROWS
            // -----------------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    ReviewInfoRow(
                      label: "Wallet balance",
                      value: "L${AppSession.walletBalance.toStringAsFixed(0)}",
                    ),
                    ReviewInfoRow(
                      label: "Transfer amount",
                      value: "-L$amount",
                    ),
                    ReviewInfoRow(
                      label: "Fees",
                      value: "No fees",
                      valueColor: Colors.grey,
                    ),
                    ReviewInfoRow(
                      label: "Total to pay",
                      value: "L$amount",
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    ReviewInfoRow(
                      label: "Booking",
                      value: "Instantly",
                      valueColor: Colors.green.shade600,
                    ),
                    ReviewInfoRow(
                      label: "Note",
                      value:
                          note.isEmpty ? "No note" : note,
                      valueColor:
                          note.isEmpty ? Colors.grey : null,
                    ),
                    const SizedBox(height: 20),

                    // Remaining balance preview
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
                            "L${(AppSession.walletBalance - (double.tryParse(amount.replaceAll(',', '.')) ?? 0)).toStringAsFixed(0)}",
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

            // -----------------------------------------------
            // SEND NOW
            // -----------------------------------------------

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
                        amount: amount,
                        contactName: contactName,
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
                    "Send now",
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
