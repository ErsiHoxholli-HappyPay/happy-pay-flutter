import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/selfie_camera_screen.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class SelfieInfoScreen extends StatelessWidget {
  const SelfieInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('Selfie', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selfie',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 14),
            Text(
              'One last step! We’ll compare your picture to the document you provided.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colors.grey[700]),
                SizedBox(width: 16),
                Text(
                  'Make sure it’s completed by yourself.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.circle, size: 10, color: Colors.grey[700]),
                SizedBox(width: 16),
                Text(
                  'Make sure your face is well lit.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
            Spacer(),
            AppSubmitButton(
              label: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SelfieCameraScreen()),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
