import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../widgets/back_button.dart';
import '../../wallet/widgets/review_info_row.dart';
import 'request_sent_screen.dart';
import 'send_amount_screen.dart' show TransferParties;

class ReviewRequestScreen extends StatelessWidget {
  final String amount;
  final String contactName;
  final String note;

  const ReviewRequestScreen({
    super.key,
    required this.amount,
    required this.contactName,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final myName = AppSession.currentUser?.name ?? 'My Name';

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
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

            // Request direction: contact → me
            TransferParties(
              senderName: contactName,
              recipientName: myName,
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ReviewInfoRow(label: "Wallet balance", value: "L${AppSession.walletBalance.toStringAsFixed(0)}"),
                    ReviewInfoRow(
                      label: "Request amount",
                      value: "L$amount",
                      bold: true,
                    ),
                    ReviewInfoRow(
                      label: "Fees",
                      value: "No Fees",
                      valueColor: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    ReviewInfoRow(
                      label: "Arriving",
                      value: "Instantly",
                      valueColor: Colors.green.shade600,
                    ),
                    if (note.isNotEmpty)
                      ReviewInfoRow(label: "Note", value: note),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RequestSentScreen(
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
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    "Request",
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
