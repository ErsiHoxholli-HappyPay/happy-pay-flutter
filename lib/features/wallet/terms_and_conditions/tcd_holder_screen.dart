import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/terms_and_conditions/terms_and_conditions.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

enum Documents {
  termsAndConditions(
    'happy T&C\'s',
    'haPPy Terms and Conditions',
    'lib/assets/wallet_legal/terms_and_conditions.txt',
    'I acknowledge that I have received, read, and accepted the haPPy Terms and Conditions.',
  ),
  consentData(
    'happy Consent to Data',
    'haPPy Consent to Data Processing',
    'lib/assets/wallet_legal/consent_to_data.txt',
    'I acknowledge that I have received, read, and accepted the haPPy Consent to Data.',
  ),
  otherData(
    'Other Consents',
    'Other Consents and Agreements',
    'lib/assets/wallet_legal/other_consents.txt',
    'I acknowledge that I have received, read, and accepted the Other Consents.',
  );

  final String label;
  final String title;
  final String assetPath;
  final String checkboxLabel;
  const Documents(this.label, this.title, this.assetPath, this.checkboxLabel);
}

class TermsHolderScreen extends StatefulWidget {
  const TermsHolderScreen({super.key});

  @override
  State<TermsHolderScreen> createState() => _TermsHolderScreenState();
}

class _TermsHolderScreenState extends State<TermsHolderScreen> {
  final Map<Documents, bool> _accepted = {
    for (final doc in Documents.values) doc: false,
  };

  bool get _allAccepted => _accepted.values.every((v) => v);
  void _onSelectAllChanged(bool? value) {
    final newValue = value ?? false;
    setState(() {
      for (final doc in Documents.values) {
        _accepted[doc] = newValue;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AppBackButton()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Review haPPy documents",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                for (int i = 0; i < Documents.values.length; i++)
                  _ConsentTile(
                    document: Documents.values[i],
                    isFirst: i == 0,
                    isLast: i == Documents.values.length - 1,
                    value: _accepted[Documents.values[i]]!,
                    onChanged: (value) {
                      setState(() {
                        _accepted[Documents.values[i]] = value ?? false;
                      });
                    },
                  ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Checkbox(
                  value: _allAccepted,
                  onChanged: _onSelectAllChanged,
                  activeColor: Colors.black,
                ),

                Expanded(
                  child: Text(
                    'I acknowledge that I have received, read, and accepted the haPPy Terms and conditions, consent to data and other consents.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.disabled)
                        ? Colors.grey.shade300
                        : Colors.black;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return states.contains(WidgetState.disabled)
                        ? Colors.grey.shade600
                        : Colors.white;
                  }),

                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onPressed: _allAccepted
                    ? () {
                        ShowBottomModal._show(context);
                      }
                    : null,
                child: const Text('I Accept', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.document,
    required this.isFirst,
    required this.isLast,
    required this.value,
    required this.onChanged,
  });

  final Documents document;
  final bool isFirst;
  final bool isLast;
  final bool value;
  final ValueChanged<bool?> onChanged;

  static const _borderSide = BorderSide(color: _borderColor);
  static const _borderColor = Color.fromARGB(199, 85, 79, 79);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: isFirst ? _borderSide : BorderSide.none,
          left: _borderSide,
          right: _borderSide,
          bottom: _borderSide,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
          topRight: isFirst ? const Radius.circular(12) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LegalDocumentScreen(
              title: document.title,
              assetPath: document.assetPath,
              checkboxLabel: document.checkboxLabel,
              nextScreen: const SizedBox.shrink(),
              onAccepted: () {
                Navigator.pop(context);
                onChanged(true);
              },
            ),
          ),
        ),
        child: Row(
          children: [
            Text(document.label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

class ShowBottomModal extends StatelessWidget {
  const ShowBottomModal({super.key});

  static Future<void> _show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (context) => const ShowBottomModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Verification submitted!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please allow up to (X time) to review your application. We’ll send you a notification to let you know about our decision.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          SizedBox(
            height: 50,
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WalletScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith((states) {
                  return Color.fromARGB(255, 0, 0, 0);
                }),
                foregroundColor: WidgetStateColor.resolveWith((states) {
                  return Colors.white;
                }),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
