// lib/screens/points_history_screen.dart
import 'package:flutter/material.dart';
import '../../models/points_history.dart';

class PointsHistoryScreen extends StatefulWidget {
  const PointsHistoryScreen({super.key});

  @override
  State<PointsHistoryScreen> createState() => _PointsHistoryScreenState();
}

class _PointsHistoryScreenState extends State<PointsHistoryScreen> {
  static final List<PointsHistoryEntry> _mockEntries = [
    PointsHistoryEntry(
      title: 'Max Optika',
      date: DateTime(2025, 1, 1),
      points: 3,
    ),
    PointsHistoryEntry(
      title: 'Voucher claimed',
      date: DateTime(2025, 1, 1),
      points: -70,
      icon: Icons.headset,
    ),
    PointsHistoryEntry(
      title: 'Max Optika',
      date: DateTime(2024, 12, 1),
      points: 3,
    ),
    PointsHistoryEntry(
      title: 'Max Optika',
      date: DateTime(2024, 12, 1),
      points: -3,
    ),
  ];

  static const _monthNames = [
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

  late final List<DateTime> _months = _distinctMonthsDescending(_mockEntries);

  /// null = "All" (no filter, default state).
  DateTime? _selectedMonth;

  List<DateTime> _distinctMonthsDescending(List<PointsHistoryEntry> entries) {
    final keys = <DateTime>{};
    for (final e in entries) {
      keys.add(DateTime(e.date.year, e.date.month));
    }
    final list = keys.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }

  String _monthLabel(DateTime month) =>
      '${_monthNames[month.month - 1]} ${month.year}';

  List<PointsHistoryEntry> _entriesFor(DateTime month) => _mockEntries
      .where((e) => e.date.year == month.year && e.date.month == month.month)
      .toList();

  @override
  Widget build(BuildContext context) {
    final monthsToShow = _selectedMonth == null ? _months : [_selectedMonth!];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        title: const Text(
          'Points history',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          _MonthTabBar(
            months: _months,
            selectedMonth: _selectedMonth,
            labelBuilder: _monthLabel,
            onSelected: (month) => setState(() => _selectedMonth = month),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final month in monthsToShow) ...[
                  Text(
                    _monthLabel(month),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._entriesFor(
                    month,
                  ).map((e) => _PointsHistoryTile(entry: e)),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthTabBar extends StatelessWidget {
  final List<DateTime> months;

  /// null = "All" chip is selected.
  final DateTime? selectedMonth;
  final String Function(DateTime) labelBuilder;
  final ValueChanged<DateTime?> onSelected;

  const _MonthTabBar({
    required this.months,
    required this.selectedMonth,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Index 0 is the "All" chip; the rest map to `months`.
    final itemCount = months.length + 1;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: itemCount,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final month = isAll ? null : months[index - 1];
          final selected = isAll
              ? selectedMonth == null
              : month == selectedMonth;

          return ChoiceChip(
            label: Text(isAll ? 'All' : labelBuilder(month!)),
            selected: selected,
            onSelected: (_) => onSelected(month),
            showCheckmark: false,
            backgroundColor: Colors.white,
            selectedColor: const Color(0xFFE0E0E0),
            side: BorderSide(color: Colors.grey.shade300),
            labelStyle: TextStyle(
              color: Colors.black,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
            shape: const StadiumBorder(),
          );
        },
      ),
    );
  }
}

class _PointsHistoryTile extends StatelessWidget {
  final PointsHistoryEntry entry;

  const _PointsHistoryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: entry.icon != null
                ? Icon(entry.icon, size: 20, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.formattedDate,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Text(
            entry.formattedPoints,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
