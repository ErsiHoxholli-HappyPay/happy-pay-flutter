// lib/widgets/categories_section.dart

import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/data/insights_data.dart';
import 'package:happy_pay_flutter/features/wallet/insights/widgets/currency_format.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.categories,
    required this.onTap,
  });

  final List<InsightsCategory> categories;
  final VoidCallback onTap;

  static const _divider = Color(0xFFF0F0F0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Categories',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (categories.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: DefaultSelectionStyle.defaultColor,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'No spending this month',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
              ),
            )
          else
            for (int i = 0; i < categories.length; i++) ...[
              _CategoryRow(category: categories[i]),
              if (i != categories.length - 1)
                const Divider(height: 1, color: _divider),
            ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category});

  final InsightsCategory category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            formatLempira(category.amount),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
