import 'package:flutter/material.dart';

class _Palette {
  static const track = Color(0xFFE7E5E1);
  static const ink = Color(0xFF1A1A1A);
  static const subtext = Color(0xFF1A1A1A);
}

class BookletsCard extends StatelessWidget {
  final int pointsRemaining;
  final String currentLevelLabel;
  final String nextLevelLabel;
  final double progress; // 0.0 - 1.0, visual fill only
  final String buttonLabel;
  final VoidCallback? onButtonPressed;

  const BookletsCard({
    super.key,
    this.pointsRemaining = 3696,
    this.currentLevelLabel = 'Level 1',
    this.nextLevelLabel = 'Level 2',
    this.progress = 0.55,
    this.buttonLabel = 'Buy Booklets',
    this.onButtonPressed,
  }) : assert(progress >= 0 && progress <= 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _Headline(
          pointsRemaining: pointsRemaining,
          nextLevelLabel: nextLevelLabel,
        ),
        const SizedBox(height: 16),
        _LevelTrack(
          progress: progress,
          currentLevelLabel: currentLevelLabel,
          nextLevelLabel: nextLevelLabel,
        ),
        const SizedBox(height: 16),
        _BuyButton(label: buttonLabel, onPressed: onButtonPressed),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  final int pointsRemaining;
  final String nextLevelLabel;

  const _Headline({
    required this.pointsRemaining,
    required this.nextLevelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 15, color: _Palette.subtext),
        children: [
          const TextSpan(text: '🔥 Earn '),
          TextSpan(
            text: _formatPoints(pointsRemaining),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const TextSpan(text: ' more points for\n'),
          TextSpan(
            text: nextLevelLabel,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const TextSpan(text: ' rewards'),
        ],
      ),
    );
  }

  static String _formatPoints(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class _LevelTrack extends StatelessWidget {
  final double progress;
  final String currentLevelLabel;
  final String nextLevelLabel;

  const _LevelTrack({
    required this.progress,
    required this.currentLevelLabel,
    required this.nextLevelLabel,
  });

  @override
  Widget build(BuildContext context) {
    const pillDecoration = BoxDecoration(
      color: _Palette.ink,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    const pillStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    );

    // LayoutBuilder provides the actual finite width so the fill renders correctly.
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        return SizedBox(
          width: trackWidth,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // 16px track bar centred vertically within the 40px tall Stack
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                height: 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Row(
                    children: [
                      Container(
                        width: trackWidth * progress,
                        height: 16,
                        color: _Palette.ink,
                      ),
                      Expanded(child: ColoredBox(color: _Palette.track)),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: pillDecoration,
                  child: const Text('Level 1', style: pillStyle),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: pillDecoration,
                  child: const Text('Level 2', style: pillStyle),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BuyButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _BuyButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _Palette.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
