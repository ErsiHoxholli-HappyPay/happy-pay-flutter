import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class MyQRScreen extends StatefulWidget {
  const MyQRScreen({super.key});

  @override
  State<MyQRScreen> createState() => _MyQRScreenState();
}

class _MyQRScreenState extends State<MyQRScreen> {
  bool copied = false;

  late final String paymentLink;

  @override
  void initState() {
    super.initState();

    paymentLink = jsonEncode({
      "id": "123456",
      "name": "Name Surname",
      "wallet": "happy-123456",
      "type": "payment",
    });
  }

  Future<void> copyLink() async {
    await Clipboard.setData(
      ClipboardData(text: paymentLink),
    );

    setState(() {
      copied = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        copied = false;
      });
    });
  }

  Future<void> shareLink() async {
        await SharePlus.instance.share(
      ShareParams(
        text: paymentLink,
        subject: "Pay me with haPPy",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 12),

                Center(
                  child: Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 55),

                const Text(
                  "Name Surname",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: QrImageView(
                    data: paymentLink,
                    version: QrVersions.auto,
                    size: 170,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Share your code to get paid",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),

                const Spacer(),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 44,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: copied
                        ? const Color(0xffF6F6F6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: copied
                        ? Border.all(
                            color: Colors.grey.shade300,
                          )
                        : null,
                  ),
                  child: copied
                      ? const Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Link copied!",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    20,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xffF3F3F3),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: copyLink,
                            child: const Text(
                              "Copy link",
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: shareLink,
                            child: const Text(
                              "Share link",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              top: 12,
              right: 12,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.grey.shade200,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}