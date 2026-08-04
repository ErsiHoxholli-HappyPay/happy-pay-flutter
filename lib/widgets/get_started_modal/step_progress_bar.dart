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
            child: _SegmentBar(fillCurrent: stepFills[i].clamp(0.0, 1.0)),
          ),
        );
      }),
    );
  }
}

class _SegmentBar extends StatefulWidget {
  const _SegmentBar({required this.fillCurrent});

  final double fillCurrent;

  @override
  State<_SegmentBar> createState() => _SegmentBarState();
}

class _SegmentBarState extends State<_SegmentBar> {
  double _previousFill = 0;

  @override
  void didUpdateWidget(_SegmentBar old) {
    super.didUpdateWidget(old);
    _previousFill = old.fillCurrent;
  }

  @override
  Widget build(BuildContext context) {
    final growing = widget.fillCurrent >= _previousFill;
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
          tween: Tween(begin: _previousFill, end: widget.fillCurrent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          builder: (context, value, _) => Align(
            alignment: growing ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
