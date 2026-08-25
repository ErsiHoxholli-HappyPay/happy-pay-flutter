import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/submit_photo_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class IdDirectionsScreen extends StatelessWidget {
  const IdDirectionsScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ID Verification',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Take pictures of both sides of your government-issued $title.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const _DirectionRow(
              icon: Icons.wb_sunny_outlined,
              text: 'Upload a complete image of your document.',
            ),
            const SizedBox(height: 16),
            const _DirectionRow(
              icon: Icons.crop_free,
              text: 'Make sure all details are readable.',
            ),
            const SizedBox(height: 16),
            const _DirectionRow(
              icon: Icons.block,
              text: 'Ensure the document is the original and not expired.',
            ),
            const SizedBox(height: 16),
            const _DirectionRow(
              icon: Icons.check_circle,
              text:
                  'Place documents against a solid-colored background (ex. a piece of white paper).',
            ),
            const Spacer(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SubmitPhotoScreen(documentTitle: title, isFront: true),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (_) => Colors.black,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DirectionRow extends StatelessWidget {
  const _DirectionRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
