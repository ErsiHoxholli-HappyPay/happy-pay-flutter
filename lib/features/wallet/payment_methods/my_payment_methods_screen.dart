import 'package:flutter/material.dart';
import '../../../data/session.dart';
import '../../../models/bank_account.dart';
import '../../../models/payment_card.dart';
import '../../../widgets/back_button.dart';
import '../add_money/link_bank_account_screen.dart';
import '../add_money/link_credit_card_screen.dart';
import 'bank_detail_screen.dart';
import 'card_detail_screen.dart';
import 'link_success_screen.dart';

class MyPaymentMethodsScreen extends StatefulWidget {
  const MyPaymentMethodsScreen({super.key});

  @override
  State<MyPaymentMethodsScreen> createState() =>
      _MyPaymentMethodsScreenState();
}

class _MyPaymentMethodsScreenState
    extends State<MyPaymentMethodsScreen> {

  @override
  void initState() {
    super.initState();
    // Seed session preferred from first saved method if not already set
    if (AppSession.preferredPaymentMethod == null) {
      final cards = AppSession.currentUser?.savedCards ?? [];
      final banks = AppSession.currentUser?.savedBankAccounts ?? [];
      if (cards.isNotEmpty) {
        final c = cards.first;
        AppSession.preferredPaymentMethod = {
          'type': 'card',
          'brand': c.brand,
          'last4': c.last4,
          'bankName': c.bankName ?? c.brand,
        };
      } else if (banks.isNotEmpty) {
        final b = banks.first;
        AppSession.preferredPaymentMethod = {
          'type': 'bank',
          'brand': b.bankName,
          'last4': b.last4,
        };
      }
    }
  }

  Future<void> _addCard() async {
    Map<String, String>? linkedData;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LinkCreditCardScreen(
          onLinked: (data) {
            linkedData = data;
            AppSession.currentUser?.savedCards.add(
              PaymentCard(
                brand: data['brand']!,
                last4: data['last4']!,
                bankName: data['bankName'],
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    if (linkedData != null && mounted) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        builder: (_) => LinkSuccessScreen(
          title: 'Card linked!',
          description:
              'Your card ending in ${linkedData!['last4']} '
              'was successfully linked to your haPPy wallet.',
        ),
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _addBank() async {
    Map<String, String>? linkedData;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LinkBankAccountScreen(
          onLinked: (data) {
            linkedData = data;
            AppSession.currentUser?.savedBankAccounts.add(
              BankAccount(
                bankName: data['brand']!,
                iban: data['iban'] ?? data['last4']!,
              ),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );

    if (linkedData != null && mounted) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        builder: (_) => LinkSuccessScreen(
          title: 'Account linked!',
          description:
              'Your ${linkedData!['brand']} account ending in '
              '${linkedData!['last4']} was successfully linked '
              'to your haPPy wallet.',
        ),
      );
    }
    if (mounted) setState(() {});
  }

  Future<void> _pickPreferred() async {
    final cards = AppSession.currentUser?.savedCards ?? [];
    final banks = AppSession.currentUser?.savedBankAccounts ?? [];
    if (cards.isEmpty && banks.isEmpty) return;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (_) => _PreferredPickerSheet(
        cards: cards,
        banks: banks,
        current: AppSession.preferredPaymentMethod,
        onSelected: (method) {
          setState(() {
            AppSession.preferredPaymentMethod = method;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards =
        AppSession.currentUser?.savedCards ?? [];
    final banks =
        AppSession.currentUser?.savedBankAccounts ?? [];
    final double tileWidth =
        MediaQuery.of(context).size.width * 0.44;
    const double tileHeight = 110;

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
                4,
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
                        "My payment methods",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Balance AppBackButton width
                  const SizedBox(width: 42),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    // ----------------------------------------
                    // CARDS
                    // ----------------------------------------

                    _sectionHeader(
                      "Cards",
                      onAdd: _addCard,
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: tileHeight,
                      child: cards.isEmpty
                          ? _emptySlot(
                              "No cards added",
                            )
                          : ListView.separated(
                              scrollDirection:
                                  Axis.horizontal,
                              itemCount: cards.length,
                              separatorBuilder:
                                  (_, _) =>
                                      const SizedBox(
                                width: 10,
                              ),
                              itemBuilder: (_, i) =>
                                  _CardTile(
                                card: cards[i],
                                width: tileWidth,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CardDetailScreen(
                                        card: cards[i],
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // ----------------------------------------
                    // BANK ACCOUNTS
                    // ----------------------------------------

                    _sectionHeader(
                      "Bank accounts",
                      onAdd: _addBank,
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: tileHeight,
                      child: banks.isEmpty
                          ? _emptySlot(
                              "No bank accounts added",
                            )
                          : ListView.separated(
                              scrollDirection:
                                  Axis.horizontal,
                              itemCount: banks.length,
                              separatorBuilder:
                                  (_, _) =>
                                      const SizedBox(
                                width: 10,
                              ),
                              itemBuilder: (_, i) =>
                                  _BankTile(
                                bank: banks[i],
                                width: tileWidth,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BankDetailScreen(
                                        bank: banks[i],
                                      ),
                                    ),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    // ----------------------------------------
                    // PREFERRED PAYMENT METHOD
                    // ----------------------------------------

                    const Text(
                      "Preferred payment method",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "We will use this payment method when adding money to your account.",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    if (AppSession.preferredPaymentMethod != null)
                      _preferredRow(
                        icon: AppSession.preferredPaymentMethod!['type'] == 'bank'
                            ? Icons.account_balance
                            : Icons.credit_card,
                        title: AppSession.preferredPaymentMethod!['type'] == 'bank'
                            ? AppSession.preferredPaymentMethod!['brand']!
                            : '${AppSession.preferredPaymentMethod!['brand']} Debit',
                        subtitle: AppSession.preferredPaymentMethod!['type'] == 'bank'
                            ? 'IBAN •••• ${AppSession.preferredPaymentMethod!['last4']}'
                            : '•••• ${AppSession.preferredPaymentMethod!['last4']}',
                        onTap: _pickPreferred,
                      )
                    else if (cards.isNotEmpty || banks.isNotEmpty)
                      _preferredRow(
                        icon: Icons.credit_card,
                        title: 'Select preferred method',
                        subtitle: 'Tap to choose',
                        onTap: _pickPreferred,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    String title, {
    VoidCallback? onAdd,
  }) {
    return Row(
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
    );
  }

  Widget _emptySlot(String label) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget _preferredRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border:
              Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
            Icon(
              Icons.chevron_right,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class _BankTile extends StatelessWidget {
  final BankAccount bank;
  final VoidCallback onTap;
  final double width;

  const _BankTile({
    required this.bank,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bank.bankName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.account_balance,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
            const Spacer(),
            Text(
              'IBAN •••• ${bank.last4}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferredPickerSheet extends StatelessWidget {
  final List<PaymentCard> cards;
  final List<BankAccount> banks;
  final Map<String, String>? current;
  final void Function(Map<String, String>) onSelected;

  const _PreferredPickerSheet({
    required this.cards,
    required this.banks,
    required this.current,
    required this.onSelected,
  });

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
            "Preferred payment method",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          ...cards.map((card) {
            final method = {
              'type': 'card',
              'brand': card.brand,
              'last4': card.last4,
              'bankName': card.bankName ?? card.brand,
            };
            final isSelected = current?['type'] == 'card' &&
                current?['last4'] == card.last4 &&
                current?['brand'] == card.brand;
            return _pickerRow(
              context,
              icon: Icons.credit_card,
              title: '${card.brand} Debit',
              subtitle: '•••• ${card.last4}',
              isSelected: isSelected,
              onTap: () => onSelected(method),
            );
          }),

          ...banks.map((bank) {
            final method = {
              'type': 'bank',
              'brand': bank.bankName,
              'last4': bank.last4,
            };
            final isSelected = current?['type'] == 'bank' &&
                current?['last4'] == bank.last4 &&
                current?['brand'] == bank.bankName;
            return _pickerRow(
              context,
              icon: Icons.account_balance,
              title: bank.bankName,
              subtitle: 'IBAN •••• ${bank.last4}',
              isSelected: isSelected,
              onTap: () => onSelected(method),
            );
          }),
        ],
      ),
    );
  }

  Widget _pickerRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Colors.black
                : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
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
            if (isSelected)
              const Icon(
                Icons.check,
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final PaymentCard card;
  final VoidCallback onTap;
  final double width;

  const _CardTile({
    required this.card,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.bankName ?? card.brand,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  card.brand,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              '•••• ${card.last4}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

