import 'package:flutter/material.dart';
import '../../../data/session.dart';
import 'link_bank_account_screen.dart';
import 'link_credit_card_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  Widget _sectionHeader(
    String title, {
    VoidCallback? onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (onAdd != null)
            GestureDetector(
              onTap: onAdd,
              child: const Text(
                "Add +",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Saved payment method row (card or bank)
  Widget _savedRow({
    required Widget leading,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey.shade200),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _addOption({
    required IconData icon,
    required String title,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.grey.shade200),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedCards =
        AppSession.currentUser?.savedCards ?? [];
    final savedBanks =
        AppSession.currentUser?.savedBankAccounts ?? [];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,

      child: Column(
        children: [

            // -----------------------------------------
            // TOP HANDLE
            // -----------------------------------------

            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 35,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // -----------------------------------------
            // CONTENT
            // -----------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  14,
                  20,
                  14,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Add money",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      "Choose payment method.",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // -------------------------------------
                    // CARDS
                    // -------------------------------------

                    _sectionHeader(
                      "Cards",
                      onAdd: savedCards.isNotEmpty
                          ? () async {
                              final result = await Navigator
                                  .push<Map<String, String>>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LinkCreditCardScreen(),
                                ),
                              );
                              if (result != null &&
                                  context.mounted) {
                                Navigator.pop(context, result);
                              }
                            }
                          : null,
                    ),

                    // Saved cards
                    ...savedCards.map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 6,
                        ),
                        child: _savedRow(
                          leading: Container(
                            width: 28,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.circular(3),
                            ),
                          ),
                          title: '${card.brand} Debit',
                          subtitle: '•••• ${card.last4}',
                          onTap: () => Navigator.pop(
                            context,
                            {
                              'type': 'card',
                              'brand': card.brand,
                              'last4': card.last4,
                            },
                          ),
                        ),
                      ),
                    ),

                    // Show "Link card" row only when no saved cards exist
                    if (savedCards.isEmpty)
                      _addOption(
                        icon: Icons.credit_card,
                        title: "Link credit or debit card",
                        onPressed: () async {
                          final result = await Navigator
                              .push<Map<String, String>>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LinkCreditCardScreen(),
                            ),
                          );
                          if (result != null &&
                              context.mounted) {
                            Navigator.pop(context, result);
                          }
                        },
                      ),

                    const SizedBox(height: 18),

                    // -------------------------------------
                    // BANKS
                    // -------------------------------------

                    _sectionHeader(
                      "Banks",
                      onAdd: savedBanks.isNotEmpty
                          ? () async {
                              final result = await Navigator
                                  .push<Map<String, String>>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LinkBankAccountScreen(),
                                ),
                              );
                              if (result != null &&
                                  context.mounted) {
                                Navigator.pop(context, result);
                              }
                            }
                          : null,
                    ),

                    // Saved bank accounts
                    ...savedBanks.map(
                      (bank) => Padding(
                        padding: const EdgeInsets.only(
                          bottom: 6,
                        ),
                        child: _savedRow(
                          leading: Icon(
                            Icons.account_balance,
                            size: 16,
                            color: Colors.grey.shade500,
                          ),
                          title: bank.bankName,
                          subtitle: 'IBAN •••• ${bank.last4}',
                          onTap: () => Navigator.pop(
                            context,
                            {
                              'type': 'bank',
                              'brand': bank.bankName,
                              'last4': bank.last4,
                              'iban': bank.iban,
                            },
                          ),
                        ),
                      ),
                    ),

                    // Show "Link bank account" row only when no saved banks exist
                    if (savedBanks.isEmpty)
                      _addOption(
                        icon: Icons.account_balance,
                        title: "Link bank account",
                        onPressed: () async {
                          final result = await Navigator
                              .push<Map<String, String>>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const LinkBankAccountScreen(),
                            ),
                          );
                          if (result != null &&
                              context.mounted) {
                            Navigator.pop(context, result);
                          }
                        },
                      ),

                    const SizedBox(height: 18),

                    // -------------------------------------
                    // OTHER
                    // -------------------------------------

                    _sectionHeader("Other"),

                    _addOption(
                      icon: Icons.payments_outlined,
                      title: "Top up from merchants",
                      onPressed: () {},
                    ),

                    const SizedBox(height: 8),

                    _addOption(
                      icon: Icons.qr_code,
                      title: "Request via QR code",
                      onPressed: () => Navigator.pop(
                        context,
                        {'type': 'qr_request'},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
