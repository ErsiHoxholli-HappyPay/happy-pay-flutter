import 'dart:math';

import 'package:flutter/material.dart';

enum VoucherState {
  claim,
  loading,
  success,
  failure,
}

class VoucherClaimDialog extends StatefulWidget {
  final String title;
  final int points;

  const VoucherClaimDialog({
    super.key,
    required this.title,
    required this.points,
  });

  @override
  State<VoucherClaimDialog> createState() =>
      _VoucherClaimDialogState();
}

class _VoucherClaimDialogState extends State<VoucherClaimDialog> {
  VoucherState state = VoucherState.claim;

  Future<void> _confirmVoucher() async {
    setState(() {
      state = VoucherState.loading;
    });

    await Future.delayed(const Duration(seconds: 3));

    final success = Random().nextBool();

    if (!mounted) return;

    setState(() {
      state = success
          ? VoucherState.success
          : VoucherState.failure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SizedBox(
        width: 340,
        height: 360,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: switch (state) {
              VoucherState.claim => _claimView(),
              VoucherState.loading => _loadingView(),
              VoucherState.success => _successView(),
              VoucherState.failure => _failureView(),
            },
          ),
        ),
      ),
    );
  }
  
  Widget _claimView() {
    return SizedBox.expand(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Claim Voucher",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "${widget.points} Points",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          "Once confirmed, the required number of points will be deducted from your account and a voucher will be generated.",
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _confirmVoucher,
            child: const Text("Confirm"),
          ),
        ),

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    ),
  );
  }

  Widget _loadingView() {
    return SizedBox.expand(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 24),
        Text(
          "Confirming voucher...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
    );
  }

  Widget _successView() {
    return SizedBox.expand(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 90,
        ),

        const SizedBox(height: 20),

        const Text(
          "Voucher Claimed!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) => route.isFirst,
              );
            },
            child: const Text("Back to Home"),
          ),
        ),
      ],
    ),
    );
  }

  Widget _failureView() {
    return SizedBox.expand(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 90,
        ),

        const SizedBox(height: 20),

        const Text(
          "Something went wrong",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _confirmVoucher,
            child: const Text("Try Again"),
          ),
        ),

        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    ),
    );
  }
}