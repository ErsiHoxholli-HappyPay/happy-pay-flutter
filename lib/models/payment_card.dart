class PaymentCard {
  final String brand;
  final String last4;
  final String? expiry;
  final String? bankName;

  const PaymentCard({
    required this.brand,
    required this.last4,
    this.expiry,
    this.bankName,
  });
}
