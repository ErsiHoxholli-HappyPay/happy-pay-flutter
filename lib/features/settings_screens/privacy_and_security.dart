import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/settings_screens/widgets/enable_setting_button.dart';
import 'package:happy_pay_flutter/models/users.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';

class PrivacyAndSecurity extends StatefulWidget {
  const PrivacyAndSecurity({
    super.key,
    required this.user,
    required this.hasWalletKyc,
  });

  final Users user;
  final bool hasWalletKyc;

  @override
  State<PrivacyAndSecurity> createState() => _PrivacyAndSecurityState();
}

class _PrivacyAndSecurityState extends State<PrivacyAndSecurity> {
  late bool _faceIdEnabled = widget.user.hasWalletKyc;
  late bool _fingerprintEnabled = widget.user.hasWalletKyc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: AppBackButton(),
        title: const Text('Privacy and Safety', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: IgnorePointer(
        ignoring: !widget.hasWalletKyc,
        child: Opacity(
          opacity: widget.hasWalletKyc ? 1.0 : 0.4,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Face ID',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enable Face ID for faster log in.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                EnableButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: 'Enable Face ID',
                  value: _faceIdEnabled,
                  onChanged: (value) {
                    setState(() => _faceIdEnabled = value);
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Fingerprint',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enable Fingerprint for faster log in.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                EnableButton(
                  icon: const Icon(Icons.fingerprint),
                  label: 'Enable Fingerprint',
                  value: _fingerprintEnabled,
                  onChanged: (value) {
                    setState(() => _fingerprintEnabled = value);
                  },
                ),
                const SizedBox(height: 30),
                const Text(
                  'Blocked Accounts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Manage your blocked accounts.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.block),
                      SizedBox(width: 10),
                      Text('Manage Blocked Accounts'),
                      Spacer(),
                      Icon(Icons.chevron_right),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Apple/Samsung Health',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Connect to Apple/Samsung Health to track your steps. Turning this off means we cannot reward you for reaching your monthly 50,000-step goal.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.favorite_border_outlined),
                      SizedBox(width: 10),
                      Text('Apple health'),
                      Spacer(),
                      Text('connected'),
                      Icon(Icons.chevron_right),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
