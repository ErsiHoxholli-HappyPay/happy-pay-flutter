class AppTransaction {
  final String id;
  final String name;
  final String amount;
  final String date;
  final bool isCredit;

  const AppTransaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  String get displayAmount => isCredit ? '+$amount' : '-$amount';
}
