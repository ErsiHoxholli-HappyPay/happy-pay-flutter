import 'package:flutter/material.dart';

/// Standard drag handle used at the top of bottom sheets.
class BottomSheetHandle extends StatelessWidget {
  final double bottomMargin;

  const BottomSheetHandle({super.key, this.bottomMargin = 20});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 35,
        height: 3,
        margin: EdgeInsets.only(bottom: bottomMargin),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
