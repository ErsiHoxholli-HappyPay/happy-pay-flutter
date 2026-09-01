import '../models/app_transaction.dart';

final transactions = <AppTransaction>[
  AppTransaction(
    id: 't1',
    name: 'Ceridian Berenica',
    amount: 'L50',
    date: '15/08/2024',
    isCredit: false,
  ),
  AppTransaction(
    id: 't2',
    name: 'Vince Bean',
    amount: 'L120',
    date: '12/08/2024',
    isCredit: true,
  ),
  AppTransaction(
    id: 't3',
    name: 'Ejla Dervishi',
    amount: 'L35',
    date: '10/08/2024',
    isCredit: false,
  ),
  AppTransaction(
    id: 't4',
    name: 'Vodafone Albania',
    amount: 'L1,200',
    date: '08/08/2024',
    isCredit: false,
  ),
  AppTransaction(
    id: 't5',
    name: 'Birra Tirana',
    amount: 'L45',
    date: '05/08/2024',
    isCredit: false,
  ),
  AppTransaction(
    id: 't6',
    name: 'TEG Shopping',
    amount: 'L280',
    date: '01/08/2024',
    isCredit: false,
  ),
];

void addTransaction(
  String name,
  String amount, {
  required bool isCredit,
}) {
  final now = DateTime.now();
  transactions.insert(
    0,
    AppTransaction(
      id: 'tx-${now.millisecondsSinceEpoch}',
      name: name,
      amount: amount,
      date: '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}',
      isCredit: isCredit,
    ),
  );
}
