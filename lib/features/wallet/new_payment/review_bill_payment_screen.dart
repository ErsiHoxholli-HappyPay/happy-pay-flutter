import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../widgets/back_button.dart';
import '../../wallet/widgets/review_info_row.dart';
import 'bills_services_screen.dart';
import 'payment_sent_screen.dart';
import 'send_amount_screen.dart' show TransferParties;

class ReviewBillPaymentScreen extends StatelessWidget {
  final BillService service;
  final String contractNumber;

  const ReviewBillPaymentScreen({
    super.key,
    required this.service,
    required this.contractNumber,
  });

  @override
  Widget build(BuildContext context) {
    final myName = AppSession.currentUser?.name ?? 'My Name';
    final amount = service.amount.toStringAsFixed(0);

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
              recipientName: service.companyName,
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
                    const SizedBox(height: 12),
                    ReviewInfoRow(
                      label: "Contract number",
                      value: contractNumber,
                    ),
                    ReviewInfoRow(
                      label: "Arriving",
                      value: "Instantly",
                      valueColor: Colors.green.shade600,
                    ),
                    ReviewInfoRow(
                      label: "Note",
                      value:
                          "${service.name} payment in "
                          "February 2024",
                      valueColor: Colors.grey,
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
                            "L${(AppSession.walletBalance - service.amount).toStringAsFixed(0)}",
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
                        amount: amount,
                        contactName: service.companyName,
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
