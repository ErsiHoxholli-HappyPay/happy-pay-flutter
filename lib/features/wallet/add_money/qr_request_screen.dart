import 'package:flutter/material.dart';
import '../../../widgets/back_button.dart';
import 'qr_code_screen.dart';

class QRRequestScreen extends StatefulWidget {
  const QRRequestScreen({super.key});

  @override
  State<QRRequestScreen> createState() =>
      _QRRequestScreenState();
}

class _QRRequestScreenState extends State<QRRequestScreen> {
  String amount = "0";

  bool get _canGenerate => amount != "0";

  void _addNumber(String number) {
    setState(() {
      if (amount == "0") {
        amount = number;
      } else {
        amount += number;
      }
    });
  }

  void _addDecimal() {
    setState(() {
      if (!amount.contains(",")) {
        amount += ",";
      }
    });
  }

  void _deleteNumber() {
    setState(() {
      if (amount.length <= 1) {
        amount = "0";
      } else {
        amount = amount.substring(0, amount.length - 1);
      }
    });
  }

  Widget _numberButton(String text, {VoidCallback? onPressed}) {
    return Expanded(
      child: SizedBox(
        height: 54,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
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
          children: [

            // ------------------------------------------------
            // HEADER
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Add money",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ------------------------------------------------
            // AMOUNT
            // ------------------------------------------------

            const Text(
              "Amount to request",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "L$amount",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 24),

            // ------------------------------------------------
            // METHOD ROW
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F8F8),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xffEEEEEE),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Paying with",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.qr_code,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Request via QR Code",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize
                                .shrinkWrap,
                          ),
                          child: const Text(
                            "Change",
                            style:
                                TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ------------------------------------------------
            // WALLET BALANCE
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Wallet balance",
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    "L20",
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------------------------------
            // KEYPAD
            // ------------------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _numberButton("1",
                            onPressed: () =>
                                _addNumber("1")),
                        _numberButton("2",
                            onPressed: () =>
                                _addNumber("2")),
                        _numberButton("3",
                            onPressed: () =>
                                _addNumber("3")),
                      ],
                    ),
                    Row(
                      children: [
                        _numberButton("4",
                            onPressed: () =>
                                _addNumber("4")),
                        _numberButton("5",
                            onPressed: () =>
                                _addNumber("5")),
                        _numberButton("6",
                            onPressed: () =>
                                _addNumber("6")),
                      ],
                    ),
                    Row(
                      children: [
                        _numberButton("7",
                            onPressed: () =>
                                _addNumber("7")),
                        _numberButton("8",
                            onPressed: () =>
                                _addNumber("8")),
                        _numberButton("9",
                            onPressed: () =>
                                _addNumber("9")),
                      ],
                    ),
                    Row(
                      children: [
                        _numberButton(",",
                            onPressed: _addDecimal),
                        _numberButton("0",
                            onPressed: () =>
                                _addNumber("0")),
                        _numberButton("⌫",
                            onPressed: _deleteNumber),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------
            // GENERATE BUTTON
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                14,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _canGenerate
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  QRCodeScreen(
                                amount: amount,
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
                    "Generate QR Code",
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
