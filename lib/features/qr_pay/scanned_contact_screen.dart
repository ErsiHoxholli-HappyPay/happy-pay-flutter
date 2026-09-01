import 'package:flutter/material.dart';
import '../../data/contacts.dart';
import '../../widgets/back_button.dart';
import '../wallet/new_payment/send_amount_screen.dart';

class ScannedContactScreen extends StatefulWidget {
  final String name;
  final String walletId;

  const ScannedContactScreen({
    super.key,
    required this.name,
    this.walletId = '',
  });

  @override
  State<ScannedContactScreen> createState() =>
      _ScannedContactScreenState();
}

class _ScannedContactScreenState
    extends State<ScannedContactScreen> {
  bool _added = false;

  String get _initials {
    final p = widget.name.trim().split(' ');
    return p.length >= 2
        ? '${p[0][0]}${p[1][0]}'.toUpperCase()
        : widget.name.substring(0, widget.name.length >= 2 ? 2 : 1)
            .toUpperCase();
  }

  void _addToContacts() {
    contacts.add(
      Contact(
        widget.name,
        widget.walletId.isNotEmpty
            ? widget.walletId
            : '+355 600 000 000',
      ),
    );
    setState(() => _added = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.name} added to contacts',
        ),
        duration: const Duration(seconds: 2),
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

            // -----------------------------------------------
            // CONTACT INFO ROW
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade200,
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Add to contacts button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _added ? null : _addToContacts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    disabledBackgroundColor:
                        Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(7),
                    ),
                  ),
                  child: Text(
                    _added ? "Added to contacts" : "Add to contacts",
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),

            // -----------------------------------------------
            // TRANSACTIONS
            // -----------------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Transactions",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Text(
                        "No transactions yet.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          "View all transactions",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              Colors.red.shade600,
                          side: BorderSide(
                            color: Colors.red.shade200,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: Text(
                          "Block ${widget.name.split(' ').first}",
                          style:
                              const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -----------------------------------------------
            // REQUEST / SEND
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SendAmountScreen(
                              contactName: widget.name,
                              isRequest: true,
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          "Request",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SendAmountScreen(
                              contactName: widget.name,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          "Send",
                          style: TextStyle(fontSize: 12),
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
