import 'package:flutter/material.dart';
import '../../data/businesses.dart';
import '../../data/contacts.dart';
import '../../data/session.dart';
import '../../data/transactions.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/app_header.dart';
import '../../features/wallet/add_money/add_money_screen.dart';
import '../../data/insights_data.dart';
import '../../features/wallet/insights/insights_screen.dart';
import '../../features/wallet/all_transactions_screen.dart';
import '../../features/wallet/businesses_screen.dart';
import '../../features/wallet/new_payment/business_detail_screen.dart';
import '../../features/wallet/new_payment/new_payment_screen.dart';
import '../../features/wallet/new_payment/review_incoming_request_screen.dart';
import '../../features/wallet/contacts_screen.dart';
import '../../features/wallet/new_payment/contact_detail_screen.dart';
import '../../features/wallet/payment_methods/my_payment_methods_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppHeader(title: "Wallet", currentIndex: 1),
                        ),

                        const SizedBox(width: 12),

                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const InsightsScreen(),
                            ),
                          ),
                          child: _topButton(Icons.bar_chart),
                        ),

                        const SizedBox(width: 6),

                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyPaymentMethodsScreen(),
                            ),
                          ),
                          child: _topButton(Icons.credit_card),
                        ),

                        const SizedBox(width: 6),

                        _profileButton(),
                      ],
                    ),

                    const SizedBox(height: 35),

                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Wallet balance",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "L${AppSession.walletBalance.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Icon(Icons.visibility_outlined, size: 18),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            context,
                            Icons.add_circle,
                            "Add money",
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AddMoneyScreen(),
                                ),
                              );
                              if (mounted) setState(() {});
                            },
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: _actionButton(
                            context,
                            Icons.payment,
                            "New payment",
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NewPaymentScreen(),
                                ),
                              );
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ----------------------------------------
                    // PENDING REQUESTS
                    // ----------------------------------------

                    if (AppSession.pendingRequests.isNotEmpty) ...[
                      const Text(
                        "Pending requests",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...AppSession.pendingRequests.map(
                        (req) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ReviewIncomingRequestScreen(
                                request: req,
                              ),
                            ),
                          ).then((_) => setState(() {})),
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 8,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      Colors.grey.shade300,
                                  child: Text(
                                    req.contactName
                                        .split(' ')
                                        .map((p) => p[0])
                                        .take(2)
                                        .join(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        req.contactName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Tap to accept or decline",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "-L${req.amount}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ----------------------------------------

                    _sectionHeader(
                      "People",
                      actionLabel: "All contacts",
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ContactsScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: contacts
                            .where((c) => c.hasAccount)
                            .take(5)
                            .length,
                        itemBuilder: (_, index) {
                          final person = contacts
                              .where((c) => c.hasAccount)
                              .take(5)
                              .toList()[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ContactDetailScreen(
                                  contact: person,
                                ),
                              ),
                            ).then((_) {
                              if (mounted) setState(() {});
                            }),
                            child: Container(
                              width: 60,
                              margin: const EdgeInsets
                                  .only(right: 12),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Colors.grey.shade300,
                                    child: Text(
                                      person.initials,
                                      style:
                                          const TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    person.name
                                        .split(' ')
                                        .first,
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    _sectionHeader(
                      "Businesses",
                      actionLabel: "Manage",
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const BusinessesScreen(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: businesses
                            .take(4)
                            .length,
                        itemBuilder: (_, index) {
                          final biz = businesses
                              .take(4)
                              .toList()[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BusinessDetailScreen(
                                  business: biz,
                                ),
                              ),
                            ).then((_) {
                              if (mounted) setState(() {});
                            }),
                            child: Container(
                              width: 65,
                              margin: const EdgeInsets
                                  .only(right: 12),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Colors.grey.shade300,
                                    child: Text(
                                      biz.initials,
                                      style:
                                          const TextStyle(
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    biz.name
                                        .split(' ')
                                        .first,
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                    overflow:
                                        TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Transactions",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const AllTransactionsScreen(),
                            ),
                          ),
                          child: const Text(
                            "View all  ›",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ...transactions.take(3).map(
                      (tx) => _transaction(
                        tx.name,
                        tx.displayAmount,
                        tx.date,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Insights",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const InsightsScreen(),
                            ),
                          ),
                          child: const Text(
                            "Full insights  ›",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Builder(builder: (context) {
                            final months = mockInsightsData
                                .length >= 3
                                ? mockInsightsData.sublist(
                                    mockInsightsData.length - 3)
                                : mockInsightsData;
                            final maxVal = months.fold<double>(
                              1,
                              (m, d) => d.total > m ? d.total : m,
                            );
                            return Container(
                              height: 150,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Expenses in "
                                    "${months.last.monthLabel}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: months
                                          .expand(
                                            (m) => [
                                              _bar(
                                                m.monthLabel,
                                                (m.total / maxVal) * 70,
                                              ),
                                              const SizedBox(width: 18),
                                            ],
                                          )
                                          .toList()
                                          ..removeLast(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Builder(builder: (context) {
                            final cats = mockInsightsData
                                .last.categories
                                .take(3)
                                .toList();
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius:
                                    BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Top categories",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ...cats.map(
                                    (c) => _category(
                                      '${c.emoji} ${c.name}',
                                      'L${c.amount.toStringAsFixed(0)}',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(currentIndex: 1),
    );
  }

  Widget _topButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18),
    );
  }

  Widget _profileButton() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 18),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
            ),

            const SizedBox(width: 5),

            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    String title, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onAction,
          child: Text(
            actionLabel != null
                ? '$actionLabel  ›'
                : 'Manage  ›',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _transaction(String name, String amount, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(width: 22, height: 22, color: Colors.grey.shade400),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          Text(amount, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _bar(String label, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 8,
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
        ),

        const SizedBox(height: 5),

        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _category(String title, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 11))),

          Text(amount, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
