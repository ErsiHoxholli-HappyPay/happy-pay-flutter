import 'dart:io';

import 'package:camera/camera.dart' show XFile;
import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/questionare/aditional_information.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class SelfieReviewScreen extends StatelessWidget {
  const SelfieReviewScreen({super.key, required this.photo});

  final XFile photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Selfie', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Make sure your entire\nface is visible',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              height: 320,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.file(File(photo.path), fit: BoxFit.cover),
            ),
            const Spacer(),
            AppSubmitButton(
              label: 'Submit photo',
              // pop all verification screens after submitting selfie
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AditionalInformation()),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: Navigator.of(context).pop,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Retake photo',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
