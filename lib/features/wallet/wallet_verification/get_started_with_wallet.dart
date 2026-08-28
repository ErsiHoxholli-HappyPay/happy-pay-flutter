import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/loyalty/home_screen.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/view_details.dart';

class GetStartedWithWallet extends StatefulWidget {
  const GetStartedWithWallet({super.key});

  @override
  State<GetStartedWithWallet> createState() => _GetStartedWithWalletState();
}

class _GetStartedWithWalletState extends State<GetStartedWithWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('')),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Get started with Wallet + Loans',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 40),
                IconButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => route.isFirst,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Short introduction to Wallet + Loans. Also talk about what users need to do before they can get approved.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 50),
            SubContainer(
              'Add money',
              'Add money from different resources',
              Icon(Icons.check_circle_rounded, size: 32),
            ),
            SizedBox(height: 20),
            SubContainer(
              'Send Money',
              'Send Money via Wallet/ Iban',
              Icon(Icons.check_circle_rounded, size: 32),
            ),
            SizedBox(height: 20),
            SubContainer(
              'Buy now, Pay later',
              'Example Text about loans',
              Icon(Icons.check_circle_rounded, size: 32),
            ),
            Spacer(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewDetails()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.black,
                  ),
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Text('Apply now'),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class SubContainer extends StatelessWidget {
  const SubContainer(this.title, this.subtitle, this.icons, {super.key});
  final String title;
  final String subtitle;
  final Icon icons;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icons,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title), Text(subtitle)],
        ),
      ],
    );
  }
}
