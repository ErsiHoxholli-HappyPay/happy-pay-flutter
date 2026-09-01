import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../models/bank_account.dart';
import '../../../models/payment_card.dart';
import '../../../widgets/back_button.dart';
import 'payment_methods_screen.dart';
import 'payment_processing_screen.dart';
import 'qr_request_screen.dart';
import 'save_payment_method_sheet.dart';
import '../../../data/transactions.dart';

class AddMoneyScreen extends StatefulWidget {
  final bool isTopUpMode;

  const AddMoneyScreen({super.key, this.isTopUpMode = false});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  String amount = "0";
  Map<String, String>? _selectedCard;

  bool get _canContinue =>
      amount != "0" && _selectedCard != null;

  @override
  void initState() {
    super.initState();
    final cards = AppSession.currentUser?.savedCards;
    if (cards != null && cards.isNotEmpty) {
      final c = cards.first;
      _selectedCard = {'type': 'card', 'brand': c.brand, 'last4': c.last4};
    } else {
      final banks = AppSession.currentUser?.savedBankAccounts;
      if (banks != null && banks.isNotEmpty) {
        final b = banks.first;
        _selectedCard = {
          'type': 'bank',
          'brand': b.bankName,
          'last4': b.last4,
          'iban': b.iban,
        };
      }
    }
  }

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

  Widget _numberButton(
    String text, {
    VoidCallback? onPressed,
  }) {
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
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectPaymentMethod() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) => const PaymentMethodsScreen(),
    );
    if (result == null || !mounted) return;

    // QR request is its own flow — navigate directly instead of saving as method
    if (result['type'] == 'qr_request') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const QRRequestScreen(),
        ),
      );
      return;
    }

    setState(() => _selectedCard = result);

    final type = result['type'] ?? 'card';
    final isCard = type == 'card';
    final alreadySaved = isCard
        ? (AppSession.currentUser?.savedCards.any(
              (c) =>
                  c.brand == result['brand'] &&
                  c.last4 == result['last4'],
            ) ??
            false)
        : (AppSession.currentUser?.savedBankAccounts.any(
              (b) => b.iban == (result['iban'] ?? result['last4']),
            ) ??
            false);

    if (!alreadySaved && mounted) {
      final save = await showModalBottomSheet<bool>(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        builder: (_) => SavePaymentMethodSheet(
          title: isCard
              ? "Save this card?"
              : "Save this bank account?",
          description: isCard
              ? "Saving this card as your payment method will make adding money easier and faster next time."
              : "Saving this bank account will make adding money easier and faster next time.",
          saveLabel: isCard ? "Save card" : "Save bank account",
        ),
      );
      if (save == true && mounted) {
        if (isCard) {
          AppSession.currentUser?.savedCards.add(
            PaymentCard(
              brand: result['brand']!,
              last4: result['last4']!,
              bankName: result['bankName'],
            ),
          );
        } else {
          AppSession.currentUser?.savedBankAccounts.add(
            BankAccount(
              bankName: result['brand']!,
              iban: result['iban'] ?? result['last4']!,
            ),
          );
        }
      }
    }
  }

  Future<void> _onContinue() async {
    if (!_canContinue) return;
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          amount: amount,
          doneLabel: widget.isTopUpMode
              ? 'Continue to payment'
              : null,
          onDone: widget.isTopUpMode
              ? () {
                  final added = double.tryParse(
                        amount
                            .replaceAll(RegExp(r',(?=\d{3}(\D|$))'), '')
                            .replaceAll(',', '.'),
                      ) ??
                      0;
                  AppSession.walletBalance += added;
                  addTransaction(
                    'Added to wallet',
                    amount,
                    isCredit: true,
                  );
                  final nav = Navigator.of(context);
                  nav.pop(); // pop ProcessingScreen
                  nav.pop(); // pop AddMoneyScreen
                }
              : null,
        ),
      ),
    );
  }

  Widget _paymentMethodButton() {
    if (_selectedCard != null) {
      final isBank =
          (_selectedCard!['type'] ?? 'card') == 'bank';
      return Row(
        children: [
          if (isBank)
            Icon(
              Icons.account_balance,
              size: 20,
              color: Colors.grey.shade400,
            )
          else
            Container(
              width: 28,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isBank
                      ? _selectedCard!['brand']!
                      : '${_selectedCard!['brand']} Debit',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isBank
                      ? 'IBAN •••• ${_selectedCard!["last4"]}'
                      : '•••• ${_selectedCard!["last4"]}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          TextButton(
            onPressed: _selectPaymentMethod,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Change",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: _selectPaymentMethod,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(
            color: Colors.grey.shade200,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.add,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              "Add payment method",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            Spacer(),
            Icon(
              Icons.chevron_right,
              size: 18,
            ),
          ],
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
              "Amount to add",
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
            // PAYING WITH
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

                    _paymentMethodButton(),
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
                children: [
                  const Text(
                    "Wallet balance",
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    "L${AppSession.walletBalance.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 11,
                    ),
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
                        _numberButton(
                          "1",
                          onPressed: () =>
                              _addNumber("1"),
                        ),
                        _numberButton(
                          "2",
                          onPressed: () =>
                              _addNumber("2"),
                        ),
                        _numberButton(
                          "3",
                          onPressed: () =>
                              _addNumber("3"),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        _numberButton(
                          "4",
                          onPressed: () =>
                              _addNumber("4"),
                        ),
                        _numberButton(
                          "5",
                          onPressed: () =>
                              _addNumber("5"),
                        ),
                        _numberButton(
                          "6",
                          onPressed: () =>
                              _addNumber("6"),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        _numberButton(
                          "7",
                          onPressed: () =>
                              _addNumber("7"),
                        ),
                        _numberButton(
                          "8",
                          onPressed: () =>
                              _addNumber("8"),
                        ),
                        _numberButton(
                          "9",
                          onPressed: () =>
                              _addNumber("9"),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        _numberButton(
                          ",",
                          onPressed: _addDecimal,
                        ),
                        _numberButton(
                          "0",
                          onPressed: () =>
                              _addNumber("0"),
                        ),
                        _numberButton(
                          "⌫",
                          onPressed: _deleteNumber,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------
            // CONTINUE
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
                height: 40,
                child: ElevatedButton(
                  onPressed:
                      _canContinue ? _onContinue : null,
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
                  child: Text(
                    widget.isTopUpMode
                        ? 'Continue to payment!'
                        : 'Continue',
                    style: const TextStyle(
                      fontSize: 13,
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