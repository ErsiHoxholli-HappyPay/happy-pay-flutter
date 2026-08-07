import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final int currentIndex;

  const AppHeader({
    super.key,
    required this.title,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          width: 70, // adjust this size if needed
          height: 3,
          child: Row(
            children: [
              _segment(0),
              const SizedBox(width: 2),
              _segment(1),
              const SizedBox(width: 2),
              _segment(2),
            ],
          ),
        ),
      ],
    );
  }


  Widget _segment(int index) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 3,
        decoration: BoxDecoration(
          color: currentIndex == index
              ? Colors.black
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}