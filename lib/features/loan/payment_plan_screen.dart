import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class PaymentPlanScreen extends StatefulWidget {
  const PaymentPlanScreen({super.key});

  @override
  State<PaymentPlanScreen> createState() => _PaymentPlanScreenState();
}

class _PaymentPlanScreenState extends State<PaymentPlanScreen> {
  bool paid = false;

  final List<Map<String, String>> _upcoming = const [
    {"number": "2 of 4", "date": "Monday, February 02", "amount": "L 5.000"},
    {"number": "3 of 4", "date": "Thursday, March 02", "amount": "L 5.000"},
    {"number": "4 of 4", "date": "Thursday, April 02", "amount": "L 5.000"},
  ];

  final List<Map<String, String>> _paid = const [
    {"number": "1 of 4", "date": "Thursday, January 02", "amount": "L 5.000"},
  ];

  @override
  Widget build(BuildContext context) {
    final items = paid ? _paid : _upcoming;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const AppBackButton(),
        title: const Text('Payment plan', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _planToggle('Upcoming', !paid),
                    _planToggle('Paid', paid),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                          'Nothing here yet',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        itemCount: items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return _paymentItem(
                            item["number"]!,
                            item["date"]!,
                            item["amount"]!,
                            isFirst: index == 0,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _planToggle(String text, bool active) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            paid = text == 'Paid';
          });
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: active ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentItem(
    String number,
    String date,
    String amount, {
    bool isFirst = false,
  }) {
    final bool showPay = !paid && isFirst;

    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: paid ? Colors.black : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(4),
          ),
          child: paid
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : null,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: paid || showPay ? Colors.grey.shade300 : null,
          ),
          child: Row(
            children: [
              if (paid) const Icon(Icons.check_circle, size: 16),
              if (paid) const SizedBox(width: 6),
              Text(
                paid
                    ? 'Paid $amount'
                    : showPay
                    ? 'Pay $amount'
                    : amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
