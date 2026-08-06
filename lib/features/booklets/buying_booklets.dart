import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/session.dart';
import 'package:happy_pay_flutter/features/booklets/booklets_screen.dart';

enum _BuyStage { confirm, loading, success }

class BuyingBookletDialog extends StatefulWidget {
  final BookletData data;
  final VoidCallback onGoHome;
  final VoidCallback onSeeCoupons;

  const BuyingBookletDialog({
    super.key,
    required this.data,
    required this.onGoHome,
    required this.onSeeCoupons,
  });

  @override
  State<BuyingBookletDialog> createState() => _BuyingBookletDialogState();
}

class _BuyingBookletDialogState extends State<BuyingBookletDialog> {
  _BuyStage _stage = _BuyStage.confirm;

  Future<void> _onConfirm() async {
    setState(() => _stage = _BuyStage.loading);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _stage = _BuyStage.success);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_stage) {
          _BuyStage.confirm => _ConfirmContent(
            key: const ValueKey('confirm'),
            data: widget.data,
            onConfirm: _onConfirm,
            onCancel: () => Navigator.of(context).pop(),
          ),
          _BuyStage.loading => const _LoadingContent(key: ValueKey('loading')),
          _BuyStage.success => _SuccessContent(
            key: const ValueKey('success'),
            onSeeCoupons: widget.onSeeCoupons,
            onGoHome: widget.onGoHome,
          ),
        },
      ),
    );
  }
}

class _ConfirmContent extends StatelessWidget {
  final BookletData data;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ConfirmContent({
    super.key,
    required this.data,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final userPoints = AppSession.currentUser?.happyPoints ?? 0;
    final remaining = (userPoints - data.points).clamp(0, userPoints);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Buy ${data.title}\nfor ${data.points} points?',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "You'll have $remaining haPPy points left in your account.",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
            ),
            child: const Text(
              'Confirm and Buy Booklet',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 56, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.black),
          SizedBox(height: 24),
          Text('Buying booklet', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  final VoidCallback onSeeCoupons;
  final VoidCallback onGoHome;

  const _SuccessContent({
    super.key,
    required this.onSeeCoupons,
    required this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 20),
              const Text(
                'Coupons were added to\nyour account!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: onSeeCoupons,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'See coupons',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onGoHome,
                child: const Text(
                  'Go back home',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: IconButton(icon: const Icon(Icons.close), onPressed: onGoHome),
        ),
      ],
    );
  }
}
