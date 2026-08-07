import 'package:flutter/material.dart';

@immutable
class PointsHistoryEntry {
  final String title;
  final DateTime date;
  final int points;

  final IconData? icon;

  const PointsHistoryEntry({
    required this.title,
    required this.date,
    required this.points,
    this.icon,
  });

  bool get isPositive => points >= 0;

  String get formattedDate =>
      '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';

  String get formattedPoints => '${isPositive ? '+' : ''}$points points';
}
