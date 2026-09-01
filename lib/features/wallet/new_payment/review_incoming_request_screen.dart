import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../models/pending_request.dart';
import '../../wallet/widgets/review_info_row.dart';
import '../../../widgets/back_button.dart';
import 'payment_sent_screen.dart';
import 'send_amount_screen.dart' show TransferParties;

class ReviewIncomingRequestScreen extends StatelessWidget {
  final PendingRequest request;

  const ReviewIncomingRequestScreen({
    super.key,
    required this.request,
  });

  void _reject(BuildContext context) {
    AppSession.pendingRequests
        .removeWhere((r) => r.id == request.id);
    Navigator.pop(context);
  }

  void _accept(BuildContext context) {
    AppSession.pendingRequests
        .removeWhere((r) => r.id == request.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSentScreen(
          amount: request.amount,
          contactName: request.contactName,
        ),
      ),
    );
  }

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
                        "Review payment request",
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

            // Accepting = me sending to requester
            TransferParties(
              senderName: myName,
              recipientName: request.contactName,
            ),

            const SizedBox(height: 24),

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
                      value: "-L${request.amount}",
                    ),
                    ReviewInfoRow(
                      label: "Fees",
                      value: "No fees",
                      valueColor: Colors.grey,
                    ),
                    ReviewInfoRow(
                      label: "Total to pay",
                      value: "L${request.amount}",
                      bold: true,
                    ),
                    const SizedBox(height: 16),
                    ReviewInfoRow(
                      label: "Arriving",
                      value: "Instantly",
                      valueColor: Colors.green.shade600,
                    ),
                    ReviewInfoRow(
                      label: "Note",
                      value: "/",
                      valueColor: Colors.grey,
                    ),
                    const SizedBox(height: 20),

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
                            "L${(AppSession.walletBalance - (double.tryParse(request.amount.replaceAll(RegExp(r',(?=\d{3}(\D|$))'), '').replaceAll(',', '.')) ?? 0)).toStringAsFixed(0)}",
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
            // REJECT / ACCEPT
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => _reject(context),
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
                          "Reject",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _accept(context),
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
                          "Accept",
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
          ],
        ),
      ),
    );
  }
}
