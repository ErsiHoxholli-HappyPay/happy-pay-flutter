// enable_setting_button.dart
import 'package:flutter/material.dart';

class EnableButton extends StatelessWidget {
  const EnableButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final Icon icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              icon,
              const SizedBox(width: 10),
              Text(label),
              const Spacer(),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: const Color(0xFF2F80ED),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
