import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/loyalty/steps/step_main_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class Steps extends StatelessWidget {
  const Steps({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const Steps(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.90,
      child: Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DragHandle(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/image.png', width: 100, height: 100),
                  Text(
                    'Earn extra points just by walking!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Sync with Apple/Samsung Health and achieve a monthly goal of 50,000 steps to earn extra 100 points every month.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                height: 450,
                decoration: BoxDecoration(color: Colors.grey),
              ), // Placeholder for the steps content
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final permission = await Permission.activityRecognition
                      .request();
                  if (!context.mounted) return;
                  if (permission.isGranted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Health access granted')),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => StepsScreen()),
                    );
                  } else if (permission.isPermanentlyDenied) {
                    openAppSettings();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Permission denied')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Sync with Apple/Samsung Health',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
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
