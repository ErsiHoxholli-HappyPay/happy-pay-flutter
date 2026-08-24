import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/documents.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class VerificationInfo extends StatelessWidget {
  const VerificationInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('ID Verification', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Let’s get you verified',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'This way we can be sure that it’s you applying and not someone else.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Text(
              'Complete the following steps to verify your account in X minutes',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Icon(Icons.contact_page_outlined, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  'Provide us with government-issued ID',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  'Take a selfie',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              height: 50,
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GovDocuments()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.black,
                  ),
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.white,
                  ),
                  shape: WidgetStateOutlinedBorder.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: Text('Continue'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
