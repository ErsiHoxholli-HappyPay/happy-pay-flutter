import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/loan/loan_added_success_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class LoanPinScreen extends StatefulWidget {
  const LoanPinScreen({super.key});

  static const _pinLength = 4;
  static const _correctPin = '0000';

  @override
  State<LoanPinScreen> createState() => _LoanPinScreenState();
}

class _LoanPinScreenState extends State<LoanPinScreen> {
  String _entered = '';

  void _addDigit(String digit) {
    if (_entered.length >= LoanPinScreen._pinLength) return;
    setState(() => _entered += digit);

    if (_entered.length == LoanPinScreen._pinLength) {
      if (_entered == LoanPinScreen._correctPin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoanAddedSuccessScreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Incorrect PIN code')));
        setState(() => _entered = '');
      }
    }
  }

  void _delete() {
    if (_entered.isEmpty) return;
    setState(() => _entered = _entered.substring(0, _entered.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Enter your PIN code (0000)\nto confirm new loan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < LoanPinScreen._pinLength; i++) ...[
                    _PinBox(filled: i < _entered.length),
                    if (i != LoanPinScreen._pinLength - 1)
                      const SizedBox(width: 12),
                  ],
                ],
              ),
              const Spacer(),
              _Keypad(onDigit: _addDigit, onDelete: _delete),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinBox extends StatelessWidget {
  const _PinBox({required this.filled});
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: filled
          ? Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onDigit, required this.onDelete});
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in const [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
        ])
          Row(
            children: [
              for (final digit in row)
                _KeyButton(label: digit, onTap: () => onDigit(digit)),
            ],
          ),
        Row(
          children: [
            _KeyButton(icon: Icons.center_focus_weak, onTap: () {}),
            _KeyButton(label: '0', onTap: () => onDigit('0')),
            _KeyButton(icon: Icons.backspace_outlined, onTap: onDelete),
          ],
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({this.label, this.icon, required this.onTap});
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 64,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(foregroundColor: Colors.black),
          child: icon != null
              ? Icon(icon, size: 22)
              : Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
