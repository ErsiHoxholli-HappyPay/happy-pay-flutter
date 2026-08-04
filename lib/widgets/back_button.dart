import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Navigator.pop(context),
      child: SizedBox(
        width: 42,
        height: 42,
        child: const Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}