import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/document_verification_success.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:camera/camera.dart' show XFile;

import 'document_camera_screen.dart';

class SubmitPhotoScreen extends StatefulWidget {
  const SubmitPhotoScreen({
    super.key,
    required this.documentTitle,
    required this.isFront,
  });

  final String documentTitle;
  final bool isFront;

  @override
  State<SubmitPhotoScreen> createState() => _SubmitPhotoScreenState();
}

class _SubmitPhotoScreenState extends State<SubmitPhotoScreen> {
  XFile? _capturedPhoto;

  Future<void> _takePhoto() async {
    final result = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DocumentCameraScreen(sideLabel: widget.isFront ? 'front' : 'back'),
      ),
    );
    if (result != null) setState(() => _capturedPhoto = result);
  }

  void _submit() {
    if (widget.isFront) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubmitPhotoScreen(
            documentTitle: widget.documentTitle,
            isFront: false,
          ),
        ),
      );
    } else {
      DocumentVerificationSuccess.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = _capturedPhoto;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('ID Verification', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photo == null)
              _FramingTitle(sideLabel: widget.isFront ? 'Front' : 'Back')
            else
              const _ReviewTitle(),
            const SizedBox(height: 24),
            _ImageBox(photo: photo),
            const Spacer(),
            if (photo == null)
              AppSubmitButton(label: 'Take a photo', onPressed: _takePhoto)
            else ...[
              AppSubmitButton(label: 'Submit', onPressed: _submit),
              const SizedBox(height: 12),
              _RetakeButton(onPressed: Navigator.of(context).pop),
            ],
          ],
        ),
      ),
    );
  }
}

class _FramingTitle extends StatelessWidget {
  const _FramingTitle({required this.sideLabel});

  final String sideLabel;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          const TextSpan(text: 'Place the '),
          TextSpan(
            text: '$sideLabel of the document',
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          const TextSpan(text: ' in the frame'),
        ],
      ),
    );
  }
}

class _ReviewTitle extends StatelessWidget {
  const _ReviewTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Make sure that your details are clear and readable',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }
}

class _ImageBox extends StatelessWidget {
  const _ImageBox({required this.photo});

  final XFile? photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: photo != null
          ? Image.file(File(photo!.path), fit: BoxFit.cover)
          : null,
    );
  }
}

class _RetakeButton extends StatelessWidget {
  const _RetakeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Retake photo', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
