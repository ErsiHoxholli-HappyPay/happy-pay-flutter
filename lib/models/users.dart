import 'payment_card.dart';
import 'bank_account.dart';

class Users {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? lastName;
  final String? email;
  final String? gender;
  final String? birthDate;
  final String? address;
  final int? happyPoints;
  final bool hasWalletKyc;
  final List<PaymentCard> savedCards;
  final List<BankAccount> savedBankAccounts;

  Users({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.lastName,
    this.email,
    this.gender,
    this.birthDate,
    this.address,
    this.happyPoints,
    required this.hasWalletKyc,
    List<PaymentCard>? savedCards,
    List<BankAccount>? savedBankAccounts,
  })  : savedCards = savedCards ?? [],
        savedBankAccounts = savedBankAccounts ?? [];
}
