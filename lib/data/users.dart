import '../models/users.dart';
import '../models/payment_card.dart';
import '../models/bank_account.dart';

final users = [
  Users(
    id: '1',
    name: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '+355 612345678',
    gender: 'Male',
    birthDate: '1990-01-01',
    address: 'Main St, Tirana, Albania 1001',
    happyPoints: 6154,
    hasWalletKyc: true,
    savedCards: [
      PaymentCard(
        brand: 'Visa',
        last4: '1234',
        expiry: '05/27',
        bankName: 'Tirana Bank',
      ),
    ],
    savedBankAccounts: [
      BankAccount(
        bankName: 'Tirana Bank',
        iban: 'AL47212110090000000235698741',
      ),
    ],
  ),
  Users(
    id: '2',
    name: 'Jane Smith',
    email: 'jane@example.com',
    phoneNumber: '+355 612345679',
    gender: 'Female',
    birthDate: '1992-02-02',
    address: 'Main St, Tirana, Albania 1001',
    happyPoints: 3640,
    hasWalletKyc: false,
  ),
  Users(
    id: '3',
    name: 'Jack Smith',
    email: '',
    phoneNumber: '+355 612345670',
    gender: 'Female',
    birthDate: '1992-02-02',
    address: 'Main St, Tirana, Albania 1001',
    happyPoints: 3640,
    hasWalletKyc: false,
  ),
];
