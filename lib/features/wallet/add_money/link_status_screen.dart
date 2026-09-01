import 'dart:async';

import 'package:flutter/material.dart';

class LinkStatusScreen extends StatefulWidget {
  final String linkingLabel;
  final String linkedLabel;
  final VoidCallback? onComplete;

  const LinkStatusScreen({
    super.key,
    this.linkingLabel = "Linking",
    this.linkedLabel = "Linked",
    this.onComplete,
  });

  @override
  State<LinkStatusScreen> createState() =>
      _LinkStatusScreenState();
}

class _LinkStatusScreenState extends State<LinkStatusScreen> {
  bool _isDone = false;

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        if (!mounted) return;
        setState(() => _isDone = true);

        Timer(
          const Duration(milliseconds: 1500),
          () {
            if (!mounted) return;
            widget.onComplete?.call();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: _isDone
                        ? Container(
                            key: const ValueKey('done'),
                            width: 42,
                            height: 42,
                            decoration:
                                const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        : const SizedBox(
                            key: ValueKey('loading'),
                            width: 42,
                            height: 42,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    child: Text(
                      _isDone
                          ? widget.linkedLabel
                          : widget.linkingLabel,
                      key: ValueKey(_isDone),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
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
