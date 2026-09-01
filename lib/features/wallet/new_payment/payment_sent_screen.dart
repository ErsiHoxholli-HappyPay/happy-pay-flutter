import 'dart:async';

import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../data/transactions.dart';

class PaymentSentScreen extends StatefulWidget {
  final String amount;
  final String contactName;
  final String? successTitle;
  final String? successMessage;

  const PaymentSentScreen({
    super.key,
    required this.amount,
    required this.contactName,
    this.successTitle,
    this.successMessage,
  });

  @override
  State<PaymentSentScreen> createState() =>
      _PaymentSentScreenState();
}

class _PaymentSentScreenState
    extends State<PaymentSentScreen> {
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _isDone = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isDone
              ? _SuccessView(
                  key: const ValueKey('success'),
                  amount: widget.amount,
                  contactName: widget.contactName,
                  successTitle: widget.successTitle,
                  successMessage: widget.successMessage,
                )
              : const _ProcessingView(
                  key: ValueKey('processing'),
                ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Verifying payment",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------

class _SuccessView extends StatelessWidget {
  final String amount;
  final String contactName;
  final String? successTitle;
  final String? successMessage;

  const _SuccessView({
    super.key,
    required this.amount,
    required this.contactName,
    this.successTitle,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      successTitle ??
                          "Successfully sent L$amount to $contactName!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    if (successMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        successMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            8,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Wallet balance",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "L${AppSession.walletBalance.toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            14,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                final sent = double.tryParse(
                      amount
                          .replaceAll(RegExp(r',(?=\d{3}(\D|$))'), '')
                          .replaceAll(',', '.'),
                    ) ??
                    0;
                AppSession.walletBalance -= sent;
                addTransaction(
                  contactName,
                  amount,
                  isCredit: false,
                );
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                "Back to home",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
