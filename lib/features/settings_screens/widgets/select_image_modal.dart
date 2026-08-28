// select_image_modal.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:happy_pay_flutter/features/wallet/wallet_verification/widgets/submit_button.dart';

class SelectImageModal extends StatelessWidget {
  const SelectImageModal({super.key});

  static Future<File?> showModal(BuildContext context) {
    return showModalBottomSheet<File?>(
      useSafeArea: true,
      context: context,
      backgroundColor: Colors.white,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(12)),
      builder: (context) => const SelectImageModal(),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked == null) return;
    if (context.mounted) Navigator.pop(context, File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select a Photo'),
          const SizedBox(height: 20),
          AppSubmitButton(
            label: 'Take a photo',
            onPressed: () => _pickImage(context, ImageSource.camera),
          ),
          const SizedBox(height: 20),
          AppSubmitButton(
            label: 'Chose from library',
            onPressed: () => _pickImage(context, ImageSource.gallery),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                foregroundColor: WidgetStateColor.resolveWith(
                  (states) => Colors.black,
                ),
                backgroundColor: WidgetStateColor.resolveWith(
                  (states) => Colors.grey,
                ),
                shape: WidgetStateOutlinedBorder.resolveWith(
                  (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12),
                  ),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
