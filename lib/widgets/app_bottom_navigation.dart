import 'package:flutter/material.dart';
import '../features/loyalty/home_screen.dart';
import '../features/wallet/wallet_screen.dart';
import '../features/loan/loan_screen.dart';
import '../features/qr_pay/qr_scanner_screen.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;

      case 1:
        screen = const WalletScreen();
        break;

      case 2:
        screen = const LoanScreen();
        break;

      case 3:
        screen = QRScannerScreen(previousIndex: currentIndex);
          break;

      default:
        screen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String title,
    int index,
  ) {
    final bool selected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _navigate(context, index),
        child: SizedBox(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: selected ? 26 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xffECECEC),
            ),
          ),
        ),
        child: Row(
          children: [
            _item(
              context,
              "Loyalty",
              0,
            ),
            _item(
              context,
              "Wallet",
              1,
            ),
            _item(
              context,
              "Loans",
              2,
            ),
            _item(
              context,
              "QR pay",
              3,
            ),
          ],
        ),
      ),
    );
  }
}