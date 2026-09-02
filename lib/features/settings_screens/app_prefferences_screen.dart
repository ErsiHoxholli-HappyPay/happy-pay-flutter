import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefferencesModal extends StatefulWidget {
  final String title;
  final String description;

  static const String prefsKey = 'app_preferences_launch_tab';

  const AppPrefferencesModal({
    super.key,
    required this.title,
    required this.description,
  });

  static Future<void> showPrefferencesModal(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (_) => AppPrefferencesModal(
        title: 'Launch Tab',
        description: 'Set your preferred launching point when opening the app.',
      ),
    );
  }

  @override
  State<AppPrefferencesModal> createState() {
    return _AppPrefferencesModalState();
  }
}

class _AppPrefferencesModalState extends State<AppPrefferencesModal> {
  String? _selected = 'loyalty';

  @override
  void initState() {
    super.initState();
    _loadSelected();
  }

  Future<void> _loadSelected() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(AppPrefferencesModal.prefsKey);
    if (saved != null) {
      setState(() => _selected = saved);
    }
  }

  Future<void> _saveSelected() async {
    final prefs = await SharedPreferences.getInstance();
    if (_selected != null) {
      await prefs.setString(AppPrefferencesModal.prefsKey, _selected!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.description, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.black,
                  ),
                  shape: WidgetStateOutlinedBorder.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selected = 'loyalty';
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.local_offer),
                    SizedBox(width: 10),
                    Text('Loyalty'),
                    Spacer(),
                    _selected == 'loyalty'
                        ? Icon(Icons.circle, size: 24)
                        : Icon(Icons.circle_outlined, size: 24),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.black,
                  ),
                  shape: WidgetStateOutlinedBorder.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selected = 'wallet';
                  });
                },

                child: Row(
                  children: [
                    Icon(Icons.wallet_outlined),
                    SizedBox(width: 10),
                    Text('Wallet'),
                    Spacer(),
                    _selected == 'wallet'
                        ? Icon(Icons.circle, size: 24)
                        : Icon(Icons.circle_outlined, size: 24),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.black,
                  ),
                  shape: WidgetStateOutlinedBorder.resolveWith(
                    (states) => RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _selected = 'loans';
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.pie_chart),
                    SizedBox(width: 10),
                    Text('Loans'),
                    Spacer(),
                    _selected == 'loans'
                        ? Icon(Icons.circle, size: 24)
                        : Icon(Icons.circle_outlined, size: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(padding: EdgeInsets.all(16), child: _buildEditButtons()),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveSelected();
                  // ignore: use_build_context_synchronously
                  if (context.mounted) Navigator.pop(context, _selected);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
