import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/onboarding/phone_number_screen.dart';

class ConfirmModal extends StatelessWidget {
  const ConfirmModal({
    super.key,
    required this.title,
    required this.description,
    required this.buttonLabel,
    this.onConfirm,
  });
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback? onConfirm;

  static Future<void> showSignOut(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (_) => ConfirmModal(
        title: 'Are you sure?',
        description: 'You will need to login again.',
        buttonLabel: 'Yes, Sign Out',
        onConfirm: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PhoneNumberScreen()),
        ),
      ),
    );
  }

  static Future<void> showEditDetails(
    BuildContext context, {
    VoidCallback? onConfirm,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (_) => ConfirmModal(
        title: 'Are you sure you want to edit your information?',
        description:
            'Your information must be accurate, up to date, and match your government-issued ID you will provide i the next steps. You have one opportunity to update this information before verification. Once submitted, changes will be locked until your identity is verified.',
        buttonLabel: 'Continue',
        onConfirm: onConfirm,
      ),
    );
  }

  void _confirmEditing(BuildContext context) {
    Navigator.pop(context);
    onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A1A1A),
                      side: const BorderSide(color: Color(0xFFD9D7D3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmEditing(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(buttonLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
