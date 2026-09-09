import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class LoanInvoiceDetails extends StatelessWidget {
  const LoanInvoiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text(
          'Payment Plan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'lib/assets/neptun-logo.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Neptun',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            '11 October 2026, 11:45',
                            style: TextStyle(
                              color: Color.fromARGB(255, 112, 112, 123),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(thickness: 1),
                  SizedBox(height: 15),
                  Row(children: [Text('Number of items'), Spacer(), Text('2')]),
                  Divider(thickness: 1),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Text('Total purchase amount'),
                      Spacer(),
                      Text('24000'),
                    ],
                  ),
                  Divider(thickness: 1),
                  Row(children: [Text('Interest rate'), Spacer(), Text('2%')]),
                  Divider(thickness: 1),
                  Row(
                    children: [
                      Text('Total to pay off'),
                      Spacer(),
                      Text('30000'),
                    ],
                  ),
                  Divider(thickness: 1),
                  Row(
                    children: [
                      Text('Monthly installment'),
                      Spacer(),
                      Text('7,250'),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            AppSubmitButton(label: 'Continue', onPressed: () {}),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
