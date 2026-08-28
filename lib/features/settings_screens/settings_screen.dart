import 'dart:io';
import 'package:flutter/material.dart';

import 'package:happy_pay_flutter/features/qr_pay/my_qr_screen.dart';
import 'package:happy_pay_flutter/features/settings_screens/privacy_and_security.dart';
import 'package:happy_pay_flutter/features/settings_screens/widgets/select_image_modal.dart';
import 'package:happy_pay_flutter/features/settings_screens/widgets/settings_buttons.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/models/users.dart';

import 'package:happy_pay_flutter/features/settings_screens/widgets/avatar_placeholder.dart';

import 'package:happy_pay_flutter/widgets/back_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.user});
  final Users user;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? _avatarImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('Settings', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),

          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 246, 246, 246),
                ),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 20),
                      ProfileAvatar(
                        fullName: widget.user.name ?? '',
                        imageFile: _avatarImage,
                        onEditTap: () async {
                          final file = await SelectImageModal.showModal(
                            context,
                          );
                          if (file != null) setState(() => _avatarImage = file);
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Hi, ${widget.user.name ?? ''}!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStateOutlinedBorder.resolveWith(
                                (states) => RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    12,
                                  ),
                                ),
                              ),
                              backgroundColor: WidgetStateColor.resolveWith(
                                (states) => Color.fromARGB(255, 234, 234, 234),
                              ),
                              foregroundColor: WidgetStateColor.resolveWith(
                                (states) => Colors.black,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MyQRScreen()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code),
                                SizedBox(width: 10),
                                Text(
                                  'My QR code',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SettingsButtons(
                      icon: Icon(Icons.translate),
                      label: 'Change Language',
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onTap: () {},
                    ),
                  ),
                  Expanded(
                    child: SettingsButtons(
                      icon: Icon(Icons.inbox),
                      label: 'Inbox',
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SettingsButtons(
                icon: Icon(Icons.person),
                label: 'Account Details',
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {},
              ),

              SettingsButtons(
                icon: Icon(Icons.smartphone),
                label: 'App Preferences',
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {},
              ),
              SettingsButtons(
                icon: Icon(Icons.lock),
                label: 'Privacy and Safety',
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrivacyAndSecurity(
                        hasWalletKyc: widget.user.hasWalletKyc,
                        user: Users(
                          id: widget.user.id,
                          phoneNumber: widget.user.phoneNumber,
                          hasWalletKyc: widget.user.hasWalletKyc,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SettingsButtons(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              SettingsButtons(
                icon: Icon(Icons.info),
                label: 'About',
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SettingsButtons(
                      showHelpBadge: true,
                      onTap: () {},
                      label: 'FAQ',
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: SettingsButtons(
                      icon: Icon(Icons.feedback),
                      label: 'Feedback',
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: AppSubmitButton(label: 'Sign Out', onPressed: () {}),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
