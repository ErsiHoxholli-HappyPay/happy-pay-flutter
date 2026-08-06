import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:happy_pay_flutter/features/steps/step_history.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

// ---------------------------------------------------------------------------
// Palette — pull these into your theme/design tokens if you have one already.
// ---------------------------------------------------------------------------
class _Palette {
  static const background = Color(0xFFECEAE6);
  static const card = Color(0xFFF4F3F0);
  static const ink = Color(0xFF1A1A1A);
  static const subtext = Color(0xFF8C8C88);
  static const track = Color(0xFFDAD8D3);
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------
class DayStep {
  final String label;
  final int steps;
  final bool isToday;
  final bool isFuture;

  const DayStep({
    required this.label,
    required this.steps,
    this.isToday = false,
    this.isFuture = false,
  });
}

class StepsData {
  final String userName;
  final int monthlyGoal;
  final int monthlySteps;
  final String resetDateLabel;
  final int todaySteps;
  final int rewardPoints;
  final List<DayStep> week;

  const StepsData({
    required this.userName,
    required this.monthlyGoal,
    required this.monthlySteps,
    required this.resetDateLabel,
    required this.todaySteps,
    required this.rewardPoints,
    required this.week,
  });

  double get monthlyProgress =>
      monthlyGoal == 0 ? 0 : (monthlySteps / monthlyGoal).clamp(0, 1);

  static StepsData mock() => const StepsData(
    userName: 'Name',
    monthlyGoal: 50000,
    monthlySteps: 60000,
    resetDateLabel: '1.9.2026',
    todaySteps: 2000,
    rewardPoints: 100,
    week: [
      DayStep(label: 'MO', steps: 8200),
      DayStep(label: 'TU', steps: 7100),
      DayStep(label: 'WE', steps: 9400),
      DayStep(label: 'TH', steps: 3000),
      DayStep(label: 'FR', steps: 900, isToday: true),
      DayStep(label: 'SA', steps: 0, isFuture: true),
      DayStep(label: 'SU', steps: 0, isFuture: true),
    ],
  );
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class StepsScreen extends StatelessWidget {
  final StepsData data;

  StepsScreen({super.key, StepsData? data}) : data = data ?? StepsData.mock();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _Palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              _Header(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    if (data.monthlyProgress >= 1) ...[
                      _GoalReachedCard(data: data),
                      const SizedBox(height: 16),
                    ],
                    _MonthlyArcCard(data: data),
                    const SizedBox(height: 16),
                    _TodayCard(data: data),
                    const SizedBox(height: 16),
                    _WeekCard(data: data),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header: back button, title, history pill
// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        const Expanded(
          child: Text(
            'Steps',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _Palette.ink,
            ),
          ),
        ),
        _HistoryPill(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StepHistory()),
            );
          },
        ),
      ],
    );
  }
}

class _HistoryPill extends StatelessWidget {
  final VoidCallback onTap;

  const _HistoryPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(Icons.history_rounded, size: 16, color: Colors.black),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared: circular "check" badge with a small pill count, used by both
// the goal-reached card and the today card.
// ---------------------------------------------------------------------------
class _CheckBadge extends StatelessWidget {
  final String pillLabel;

  const _CheckBadge({required this.pillLabel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: _Palette.ink, size: 22),
          ),
          Positioned(
            top: -6,
            right: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _Palette.ink,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                pillLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "Good job Name!" card
// ---------------------------------------------------------------------------
class _GoalReachedCard extends StatelessWidget {
  final StepsData data;

  const _GoalReachedCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good job ${data.userName}!',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: _Palette.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "You've reached the goal of "
                  '${_formatSteps(data.monthlyGoal)} steps this month! '
                  'A reward of ${data.rewardPoints} points was added to '
                  'your haPpy card.',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: _Palette.subtext,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const _CheckBadge(pillLabel: '2K'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Monthly progress arc
// ---------------------------------------------------------------------------
class _MonthlyArcCard extends StatelessWidget {
  final StepsData data;

  const _MonthlyArcCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: _ArcGauge(
              progress: data.monthlyProgress,
              badgeLabel: _formatCompact(data.monthlyGoal),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Steps this month',
            style: TextStyle(fontSize: 13, color: _Palette.subtext),
          ),
          const SizedBox(height: 4),
          Text(
            _formatSteps(data.monthlySteps),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: _Palette.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Resets on ${data.resetDateLabel}',
            style: const TextStyle(fontSize: 12, color: _Palette.subtext),
          ),
        ],
      ),
    );
  }
}

/// Semicircular gauge, custom-painted. Draws a rounded-cap arc from the
/// left edge, over the top, to the right edge, proportional to [progress],
/// with a small pill badge floating at the arc's terminal point.
class _ArcGauge extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String badgeLabel;

