// lib/widgets/app_text_field.dart

import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool required;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.required = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          style: const TextStyle(color: Color(0xFF1A1A1A)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2F80ED),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
          ),
          validator: required
              ? (value) => (value == null || value.trim().isEmpty)
                    ? 'This field is required'
                    : null
              : null,
        ),
      ],
    );
  }
}
