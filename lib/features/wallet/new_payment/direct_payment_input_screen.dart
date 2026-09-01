import 'package:flutter/material.dart';
import '../../../widgets/back_button.dart';
import 'send_amount_screen.dart';

class DirectPaymentInputScreen extends StatefulWidget {
  final String title;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextCapitalization capitalization;

  const DirectPaymentInputScreen({
    super.key,
    required this.title,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.capitalization = TextCapitalization.none,
  });

  @override
  State<DirectPaymentInputScreen> createState() =>
      _DirectPaymentInputScreenState();
}

class _DirectPaymentInputScreenState
    extends State<DirectPaymentInputScreen> {
  final TextEditingController _controller =
      TextEditingController();

  bool get _canContinue =>
      _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                8,
                16,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                24,
              ),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _controller,
                    keyboardType: widget.keyboardType,
                    textCapitalization: widget.capitalization,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _canContinue
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SendAmountScreen(
                                    contactName: _controller
                                        .text
                                        .trim(),
                                  ),
                                ),
                              )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        disabledBackgroundColor:
                            Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
