import 'package:flutter/material.dart';
import '../../../widgets/back_button.dart';
import 'link_status_screen.dart';

class LinkBankAccountScreen extends StatefulWidget {
  final void Function(Map<String, String>)? onLinked;

  const LinkBankAccountScreen({super.key, this.onLinked});

  @override
  State<LinkBankAccountScreen> createState() =>
      _LinkBankAccountScreenState();
}

class _LinkBankAccountScreenState
    extends State<LinkBankAccountScreen> {
  final TextEditingController _ibanController =
      TextEditingController();

  bool get _canContinue =>
      _ibanController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _ibanController.addListener(_update);
  }

  void _update() => setState(() {});

  @override
  void dispose() {
    _ibanController.dispose();
    super.dispose();
  }

  Future<void> _linkAccount() async {
    if (!_canContinue) return;

    final iban = _ibanController.text.trim();
    final last4 =
        iban.length >= 4 ? iban.substring(iban.length - 4) : iban;
    final bankData = {
      'type': 'bank',
      'brand': 'Tirana Bank',
      'last4': last4,
      'iban': iban,
    };

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LinkStatusScreen(
          linkingLabel: "Linking account",
          linkedLabel: "Account linked",
          onComplete: () {
            Navigator.pop(context);
            widget.onLinked?.call(bankData);
          },
        ),
      ),
    );

    if (!mounted) return;
    if (widget.onLinked == null) {
      Navigator.pop(context, bankData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const AppBackButton(),

                    const SizedBox(height: 18),

                    const Text(
                      "Link your bank account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Easily move money in and out of your haPPy wallet by linking your bank account.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "IBAN number",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: _ibanController,
                      textCapitalization:
                          TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: "Enter IBAN number",
                        hintStyle: const TextStyle(
                          fontSize: 10,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Supported bank accounts include:",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        "• Tirana Bank",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed:
                      _canContinue ? _linkAccount : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor:
                        Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Link bank account",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
