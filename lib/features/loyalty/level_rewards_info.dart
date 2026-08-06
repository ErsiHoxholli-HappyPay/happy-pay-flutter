import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  static Future<void> show(BuildContext context) {
    final sheetHeight = MediaQuery.sizeOf(context).height * 1.0;
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        minHeight: sheetHeight,
        maxHeight: sheetHeight,
      ),
      builder: (_) => const Info(),
    );
  }

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int _selectedLevel = 2;

  static const _levelContent = {
    1: (
      body:
          'For 5,000 points you will receive 10 vouchers with a total value of  4,000 All and 5% discount in Neptun & 10% in My Optika to spend at  partners: Spar, Jumbo, Neptun, Fashion Group Albania, Max Optika, My  Optika, Foodini & Fashion Perfect.',
    ),
    2: (
      body:
          'For 10,000 points you will receive 8 vouchers with a total value of  11.500 All and 10% discount at My Optika, to spend at partners: Spar,  Jumbo, Neptun, Fashion Group Albania. Max Optika, My Optika, Foodini  & Fashion Perfect.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = _levelContent[_selectedLevel]!;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DragHandle(),
            Image.asset('lib/assets/image.png', width: 100, height: 100),
            const SizedBox(height: 8),
            Text(
              'Lots of points, lots of personalized benefits. '
              'One reward program.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'You’ll earn points with every purchase at our haPPy partners, which can be redeemed through the Offers menu for exciting rewards like 1+1 coupons, discounts, or monetary savings. Stay updated on participating companies and exclusive offers tailored for haPPy members, including new collections and special discounts. With the haPPy app, you can easily check your points, explore offers, manage coupons, browse partner retailers, update your personal details, and even use your haPPy card digitally—all in one place.',
              textAlign: TextAlign.left,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Level Rewards',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _segmentTab('Level 1', _selectedLevel == 1, 1),
                  ),
                  Expanded(
                    child: _segmentTab('Level 2', _selectedLevel == 2, 2),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Text(
              content.body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 96),
          ],
        ),
      ),
    );
  }

  Widget _segmentTab(String text, bool active, int level) {
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
