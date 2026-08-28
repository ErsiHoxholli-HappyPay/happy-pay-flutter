// settings_buttons.dart
import 'package:flutter/material.dart';

class SettingsButtons extends StatelessWidget {
  const SettingsButtons({
    super.key,
    this.icon,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    this.showHelpBadge = false,
    required this.onTap,
  });

  final Icon? icon;
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool showHelpBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) => backgroundColor,
            ),
            foregroundColor: WidgetStateColor.resolveWith(
              (states) => foregroundColor,
            ),
            shape: WidgetStateOutlinedBorder.resolveWith(
              (states) => RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              if (showHelpBadge) ...[
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.question_mark,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              ?icon,
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
