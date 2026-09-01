class BankAccount {
  final String bankName;
  final String iban;

  const BankAccount({
    required this.bankName,
    required this.iban,
  });

  String get last4 =>
      iban.length >= 4 ? iban.substring(iban.length - 4) : iban;
}
