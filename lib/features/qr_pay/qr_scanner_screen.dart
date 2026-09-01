import 'dart:convert';

import 'package:flutter/material.dart';
import 'my_qr_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_payment_screen.dart';
import 'scanned_contact_screen.dart';

import '../../data/contacts.dart';
import '../../features/loyalty/home_screen.dart';
import '../../features/wallet/new_payment/send_amount_screen.dart';
import '../../features/wallet/wallet_screen.dart';
import '../../features/loan/loan_screen.dart';

class QRScannerScreen extends StatelessWidget {
  final int previousIndex;

  const QRScannerScreen({
    super.key,
    required this.previousIndex,
  });

  void _goBackToPreviousTab(BuildContext context) {
    Widget previousScreen;

    switch (previousIndex) {
      case 0:
        previousScreen = const HomeScreen();
        break;

      case 1:
        previousScreen = const WalletScreen();
        break;

      case 2:
        previousScreen = const LoanScreen();
        break;

      default:
        previousScreen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => previousScreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff7D7D7D),

      body: SafeArea(
        child: Stack(
          children: [

            // QR CAMERA
            MobileScanner(
              fit: BoxFit.cover,
              onDetect: (capture) {
                final barcode = capture.barcodes.firstOrNull;
                if (barcode?.rawValue == null) return;

                Map<String, dynamic>? data;
                try {
                  data = jsonDecode(barcode!.rawValue!) as Map<String, dynamic>;
                } catch (_) {}

                if (data != null && data['type'] == 'payment') {
                  // Personal QR — check if already a contact
                  final name = (data['name'] as String?) ?? 'Unknown';
                  final walletId = (data['wallet'] as String?) ?? '';
                  final known = contacts.any(
                    (c) => c.name.toLowerCase() == name.toLowerCase(),
                  );
                  if (known) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SendAmountScreen(
                          contactName: name,
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScannedContactScreen(
                          name: name,
                          walletId: walletId,
                        ),
                      ),
                    );
                  }
                } else {
                  // Merchant / unknown QR
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QrPaymentScreen(
                        merchantName: 'Neptun',
                        amount: 1000,
                        reference: '2025-3049-5432',
                        category: 'Shopping',
                      ),
                    ),
                  );
                }
              },
            ),

            // DARK OVERLAY
            Container(
              color: Colors.black.withValues(alpha: .35),
            ),

            // HEADER
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "QR Pay",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .95),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            // CLOSE BUTTON
            Positioned(
              top: 6,
              right: 10,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),

                onTap: () {
                  _goBackToPreviousTab(context);
                },

                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ),

            // SCANNER FRAME
            Center(
              child: SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  children: [

                    Positioned(
                      left: 0,
                      top: 0,
                      child: _corner(true, true),
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      child: _corner(false, true),
                    ),

                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: _corner(true, false),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: _corner(false, false),
                    ),

                  ],
                ),
              ),
            ),

            // BOTTOM PANEL
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Scan a haPPy QR Code to:",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Row(
                        children: [

                          Expanded(
                            child: _Option(
                              Icons.arrow_circle_up,
                              "Pay & send money",
                            ),
                          ),

                          Expanded(
                            child: _Option(
                              Icons.favorite,
                              "Request money",
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 10),

                      const Row(
                        children: [

                          Expanded(
                            child: _Option(
                              Icons.add_circle,
                              "Add Flex Payments",
                            ),
                          ),

                          Expanded(
                            child: _Option(
                              Icons.person_add,
                              "Add contacts",
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [

                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.black,
                                  foregroundColor:
                                      Colors.white,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MyQRScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "My QR Code",
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color:
                                  const Color(0xffF2F2F2),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.flash_on,
                              size: 20,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _corner(
    bool left,
    bool top,
  ) {
    return SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: CornerPainter(
          left: left,
          top: top,
        ),
      ),
    );
  }
}

// OPTION
class _Option extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Option(
    this.icon,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Icon(
          icon,
          size: 16,
        ),

        const SizedBox(width: 5),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),

      ],
    );
  }
}

// SCANNER CORNER PAINTER
class CornerPainter extends CustomPainter {
  final bool left;
  final bool top;

  CornerPainter({
    required this.left,
    required this.top,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (left && top) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(0, size.height);
    } else if (!left && top) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(
        size.width,
        size.height,
      );
    } else if (left && !top) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(
        size.width,
        size.height,
      );
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(
        size.width,
        size.height,
      );
      path.lineTo(
        0,
        size.height,
      );
    }

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    CustomPainter oldDelegate,
  ) {
    return false;
  }
}