import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/settings_screens/widgets/faq_tile.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:happy_pay_flutter/widgets/coupons/segmented_button.dart';

class FaqItem {
  const FaqItem(this.question, this.answer);
  final String question;
  final String answer;
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  static const _tabs = ['Loyalty', 'Wallet', 'Loans'];

  static const _faqs = <List<FaqItem>>[
    [
      FaqItem(
        'What is haPPy card?',
        'The haPPy card is your membership card that lets you collect points '
            'and enjoy rewards across our partner network.',
      ),
      FaqItem(
        'Why should you be a part of haPPy card membership?',
        'Membership unlocks exclusive offers, discounts, and loyalty points '
            'that you can redeem on future purchases.',
      ),
      FaqItem(
        'Can I have more than one card?',
        'Each member is entitled to a single haPPy card linked to their account.',
      ),
    ],
    [
      FaqItem(
        'What is the haPPy Wallet?',
        'The haPPy Wallet lets you store funds, send money, and pay bills '
            'directly from the app.',
      ),
      FaqItem(
        'How do I add money to my wallet?',
        'You can top up your wallet using a saved card or bank account from '
            'the Add Money screen.',
      ),
      FaqItem(
        'Is my wallet balance secure?',
        'Yes. Your balance is protected and every transaction requires your '
            'authentication.',
      ),
    ],
    [
      FaqItem(
        'What loan options are available?',
        'We offer flexible short-term loans tailored to your eligibility and '
            'transaction history.',
      ),
      FaqItem(
        'How do I qualify for a loan?',
        'Eligibility is based on your account activity and verification status.',
      ),
      FaqItem(
        'How do I repay a loan?',
        'Repayments can be made directly from your wallet balance on the due date.',
      ),
    ],
  ];

  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final items = _faqs[_activeIndex];
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text(
          'Frequently asked questions',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedPromoControl(
                labels: _tabs,
                activeIndex: _activeIndex,
                onSegmentSelected: (i) => setState(() => _activeIndex = i),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) => FaqTile(
                    question: items[i].question,
                    answer: items[i].answer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
