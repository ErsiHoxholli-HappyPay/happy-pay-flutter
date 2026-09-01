import 'package:happy_pay_flutter/models/questionare.dart';

final questionare = [
  Questionare('What is the primary purpose of your eWallet account?', [
    'Business use',
    'Personal use',
    'both',
  ]),
  Questionare(
    'Do you intend to use BNPL (Buy Now, Pay Later) services through this app?',
    ['Yes', 'No'],
  ),
  Questionare('What types of purchases do you plan to make using BNPL?', [
    'Electronics',
    'Clothing',
    'Travel',
    'Groceries',
    'Other',
  ]),
  Questionare('Do you have any existing debts or credit obligations?', [
    'Yes',
    'No',
  ]),
  Questionare(
    'Are you aware of the terms and repayment obligations associated with BNPL usage?',
    ['Yes', 'No'],
  ),
  Questionare(
    'What is the expected monthly transaction volume (in EUR or equivalent in local currency)?',
    ['< €200', '€200 - €500', '€500 - €1000', '€1000 - €2000', '> €2000'],
  ),
  Questionare('What is the source of your funds?', [
    'Salary',
    'Business Income',
    'Family Support',
    'Investments',
    'Other',
  ]),
  Questionare(
    'Will this account be used to send or receive funds on behalf of others?',
    ['Yes', 'No'],
  ),
  Questionare(
    'Are you or your immediate family a Politically Exposed Person (PEP)?',
    ['Yes', 'No'],
  ),
];
