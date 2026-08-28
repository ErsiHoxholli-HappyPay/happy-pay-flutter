import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/insights_data.dart';
import 'package:happy_pay_flutter/features/wallet/insights/widgets/currency_format.dart';

/// Dumb widget: renders the months and reports taps. Owns no state.
class InsightsBarChart extends StatelessWidget {
  const InsightsBarChart({
    super.key,
    required this.months,
    required this.selectedIndex,
    required this.onMonthTap,
  });

  final List<InsightsMonthData> months;
  final int selectedIndex;
  final ValueChanged<int> onMonthTap;

  static const _ink = Color(0xFF1A1A1A);
  static const _track = Color(0xFFD9D7D3);

  @override
  Widget build(BuildContext context) {
    final maxTotal = months.fold<double>(
      0,
      (max, m) => m.total > max ? m.total : max,
    );
    final maxY = maxTotal == 0 ? 10.0 : maxTotal * 1.2;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(174, 154, 154, 150)),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            months[selectedIndex].monthLabel,
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          Text(
            formatLempira(months[selectedIndex].total),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    if (!event.isInterestedForInteractions) return;
                    final index = response?.spot?.touchedBarGroupIndex;
                    if (index != null) onMonthTap(index);
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.transparent,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            months[i].monthLabel,
                            style: TextStyle(
                              fontSize: 11,
                              color: i == selectedIndex ? _ink : Colors.black54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(months.length, (i) {
                  final isSelected = i == selectedIndex;
                  final isZero = months[i].total == 0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: isZero ? maxY * 0.02 : months[i].total,
                        width: 10,
                        borderRadius: BorderRadius.circular(3),
                        color: isSelected ? _ink : _track,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
