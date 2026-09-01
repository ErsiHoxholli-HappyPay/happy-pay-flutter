import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/contacts.dart';
import '../../widgets/back_button.dart';
import '../qr_pay/qr_scanner_screen.dart';
import 'new_payment/contact_detail_screen.dart';
import 'new_payment/direct_payment_input_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() =>
      _ContactsScreenState();
}

class _ContactsScreenState
    extends State<ContactsScreen> {
  final TextEditingController _searchController =
      TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Contact> get _filtered {
    final list = contacts;
    if (_query.isEmpty) return list;
    return list
        .where((c) =>
            c.name
                .toLowerCase()
                .contains(_query.toLowerCase()) ||
            c.phoneNumber.contains(_query))
        .toList();
  }

  Future<void> _invite(Contact c) async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Join me on haPPy wallet! Easy, no-fee transfers '
            'between family and friends. Download the app: '
            'https://happypay.app/invite',
        subject: 'Join me on haPPy Wallet',
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

            // -----------------------------------------------
            // HEADER
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                8,
                4,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Contacts",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) => _AddFriendSheet(
                        parentContext: context,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 20),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------
            // SEARCH
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                6,
                14,
                0,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: "Search by name, phone number",
                  hintStyle: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 16,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
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
            ),

            // -----------------------------------------------
            // CONTACTS LIST
            // -----------------------------------------------

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4),
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final c = _filtered[i];
                  return InkWell(
                    onTap: c.hasAccount
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ContactDetailScreen(
                                  contact: c,
                                ),
                              ),
                            )
                        : null,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Colors.grey.shade200,
                            child: Text(
                              c.initials,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.name,
                                  style:
                                      const TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  c.maskedPhone,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors
                                        .grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!c.hasAccount)
                            OutlinedButton(
                              onPressed: () => _invite(c),
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Colors.black,
                                side: BorderSide(
                                  color:
                                      Colors.grey.shade300,
                                ),
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                    MaterialTapTargetSize
                                        .shrinkWrap,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          6),
                                ),
                              ),
                              child: const Text(
                                "Invite",
                                style:
                                    TextStyle(fontSize: 11),
                              ),
                            )
                          else ...[
                            Icon(
                              Icons.star_border,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------

class _AddFriendSheet extends StatelessWidget {
  final BuildContext parentContext;

  const _AddFriendSheet({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
            "Add a haPPy friend",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          _SheetOption(
            label: "Scan haPPy QR Code",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (_) => const QRScannerScreen(
                    previousIndex: 1,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          _SheetOption(
            label: "Add by Phone number",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                parentContext,
                MaterialPageRoute(
                  builder: (_) =>
                      const DirectPaymentInputScreen(
                    title: "Add by Phone",
                    label: "Phone number",
                    hint: "Enter phone number",
                    keyboardType: TextInputType.phone,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(
                    color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SheetOption({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
