import 'package:flutter/material.dart';

import 'package:happy_pay_flutter/data/session.dart';

class ChangeLanguageModal extends StatefulWidget {
  const ChangeLanguageModal({super.key});

  static const languages = ['English', 'Shqip'];

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ChangeLanguageModal(),
    );
  }

  @override
  State<ChangeLanguageModal> createState() => _ChangeLanguageModalState();
}

class _ChangeLanguageModalState extends State<ChangeLanguageModal> {
  late String _selected = AppSession.selectedLanguage;

  void _save() {
    AppSession.selectedLanguage = _selected;
    Navigator.pop(context, _selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D7D3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Change language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            for (final language in ChangeLanguageModal.languages)
              RadioListTile<String>(
                value: language,
                // ignore: deprecated_member_use
                groupValue: _selected,
                // ignore: deprecated_member_use
                onChanged: (value) => setState(() => _selected = value!),
                title: Text(language),
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFF1A1A1A),
              ),
            const SizedBox(height: 12),
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
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Save'),
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
