import 'dart:io';

import 'package:flutter/material.dart';
import 'package:happy_pay_flutter/features/wallet/id_verification/document_verification_success.dart';
import 'package:happy_pay_flutter/widgets/back_button.dart';
import 'package:image_picker/image_picker.dart';

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
    try {
      final XFile? photo = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (photo != null) setState(() => _capturedPhoto = photo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open camera. Please check permissions.'),
          ),
        );
      }
    }
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

  void _retake() {
    // Pop SubmitPhotoScreen(s) + IdDirectionsScreen to land back on GovDocuments
    int count = 0;
    final int popsNeeded = widget.isFront ? 2 : 3;
    Navigator.of(context).popUntil((_) => count++ >= popsNeeded);
  }

  String get _sideLabel => widget.isFront ? 'Front' : 'Back';

  @override
  Widget build(BuildContext context) {
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
            _capturedPhoto == null ? _buildFramingTitle() : _buildReviewTitle(),
            const SizedBox(height: 24),
            _buildImageBox(),
            const Spacer(),
            if (_capturedPhoto == null) _buildTakePhotoButton(),
            if (_capturedPhoto != null) ..._buildReviewButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFramingTitle() {
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
            text: '$_sideLabel of the document',
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          const TextSpan(text: ' in the frame'),
        ],
      ),
    );
  }

  Widget _buildReviewTitle() {
    return const Text(
      'Make sure that your details are clear and readable',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildImageBox() {
    return Container(
      height: 220,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: _capturedPhoto != null
          ? Image.file(File(_capturedPhoto!.path), fit: BoxFit.cover)
          : null,
    );
  }

  Widget _buildTakePhotoButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _takePhoto,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Take a photo', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  List<Widget> _buildReviewButtons() {
    return [
      SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Submit', style: TextStyle(fontSize: 16)),
        ),
      ),
      const SizedBox(height: 12),
      SizedBox(
        height: 50,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _retake,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Retake photo', style: TextStyle(fontSize: 16)),
        ),
      ),
    ];
  }
}
