import 'package:flutter/material.dart';
import '../../../widgets/back_button.dart';
import 'bills_services_screen.dart';
import 'review_bill_payment_screen.dart';

class BillEntryScreen extends StatefulWidget {
  final BillService service;

  const BillEntryScreen({super.key, required this.service});

  @override
  State<BillEntryScreen> createState() =>
      _BillEntryScreenState();
}

class _BillEntryScreenState extends State<BillEntryScreen> {
  String _contract = '';

  bool get _canContinue => _contract.isNotEmpty;

  void _addDigit(String d) {
    if (_contract.replaceAll('-', '').length >= 16) return;
    setState(() => _contract += d);
  }

  void _delete() {
    if (_contract.isEmpty) return;
    setState(() =>
        _contract = _contract.substring(0, _contract.length - 1));
  }

  // Format as XXXX-XXXX-XXXX-XXXX
  String get _formatted {
    final digits = _contract.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write('-');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  Widget _key(String label, {VoidCallback? onTap}) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
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
                16,
                20,
                0,
              ),
              child: Text(
                widget.service.name,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                6,
                20,
                20,
              ),
              child: Text(
                "Enter your ${widget.service.contractLabel}",
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ----------------------------------------
            // CONTRACT NUMBER DISPLAY
            // ----------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _contract.isEmpty
                      ? '— — — —'
                      : _formatted,
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 1,
                    color: _contract.isEmpty
                        ? Colors.grey.shade400
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ----------------------------------------
            // CONTINUE
            // ----------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _canContinue
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReviewBillPaymentScreen(
                                service: widget.service,
                                contractNumber:
                                    _formatted,
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
            ),

            // ----------------------------------------
            // KEYPAD
            // ----------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(children: [
                      _key("1", onTap: () => _addDigit("1")),
                      _key("2", onTap: () => _addDigit("2")),
                      _key("3", onTap: () => _addDigit("3")),
                    ]),
                    Row(children: [
                      _key("4", onTap: () => _addDigit("4")),
                      _key("5", onTap: () => _addDigit("5")),
                      _key("6", onTap: () => _addDigit("6")),
                    ]),
                    Row(children: [
                      _key("7", onTap: () => _addDigit("7")),
                      _key("8", onTap: () => _addDigit("8")),
                      _key("9", onTap: () => _addDigit("9")),
                    ]),
                    Row(children: [
                      const Expanded(child: SizedBox()),
                      _key("0", onTap: () => _addDigit("0")),
                      _key("⌫", onTap: _delete),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
