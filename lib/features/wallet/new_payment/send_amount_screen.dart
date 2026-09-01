import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../widgets/back_button.dart';
import '../../wallet/add_money/add_money_screen.dart';
import 'review_payment_screen.dart';
import 'review_request_screen.dart';

class SendAmountScreen extends StatefulWidget {
  final String contactName;
  final bool isRequest;

  const SendAmountScreen({
    super.key,
    required this.contactName,
    this.isRequest = false,
  });

  @override
  State<SendAmountScreen> createState() =>
      _SendAmountScreenState();
}

class _SendAmountScreenState
    extends State<SendAmountScreen> {
  String amount = "0";
  final TextEditingController _noteController =
      TextEditingController();

  bool get _canContinue => amount != "0";

  void _addNumber(String n) => setState(() {
        amount = amount == "0" ? n : amount + n;
      });

  void _addDecimal() => setState(() {
        if (!amount.contains(",")) amount += ",";
      });

  void _delete() => setState(() {
        amount = amount.length <= 1
            ? "0"
            : amount.substring(0, amount.length - 1);
      });

  Widget _key(String text, {VoidCallback? onTap}) {
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
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myName =
        AppSession.currentUser?.name ?? 'My Name';

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // -----------------------------------------------
            // HEADER
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                8,
                12,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.isRequest
                            ? "Request money"
                            : "Send money",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -----------------------------------------------
            // SENDER → RECEIVER
            // -----------------------------------------------

            TransferParties(
              senderName:
                  widget.isRequest ? widget.contactName : myName,
              recipientName:
                  widget.isRequest ? myName : widget.contactName,
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------
            // AMOUNT
            // -----------------------------------------------

            Text(
              "L$amount",
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            // Note field (inline, borderless)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: TextField(
                controller: _noteController,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                decoration: InputDecoration(
                  hintText: "Add note",
                  hintStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // -----------------------------------------------
            // WALLET BALANCE
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Wallet balance",
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    "L${AppSession.walletBalance.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // -----------------------------------------------
            // KEYPAD
            // -----------------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    Row(children: [
                      _key("1", onTap: () => _addNumber("1")),
                      _key("2", onTap: () => _addNumber("2")),
                      _key("3", onTap: () => _addNumber("3")),
                    ]),
                    Row(children: [
                      _key("4", onTap: () => _addNumber("4")),
                      _key("5", onTap: () => _addNumber("5")),
                      _key("6", onTap: () => _addNumber("6")),
                    ]),
                    Row(children: [
                      _key("7", onTap: () => _addNumber("7")),
                      _key("8", onTap: () => _addNumber("8")),
                      _key("9", onTap: () => _addNumber("9")),
                    ]),
                    Row(children: [
                      _key(",", onTap: _addDecimal),
                      _key("0", onTap: () => _addNumber("0")),
                      _key("⌫", onTap: _delete),
                    ]),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------
            // CONTINUE
            // -----------------------------------------------

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
                  onPressed: _canContinue
                      ? () {
                          final balance =
                              AppSession.walletBalance;
                          final needed = double.tryParse(
                                amount.replaceAll(',', '.'),
                              ) ??
                              0;
                          if (!widget.isRequest &&
                              needed > balance) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor:
                                  Colors.white,
                              isScrollControlled: true,
                              shape:
                                  const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (_) =>
                                  _InsufficientSheet(
                                needed: needed,
                                balance: balance,
                                onAddMoney: () async {
                                  Navigator.pop(context);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AddMoneyScreen(
                                        isTopUpMode: true,
                                      ),
                                    ),
                                  );
                                  if (mounted) setState(() {});
                                },
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => widget.isRequest
                                  ? ReviewRequestScreen(
                                      amount: amount,
                                      contactName:
                                          widget.contactName,
                                      note: _noteController
                                          .text
                                          .trim(),
                                    )
                                  : ReviewPaymentScreen(
                                      amount: amount,
                                      contactName:
                                          widget.contactName,
                                      note: _noteController
                                          .text
                                          .trim(),
                                    ),
                            ),
                          );
                        }
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
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------

class TransferParties extends StatelessWidget {
  final String senderName;
  final String recipientName;

  const TransferParties({
    super.key,
    required this.senderName,
    required this.recipientName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PartyAvatar(name: senderName),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            children: [
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
        PartyAvatar(name: recipientName),
      ],
    );
  }
}

class PartyAvatar extends StatelessWidget {
  final String name;
  final bool verified;

  const PartyAvatar({super.key, required this.name, this.verified = false});

  String get _initials {
    final p = name.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (verified)
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          name.split(' ').first,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------

class _InsufficientSheet extends StatelessWidget {
  final double needed;
  final double balance;
  final VoidCallback onAddMoney;

  const _InsufficientSheet({
    required this.needed,
    required this.balance,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        MediaQuery.of(context).padding.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Container(
              width: 35,
              height: 3,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Text(
            "Insufficient balance",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Your wallet balance is L${balance.toStringAsFixed(0)}, "
            "but you need L${needed.toStringAsFixed(0)}. "
            "Add money to continue with this payment.",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onAddMoney,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                "Add money",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
