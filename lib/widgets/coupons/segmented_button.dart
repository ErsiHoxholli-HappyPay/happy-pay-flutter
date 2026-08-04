// segmented_promo_control.dart
import 'package:flutter/material.dart';

/// A single-row segmented control with a sliding highlight that
/// transitions between segments. Purely presentational — selection
/// state and tap actions are owned by the caller.
class SegmentedPromoControl extends StatelessWidget {
  const SegmentedPromoControl({
    super.key,
    required this.labels,
    required this.activeIndex,
    required this.onSegmentSelected,
  });

  final List<String> labels;
  final int activeIndex;
  final ValueChanged<int> onSegmentSelected;

  static const _height = 48.0;
  static const _duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / labels.length;
        return Container(
          height: _height,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: _duration,
                curve: Curves.easeInOut,
                left: segmentWidth * activeIndex,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: List.generate(labels.length, (i) {
                  final isActive = i == activeIndex;
                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => onSegmentSelected(i),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: AnimatedDefaultTextStyle(
                            duration: _duration,
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            child: Text(
                              labels[i],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
