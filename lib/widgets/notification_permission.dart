import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Custom "priming" bottom sheet shown before the native OS permission
/// dialog. Its only job is persuasion — actual permission logic lives
/// in the caller via [showNotificationPermissionSheet].
class NotificationPermissionSheet extends StatelessWidget {
  const NotificationPermissionSheet({
    super.key,
    required this.onEnable,
    required this.onDismiss,
  });

  final VoidCallback onEnable;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Instant notifications',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'Get notified when something important happens, like your '
                'balance changes, upcoming loan payments or new offers.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onEnable,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Turn on Notifications',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: onDismiss,
                  child: const Text(
                    'Not Right Now',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Presents the priming sheet, then — only if the user opts in —
/// triggers the real native permission request. If permission was
/// already permanently denied in a prior session, routes straight
/// to the Settings-redirect sheet instead of re-priming.
Future<void> showNotificationPermissionSheet(BuildContext context) async {
  final status = await Permission.notification.status;
  if (status.isGranted) return;

  if (!context.mounted) return;

  if (status.isPermanentlyDenied) {
    await _showSettingsRedirectSheet(context);
    return;
  }

  await showModalBottomSheet(
    context: context,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => NotificationPermissionSheet(
      onEnable: () async {
        Navigator.of(sheetContext).pop();
        final result = await Permission.notification.request();

        if (result.isPermanentlyDenied && context.mounted) {
          await _showSettingsRedirectSheet(context);
        }
      },
      onDismiss: () => Navigator.of(sheetContext).pop(),
    ),
  );
}

Future<void> _showSettingsRedirectSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Notifications are off',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const Text(
                'You can turn them on anytime from your device settings.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Open Settings',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: const Text(
                    'Not Right Now',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
