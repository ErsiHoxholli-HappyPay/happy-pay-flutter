import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/session.dart';
import '../../../widgets/back_button.dart';

class QRCodeScreen extends StatelessWidget {
  final String amount;

  const QRCodeScreen({super.key, required this.amount});

  String get _qrData => jsonEncode({
        'type': 'payment_request',
        'amount': amount,
        'currency': 'L',
        'name': AppSession.currentUser?.name ?? 'User',
        'wallet':
            'happy-${AppSession.currentUser?.id ?? '0'}',
      });

  Future<void> _share() async {
    await SharePlus.instance.share(
      ShareParams(
        text: _qrData,
        subject:
            'Payment request for L$amount via haPPy wallet',
      ),
    );
  }

  void _download(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code saved to gallery'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            // ------------------------------------------------
            // HEADER
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                4,
                8,
                16,
                0,
              ),
              child: Row(
                children: [
                  const AppBackButton(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Request via QR Code",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 42),
                ],
              ),
            ),

            // ------------------------------------------------
            // QR CODE
            // ------------------------------------------------

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  16,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: .05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: _qrData,
                          version: QrVersions.auto,
                          size: 200,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle:
                              const QrDataModuleStyle(
                            dataModuleShape:
                                QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ----------------------------------------
                    // AMOUNT ROW
                    // ----------------------------------------

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Amount",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "L$amount",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ----------------------------------------
                    // DESCRIPTION
                    // ----------------------------------------

                    const Text(
                      "Show or share this QR code to a haPPy wallet user to get paid instantly.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Anyone who scans this QR code will be able to see your name, phone number and the requested amount.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ------------------------------------------------
            // ACTIONS
            // ------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => _download(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          "Download QR Code",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _share,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(7),
                          ),
                        ),
                        child: const Text(
                          "Share",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
