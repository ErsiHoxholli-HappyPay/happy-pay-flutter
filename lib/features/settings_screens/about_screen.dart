import 'package:flutter/material.dart';

import 'package:happy_pay_flutter/features/wallet/terms_and_conditions/tcd_holder_screen.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Map<Documents, bool> _accepted = {
    for (final doc in Documents.values) doc: false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text(
          'About us',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
              width: double.infinity,
              child: Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text('Version 1.0', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                for (int i = 0; i < Documents.values.length; i++)
                  ConsentTile(
                    document: Documents.values[i],
                    isFirst: i == 0,
                    isLast: i == Documents.values.length - 1,
                    value: _accepted[Documents.values[i]]!,
                    onChanged: (value) {
                      setState(() {
                        _accepted[Documents.values[i]] = value ?? false;
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
