import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/loan/tc_loans_screen.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                          Row(
                            children: [
                              Text('Number of items'),
                              Spacer(),
                              Text('2'),
                            ],
                          ),
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
                          Row(
                            children: [
                              Text('Interest rate'),
                              Spacer(),
                              Text('2%'),
                            ],
                          ),
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
                    const SizedBox(height: 20),
                    Text(
                      'Payment schedule in 12 payments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          _ScheduleCell(
                            title: 'Down Payment',
                            subtitle: 'Due Today',
                            amount: 'L 1,000',
                          ),
                          const Divider(thickness: 1),

                          _ScheduleCell(
                            title: '1 of 4',
                            subtitle: 'Monday, Jan 02',
                            amount: 'L 7,500',
                          ),
                          const Divider(thickness: 1),
                          _ScheduleCell(
                            title: '2 of 4',
                            subtitle: 'Monday, Feb 03',
                            amount: 'L 7,500',
                          ),
                          const Divider(thickness: 1),
                          _ScheduleCell(
                            title: '3 of 4',
                            subtitle: 'Thursday, March 02',
                            amount: 'L 7,500',
                          ),
                          const Divider(thickness: 1),
                          _ScheduleCell(
                            title: '4 of 4',
                            subtitle: 'Friday, April 02',
                            amount: 'L 7,500',
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    AppSubmitButton(
                      label: 'Accept payment plan',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TermsLoanScreen()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(alignment: Alignment.center),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleCell extends StatelessWidget {
  const _ScheduleCell({
    required this.title,
    required this.subtitle,
    required this.amount,
  });
  final String title;
  final String subtitle;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.pie_chart, color: Colors.green),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title), Text(subtitle)],
        ),
        Spacer(),
        Text(amount),
      ],
    );
  }
}
