import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final bool showCameraIcon;
  final VoidCallback? onCameraTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 80,
    this.showCameraIcon = false,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _AvatarCircle(imageUrl: imageUrl, initials: initials, size: size),
        if (showCameraIcon)
          Positioned(
            bottom: 0,
            right: 0,
            child: _CameraButton(size: size, onTap: onCameraTap),
          ),
      ],
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;

  const _AvatarCircle({
    required this.imageUrl,
    required this.initials,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        border: Border.all(color: AppColors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _InitialsView(initials: initials, size: size),
              )
            : _InitialsView(initials: initials, size: size),
      ),
    );
  }
}

class _InitialsView extends StatelessWidget {
  final String? initials;
  final double size;

  const _InitialsView({required this.initials, required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials ?? '?',
        style: GoogleFonts.outfit(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _CameraButton extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const _CameraButton({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final buttonSize = size * 0.32;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
        child: Icon(AppIcons.camera, color: AppColors.white, size: size * 0.16),
      ),
    );
  }
}