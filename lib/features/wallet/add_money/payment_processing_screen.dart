import 'dart:async';

import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../data/transactions.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final String amount;
  final String? doneLabel;
  final VoidCallback? onDone;

  const PaymentProcessingScreen({
    super.key,
    required this.amount,
    this.doneLabel,
    this.onDone,
  });

  @override
  State<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState
    extends State<PaymentProcessingScreen> {
  bool _isDone = false;

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;
        setState(() => _isDone = true);
      },
    );
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
                  doneLabel: widget.doneLabel,
                  onDone: widget.onDone,
                )
              : _ProcessingView(
                  key: const ValueKey('processing'),
                ),
        ),
      ),
    );
  }
}

class _ProcessingView extends StatelessWidget {
  const _ProcessingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 42,
            height: 42,
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

class _SuccessView extends StatelessWidget {
  final String amount;
  final String? doneLabel;
  final VoidCallback? onDone;

  const _SuccessView({
    super.key,
    required this.amount,
    this.doneLabel,
    this.onDone,
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
              child: Text(
                "You added L$amount to your haPPy wallet!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ),

        // ------------------------------------------------
        // WALLET BALANCE ROW
        // ------------------------------------------------

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
                "L$amount",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        // ------------------------------------------------
        // DONE BUTTON
        // ------------------------------------------------

        Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            14,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onDone ?? () {
                    final added = double.tryParse(
                          amount
                              .replaceAll(RegExp(r',(?=\d{3}(\D|$))'), '')
                              .replaceAll(',', '.'),
                        ) ??
                        0;
                    AppSession.walletBalance += added;
                    addTransaction(
                      'Added to wallet',
                      amount,
                      isCredit: true,
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
              child: Text(
                doneLabel ?? "Done",
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
