import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({super.key, required this.stepFills});

  final List<double> stepFills;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(stepFills.length, (i) {
        final isLast = i == stepFills.length - 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 6),
            child: _SegmentBar(fill: stepFills[i].clamp(0.0, 1.0)),
          ),
        );
      }),
    );
  }
}

class _SegmentBar extends StatelessWidget {
  const _SegmentBar({required this.fill});

  final double fill;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: fill),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, value, _) => FractionallySizedBox(
            widthFactor: value,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
