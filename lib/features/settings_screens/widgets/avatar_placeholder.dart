// lib/widgets/profile_avatar.dart

import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String fullName;
  final double size;
  final VoidCallback onEditTap;
  final File? imageFile;

  const ProfileAvatar({
    super.key,
    required this.fullName,
    required this.onEditTap,
    this.size = 100,
    this.imageFile,
  });

  String get _initials {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.32;

    return SizedBox(
      width: size,
      height: size + badgeSize / 2, // room for badge overhang
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFFF4F3F0),
              shape: BoxShape.circle,
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: imageFile == null
                ? Text(
                    _initials,
                    style: TextStyle(
                      fontSize: size * 0.32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipOval(
              child: Material(
                color: const Color(0xFF1A1A1A),
                child: InkWell(
                  onTap: onEditTap,
                  child: SizedBox(
                    width: badgeSize,
                    height: badgeSize,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: badgeSize * 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
