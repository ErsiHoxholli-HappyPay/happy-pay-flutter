import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../widgets/back_button.dart';
import 'link_status_screen.dart';

class LinkCreditCardScreen extends StatefulWidget {
  final void Function(Map<String, String>)? onLinked;

  const LinkCreditCardScreen({super.key, this.onLinked});

  @override
  State<LinkCreditCardScreen> createState() =>
      _LinkCreditCardScreenState();
}

class _LinkCreditCardScreenState
    extends State<LinkCreditCardScreen> {
  final TextEditingController cardNumberController =
      TextEditingController();

  final TextEditingController expiryController =
      TextEditingController();

  final TextEditingController cvvController =
      TextEditingController();

  bool get canContinue {
    return cardNumberController.text.trim().isNotEmpty &&
        expiryController.text.trim().isNotEmpty &&
        cvvController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    cardNumberController.addListener(_update);
    expiryController.addListener(_update);
    cvvController.addListener(_update);
  }

  void _update() {
    setState(() {});
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();

    super.dispose();
  }

  Future<void> _linkCard() async {
    if (!canContinue) return;

    final raw = cardNumberController.text
        .replaceAll(' ', '')
        .replaceAll('-', '');
    final last4 = raw.length >= 4
        ? raw.substring(raw.length - 4)
        : raw;
    final brand =
        raw.startsWith('4') ? 'Visa' : 'Card';
    final cardData = {
      'type': 'card',
      'brand': brand,
      'last4': last4,
      'bankName': 'Tirana Bank',
    };

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LinkStatusScreen(
          linkingLabel: "Linking card",
          linkedLabel: "Card linked",
          onComplete: () {
            Navigator.pop(context);
            widget.onLinked?.call(cardData);
          },
        ),
      ),
    );

    if (!mounted) return;
    if (widget.onLinked == null) {
      Navigator.pop(context, cardData);
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
                      "Link your credit or debit card",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Easily move money in and out of your haPPy wallet by linking your card.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Card number",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: cardNumberController,
                      keyboardType:
                          TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter card number",
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
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Expiration date",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 6),

                              TextField(
                                controller:
                                    expiryController,
                                keyboardType:
                                    TextInputType.number,
                                inputFormatters: [
                                  _ExpiryDateFormatter(),
                                ],
                                decoration:
                                    InputDecoration(
                                  hintText: "MM/YY",
                                  hintStyle:
                                      const TextStyle(
                                    fontSize: 10,
                                  ),
                                  contentPadding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(6),
                                    borderSide:
                                        BorderSide(
                                      color: Colors
                                          .grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "CVV",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 6),

                              TextField(
                                controller:
                                    cvvController,
                                obscureText: true,
                                keyboardType:
                                    TextInputType.number,
                                decoration:
                                    InputDecoration(
                                  hintText: "3 - Digit CVV",
                                  hintStyle:
                                      const TextStyle(
                                    fontSize: 10,
                                  ),
                                  contentPadding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius
                                            .circular(6),
                                    borderSide:
                                        BorderSide(
                                      color: Colors
                                          .grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      canContinue ? _linkCard : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor:
                        Colors.grey.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Link card",
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

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Cap at 4 digits (MMYY)
    final capped =
        digits.length > 4 ? digits.substring(0, 4) : digits;

    final formatted = capped.length > 2
        ? '${capped.substring(0, 2)}/${capped.substring(2)}'
        : capped;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}