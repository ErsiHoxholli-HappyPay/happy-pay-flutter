// step_history.dart
//
// Monthly summary list (redesign — replaces the earlier day-by-day version,
// which doesn't match this mockup). Data is static mock for now.
//
// Note: "current month" is an explicit field on the model, not derived from
// DateTime.now() — comparing mock dates to the real clock would make the
// highlight silently stop working once the mock dates are in the past.

import 'package:flutter/material.dart';
import '../../widgets/back_button.dart';

// ---------------------------------------------------------------------------
// Palette — shared visual language with StepsScreen. Pull both into a
// single design-tokens source if/when one exists.
// ---------------------------------------------------------------------------
class _Palette {
  static const background = Color(0xFFECEAE6);
  static const card = Color(0xFFF4F3F0);
  static const ink = Color(0xFF1A1A1A);
  static const mutedBadge = Color(0xFFB9B7B2);
  static const subtext = Color(0xFF8C8C88);
  static const highlight = Color(0xFF2F80ED);
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------
class MonthlyStepSummary {
  final DateTime month; // first day of month
  final int steps;
  final int goal;
  final int points;
  final bool isCurrent;

  const MonthlyStepSummary({
    required this.month,
    required this.steps,
    required this.goal,
    required this.points,
    this.isCurrent = false,
  });

  bool get goalMet => steps >= goal;

  static List<MonthlyStepSummary> mock() => [
    MonthlyStepSummary(
      month: DateTime(2024, 12),
      steps: 50000,
      goal: 50000,
      points: 100,
      isCurrent: true,
    ),
    MonthlyStepSummary(
      month: DateTime(2024, 11),
      steps: 25000,
      goal: 50000,
      points: 0,
    ),
    MonthlyStepSummary(
      month: DateTime(2024, 10),
      steps: 50000,
      goal: 50000,
      points: 100,
    ),
    MonthlyStepSummary(
      month: DateTime(2024, 9),
      steps: 50000,
      goal: 50000,
      points: 100,
    ),
  ];
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class StepHistory extends StatelessWidget {
  final List<MonthlyStepSummary> months;

  StepHistory({super.key, List<MonthlyStepSummary>? months})
    : months = months ?? MonthlyStepSummary.mock();

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
              const _Header(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: months.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _MonthCard(summary: months[index]),
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
// Header: back button, centered title. No trailing action on this screen.
// ---------------------------------------------------------------------------
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppBackButton(),
        const Expanded(
          child: Text(
            'Steps history',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _Palette.ink,
            ),
          ),
        ),
        // Balances the leading back button so the title stays centered.
        const SizedBox(width: 44),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Month card
// ---------------------------------------------------------------------------
class _MonthCard extends StatelessWidget {
  final MonthlyStepSummary summary;

  const _MonthCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Palette.card,
        borderRadius: BorderRadius.circular(20),
        border: summary.isCurrent
            ? Border.all(color: _Palette.highlight, width: 2)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _monthLabel(summary.month),
                  style: const TextStyle(fontSize: 12, color: _Palette.subtext),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatSteps(summary.steps),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: _Palette.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  summary.points > 0
                      ? '+ ${summary.points} points'
                      : '0 points',
                  style: const TextStyle(fontSize: 12, color: _Palette.subtext),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _GoalBadge(
            goalMet: summary.goalMet,
            pillLabel: _formatCompact(summary.goal),
          ),
        ],
      ),
    );
  }

  static String _monthLabel(DateTime month) {
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${names[month.month - 1]} ${month.year}';
  }
}

/// Same check-circle-plus-pill shape as StepsScreen's badge, but muted gray
/// when the month's goal wasn't reached — per your call to keep the icon
/// language consistent rather than switching to a different shape/metaphor.
class _GoalBadge extends StatelessWidget {
  final bool goalMet;
  final String pillLabel;

  const _GoalBadge({required this.goalMet, required this.pillLabel});

  @override
  Widget build(BuildContext context) {
    final circleColor = goalMet ? _Palette.ink : _Palette.mutedBadge;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 22),
          ),
          Positioned(
            top: -6,
            right: -10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: circleColor,
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
