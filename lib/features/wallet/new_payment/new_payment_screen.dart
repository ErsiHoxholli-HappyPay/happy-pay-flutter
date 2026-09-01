import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/contacts.dart';
import '../../../widgets/back_button.dart';
import '../../qr_pay/qr_scanner_screen.dart';
import 'bills_services_screen.dart';
import 'direct_payment_input_screen.dart';
import 'contact_detail_screen.dart';

class NewPaymentScreen extends StatefulWidget {
  const NewPaymentScreen({super.key});

  @override
  State<NewPaymentScreen> createState() =>
      _NewPaymentScreenState();
}

class _NewPaymentScreenState
    extends State<NewPaymentScreen> {
  final TextEditingController _searchController =
      TextEditingController();
  String _query = '';

  List<Contact> get _filtered => _query.isEmpty
      ? contacts
      : contacts
          .where((c) =>
              c.name
                  .toLowerCase()
                  .contains(_query.toLowerCase()) ||
              c.phoneNumber.contains(_query))
          .toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggested =
        contacts.where((c) => c.hasAccount).take(4).toList();

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
                  const Expanded(
                    child: Center(
                      child: Text(
                        "New payment",
                        style: TextStyle(
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

            // -----------------------------------------------
            // SEARCH
            // -----------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                6,
                14,
                10,
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
            // LISTS
            // -----------------------------------------------

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // CONTACTS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        14,
                        0,
                        14,
                        4,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Contacts",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text(
                              "All contacts >",
                              style:
                                  TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ..._filtered.map(
                      (c) => _ContactRow(
                        contact: c,
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
                      ),
                    ),

                    if (_query.isEmpty) ...[

                      // OTHER
                      const Padding(
                        padding: EdgeInsets.fromLTRB(
                          14,
                          16,
                          14,
                          6,
                        ),
                        child: Text(
                          "Other",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      _OtherOption(
                        icon: Icons.account_balance,
                        label: "Pay to IBAN",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DirectPaymentInputScreen(
                              title: "Pay to IBAN",
                              label: "IBAN number",
                              hint:
                                  "Enter recipient IBAN",
                              capitalization:
                                  TextCapitalization
                                      .characters,
                            ),
                          ),
                        ),
                      ),
                      _OtherOption(
                        icon: Icons.phone,
                        label: "Pay to phone number",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DirectPaymentInputScreen(
                              title: "Pay to phone",
                              label: "Phone number",
                              hint:
                                  "Enter phone number",
                              keyboardType:
                                  TextInputType.phone,
                            ),
                          ),
                        ),
                      ),
                      _OtherOption(
                        icon: Icons.qr_code,
                        label: "QR Pay",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const QRScannerScreen(
                              previousIndex: 1,
                            ),
                          ),
                        ),
                      ),
                      _OtherOption(
                        icon: Icons.receipt_long,
                        label:
                            "Pay for bills & services",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const BillsServicesScreen(),
                          ),
                        ),
                      ),

                      // SUGGESTED
                      const Padding(
                        padding: EdgeInsets.fromLTRB(
                          14,
                          16,
                          14,
                          10,
                        ),
                        child: Text(
                          "Suggested",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 72,
                        child: ListView.separated(
                          scrollDirection:
                              Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                          ),
                          itemCount: suggested.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 16),
                          itemBuilder: (_, i) =>
                              GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ContactDetailScreen(
                                  contact: suggested[i],
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      Colors.grey.shade200,
                                  child: Text(
                                    suggested[i].initials,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  suggested[i]
                                      .name
                                      .split(' ')
                                      .first,
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
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

// -------------------------------------------------------

class _ContactRow extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const _ContactRow({required this.contact, this.onTap});

  Future<void> _invite() async {
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Join me on haPPy wallet! Easy, no-fee transfers '
            'between family and friends. Download the app and '
            "let's connect: https://happypay.app/invite",
        subject: 'Join me on haPPy Wallet',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Text(
                contact.initials,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
                    contact.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    contact.maskedPhone,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (!contact.hasAccount)
              OutlinedButton(
                onPressed: _invite,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side:
                      BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Invite",
                  style: TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OtherOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OtherOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
            const Spacer(),
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