  const _ArcGauge({required this.progress, required this.badgeLabel});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArcPainter(progress: progress),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final geometry = _ArcGeometry.of(constraints.biggest);
          final sweep = math.pi * progress;
          final endAngle = math.pi + sweep;
          final badgeCenter =
              geometry.center +
              Offset(
                geometry.radius * math.cos(endAngle),
                geometry.radius * math.sin(endAngle),
              );
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: badgeCenter.dx - 18,
                top: badgeCenter.dy - 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _Palette.ink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ArcGeometry {
  final Offset center;
  final double radius;

  const _ArcGeometry(this.center, this.radius);

  static _ArcGeometry of(Size size) {
    final radius = math.min(size.width / 2, size.height) - 8;
    final center = Offset(size.width / 2, size.height - 8);
    return _ArcGeometry(center, radius);
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;

  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final geometry = _ArcGeometry.of(size);
    final rect = Rect.fromCircle(
      center: geometry.center,
      radius: geometry.radius,
    );

    final trackPaint = Paint()
      ..color = _Palette.track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, trackPaint);

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = _Palette.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, math.pi, math.pi * progress, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// ---------------------------------------------------------------------------
// "You've walked 2,000 steps today!" card
// ---------------------------------------------------------------------------
class _TodayCard extends StatelessWidget {
  final StepsData data;

  const _TodayCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "You've walked",
                  style: TextStyle(fontSize: 13, color: _Palette.subtext),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatSteps(data.todaySteps),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _Palette.ink,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'steps today!',
                  style: TextStyle(fontSize: 13, color: _Palette.subtext),
                ),
              ],
            ),
          ),
          const _CheckBadge(pillLabel: '2K'),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// "This week" bar chart (fl_chart)
// ---------------------------------------------------------------------------
class _WeekCard extends StatelessWidget {
  final StepsData data;

  const _WeekCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxSteps = data.week
        .map((d) => d.steps)
        .fold<int>(0, (max, v) => v > max ? v : max);
    // Future/placeholder days render as a full-height light bar; guard
    // against an all-zero week so bars still have a visible max.
    final chartMax = maxSteps == 0 ? 1.0 : maxSteps.toDouble();

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This week',
            style: TextStyle(fontSize: 13, color: _Palette.subtext),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                maxY: chartMax,
                minY: 0,
                alignment: BarChartAlignment.spaceAround,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final day = data.week[value.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            day.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: day.isToday
                                  ? _Palette.ink
                                  : _Palette.subtext,
                              fontWeight: day.isToday
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < data.week.length; i++)
                    _buildGroup(i, data.week[i], chartMax),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildGroup(int index, DayStep day, double chartMax) {
    final isPlaceholder = day.isFuture;
    final height = isPlaceholder ? chartMax : day.steps.toDouble();
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: height,
          width: 14,
          borderRadius: BorderRadius.circular(7),
          color: isPlaceholder ? _Palette.track : _Palette.ink,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared card shell
// ---------------------------------------------------------------------------
class _CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _CardShell({
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: _Palette.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Formatting helpers
// ---------------------------------------------------------------------------
String _formatSteps(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i != 0 && (s.length - i) % 3 == 0) buffer.write(',');
    buffer.write(s[i]);
  }
  return buffer.toString();
}

String _formatCompact(int value) {
  if (value >= 1000) return '${(value / 1000).round()}K';
  return value.toString();
}
