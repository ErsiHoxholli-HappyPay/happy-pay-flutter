import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/insights_data.dart';
import 'package:happy_pay_flutter/features/wallet/insights/expenses_details_screen.dart';
import 'package:happy_pay_flutter/features/wallet/insights/widgets/category_section.dart';
import 'package:happy_pay_flutter/features/wallet/insights/widgets/insights_chart.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _selectedIndex = mockInsightsData.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('Insights', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            InsightsBarChart(
              months: mockInsightsData,
              selectedIndex: _selectedIndex,
              onMonthTap: (i) => setState(() => _selectedIndex = i),
            ),
            SizedBox(height: 30),
            CategoriesSection(
              categories: mockInsightsData[_selectedIndex].categories,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpensesDetailsScreen(
                    month: mockInsightsData[_selectedIndex],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
