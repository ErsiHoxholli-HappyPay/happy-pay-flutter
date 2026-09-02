// lib/widgets/language_toggle_button.dart
import 'package:flutter/material.dart';

/// Presentational only. Owns no state — displays [currentLanguageCode]
/// and reports taps via [onChanged]. Caller decides what happens.
class LanguageToggleButton extends StatelessWidget {
  final String currentLanguageCode; // 'en' or 'sq'
  final ValueChanged<String> onChanged;

  const LanguageToggleButton({
    super.key,
    required this.currentLanguageCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isEnglish = currentLanguageCode == 'en';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _option(label: 'English', code: 'en', selected: isEnglish),
        const SizedBox(width: 8),
        _option(label: 'Shqip', code: 'sq', selected: !isEnglish),
      ],
    );
  }

  Widget _option({
    required String label,
    required String code,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () => onChanged(code),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1A1A1A) : const Color(0xFFF4F3F0),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
