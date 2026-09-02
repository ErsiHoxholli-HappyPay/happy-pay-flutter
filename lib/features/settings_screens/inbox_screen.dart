import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/settings_screens/notification_details_modal.dart';

import 'package:happy_pay_flutter/widgets/back_button.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key, required this.notifications});
  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text(
          'Inbox',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              for (final item in notifications) ...[
                NotificationCard(
                  title: item.title,
                  subtitle: item.subtitle,
                  onTap: () {
                    NotificationDetailsModal.show(context, item);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<NotificationCard> createState() {
    return _NotificationCardState();
  }
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isOpened = false;

  @override
  void initState() {
    _isOpened = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => _isOpened = true);
        widget.onTap();
      },
      child: Container(
        margin: EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                _isOpened ? const SizedBox.shrink() : Icon(Icons.circle),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 134, 134, 134),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
