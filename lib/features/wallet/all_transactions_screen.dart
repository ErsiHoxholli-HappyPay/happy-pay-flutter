import 'package:flutter/material.dart';
import '../../data/transactions.dart';
import '../../widgets/back_button.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

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
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Transactions",
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

            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                itemCount: transactions.length,
                itemBuilder: (_, i) {
                  final tx = transactions[i];
                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    height: 54,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                          BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Colors.grey.shade300,
                          child: Text(
                            tx.name
                                .trim()
                                .split(' ')
                                .map((p) => p[0])
                                .take(2)
                                .join()
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                tx.name,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),
                              Text(
                                tx.date,
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
                          tx.displayAmount,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: tx.isCredit
                                ? Colors.green.shade700
                                : Colors.black,
                          ),
                        ),
                      ],
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
