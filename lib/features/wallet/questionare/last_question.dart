import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/questionare/questionare_screen.dart';
import 'package:happy_pay_flutter/features/wallet/terms_and_conditions/terms_and_conditions.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:happy_pay_flutter/widgets/get_started_modal/step_progress_bar.dart';

class LastQuestion extends StatelessWidget {
  const LastQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: FractionallySizedBox(
          widthFactor: 0.5,
          child: StepProgressBar(stepFills: [0.5]),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Do you have accounts with other financial institutions or payment apps? If yes, list them.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'Optional',
              style: TextStyle(
                color: Color.fromARGB(255, 78, 78, 72),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hint: Text('Click here to answer'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              stylusHandwritingEnabled: false,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight(300)),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LegalDocumentScreen(
                      title: 'Terms & Conditions',
                      assetPath:
                          'lib/assets/wallet_legal/terms_and_conditions.txt',
                      checkboxLabel:
                          'I acknowledge that I have received, read, and accepted the Happy Terms and conditions.',
                      nextScreen: LegalDocumentScreen(
                        title: 'Consent to data',
                        assetPath:
                            'lib/assets/wallet_legal/consent_to_data.txt',
                        checkboxLabel:
                            'I acknowledge that I have received, read, and accepted the Happy Terms and conditions.',
                        nextScreen: LegalDocumentScreen(
                          title: 'Other consents',
                          assetPath:
                              'lib/assets/wallet_legal/other_consents.txt',
                          checkboxLabel:
                              'I acknowledge that I have received, read, and accepted the Happy Terms and conditions.',
                          nextScreen: WalletScreen(),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Text('Continue', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
