import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lucky_spin_result.dart';

class LuckySpinWheel extends StatefulWidget {
  const LuckySpinWheel({super.key});

  static const _prizes = [
    'Prize 1',
    'Prize 2',
    'Prize 3',
    'Prize 4',
    'Prize 5',
    'Prize 6',
    'Prize 7',
    'Prize 8',
  ];
  static const _cooldown = Duration(hours: 24);
  static const _prefsKey = 'lucky_spin_last_spin_ts';

  @override
  State<LuckySpinWheel> createState() => _LuckySpinWheelState();
}

class _LuckySpinWheelState extends State<LuckySpinWheel> {
  final _selected = StreamController<int>.broadcast();
  Timer? _countdownTimer;
  Duration? _remaining;
  bool _isSpinning = false;

  @override
  void initState() {
    super.initState();
    _loadLastSpin();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _selected.close();
    super.dispose();
  }

  Future<void> _loadLastSpin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTs = prefs.getInt(LuckySpinWheel._prefsKey);
    if (lastTs == null) return;

    final elapsed = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(lastTs),
    );
    final remaining = LuckySpinWheel._cooldown - elapsed;
    if (remaining > Duration.zero) {
      _startCountdown(remaining);
    }
  }

  void _startCountdown(Duration initial) {
    setState(() => _remaining = initial);
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = _remaining! - const Duration(seconds: 1);
      if (next <= Duration.zero) {
        timer.cancel();
        setState(() => _remaining = null);
      } else {
        setState(() => _remaining = next);
      }
    });
  }

  int? _lastSelectedIndex;

  void _handleSpinTrigger() {
    if (_isSpinning || _remaining != null) return;
    final index = Random().nextInt(LuckySpinWheel._prizes.length);
    _lastSelectedIndex = index;
    setState(() => _isSpinning = true);
    _selected.add(index);
  }

  Future<void> _onAnimationEnd() async {
    setState(() => _isSpinning = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      LuckySpinWheel._prefsKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    _startCountdown(LuckySpinWheel._cooldown);

    final index = _lastSelectedIndex;
    if (index != null && mounted) {
      await LuckySpinResult.show(
        context,
        prizeLabel: LuckySpinWheel._prizes[index],
      );
    }
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final onCooldown = _remaining != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onCooldown) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Next spin available in ${_formatDuration(_remaining!)}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),
        ],
        const Text(
          'Spin to win points\nand coupons',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Click or drag the wheel to claim your prize!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: _handleSpinTrigger,
          child: AspectRatio(
            aspectRatio: 1,
            child: FortuneWheel(
              selected: _selected.stream,
              animateFirst: false,
              onAnimationEnd: _onAnimationEnd,
              physics: CircularPanPhysics(
                duration: const Duration(seconds: 1),
                curve: Curves.decelerate,
              ),
              onFling: _handleSpinTrigger,
              items: [
                for (int i = 0; i < LuckySpinWheel._prizes.length; i++)
                  FortuneItem(
                    style: FortuneItemStyle(
                      color: i.isEven ? Colors.black : Colors.white,
                      borderColor: Colors.grey.shade400,
                      borderWidth: 1,
                    ),
                    child: Text(
                      LuckySpinWheel._prizes[i],
                      style: TextStyle(
                        color: i.isEven ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
