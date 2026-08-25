import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentCameraScreen extends StatefulWidget {
  const DocumentCameraScreen({super.key, required this.sideLabel});

  final String sideLabel;

  @override
  State<DocumentCameraScreen> createState() => _DocumentCameraScreenState();
}

class _DocumentCameraScreenState extends State<DocumentCameraScreen> {
  CameraController? _controller;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Camera permission is required to scan your document.',
          ),
          action: status.isPermanentlyDenied
              ? SnackBarAction(label: 'Settings', onPressed: openAppSettings)
              : null,
        ),
      );
      Navigator.pop(context);
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras available');
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      // medium preset for emulator compatibility; high may fail on virtual cameras
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open camera. Please try again.'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }
    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      if (mounted) Navigator.pop(context, file);
    } catch (_) {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('ID Verification', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (controller != null && controller.value.isInitialized)
              CameraPreview(controller)
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            const CustomPaint(painter: _DocumentFramePainter()),

            Positioned(
              top: 48,
              left: 24,
              right: 24,
              child: Text(
                'Align the ${widget.sideLabel} of your document in the frame',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isCapturing ? null : _capture,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCapturing
                            ? Colors.white.withValues(alpha: 0.5)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentFramePainter extends CustomPainter {
  const _DocumentFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double frameW = size.width * 0.85;
    // ID card aspect ratio (85.6 × 54 mm)
    final double frameH = frameW / 1.586;
    final double left = (size.width - frameW) / 2;
    final double top = (size.height - frameH) / 2;
    final frameRect = Rect.fromLTWH(left, top, frameW, frameH);
    const radius = Radius.circular(8);

    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(RRect.fromRectAndRadius(frameRect, radius))
        ..fillType = PathFillType.evenOdd,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    const double bracketLen = 24.0;
    final bracketPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.square;

    for (final (cx, cy, dx, dy) in [
      (left, top, 1.0, 1.0),
      (left + frameW, top, -1.0, 1.0),
      (left, top + frameH, 1.0, -1.0),
      (left + frameW, top + frameH, -1.0, -1.0),
    ]) {
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + dx * bracketLen, cy),
        bracketPaint,
      );
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx, cy + dy * bracketLen),
        bracketPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
