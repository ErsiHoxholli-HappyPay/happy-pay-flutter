import 'package:flutter/material.dart';

class PhoneNumberScreen extends StatelessWidget {
  const PhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.chevron_left_outlined,
          size: 48,
          color: Colors.black,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [Text('Phone Number Screen'), SizedBox(height: 16)],
        ),
      ),
    );
  }
}
