import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';

class PayNow extends StatelessWidget {
  const PayNow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment plan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PayCell(
              title: '2 of 4',
              subtitle: 'Monday, Feb 02',
              amount: 'L 5.000',
              icon: Icons.check_box_outline_blank,
              isFirst: true,
              isPaid: false,
            ),
            const SizedBox(height: 10),
            const PayCell(
              title: '3 of 4',
              subtitle: 'Tuesday, Mar 01',
              amount: 'L 5.000',
              icon: Icons.check_box_outline_blank,
              isFirst: false,
              isPaid: false,
            ),
            const SizedBox(height: 10),
            const PayCell(
              title: '4 of 4',
              subtitle: 'Thursday, Apr 03',
              amount: 'L 5.000',
              icon: Icons.check_box_outline_blank,
              isFirst: false,
              isPaid: false,
            ),
            const SizedBox(height: 10),
            const PayCell(
              title: '1 of 4',
              subtitle: 'Friday, Jan 01',
              amount: 'L 5.000',
              icon: Icons.check_box,
              isFirst: false,
              isPaid: true,
            ),

            const SizedBox(height: 30),
            AppSubmitButton(label: 'Pay in full', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class PayCell extends StatelessWidget {
  const PayCell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.isFirst,
    required this.isPaid,
  });

  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final bool isFirst;
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        children: [
          Icon(icon, size: 25),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          if (isPaid)
            TextButton(
              onPressed: () => {},
              style: ButtonStyle(
                shape: WidgetStateOutlinedBorder.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                ),
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => Colors.grey,
                ),
                foregroundColor: WidgetStateColor.resolveWith(
                  (states) => Colors.black,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle),
                  const SizedBox(width: 10),
                  Text('Paid $amount'),
                ],
              ),
            )
          else if (isFirst)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
              child: Text(amount),
            )
          else
            Text(amount),
        ],
      ),
    );
  }
}
