// lib/features/profile/presentation/profile_widgets/profile_avatar_section.dart

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ProfileAvatarSection extends StatelessWidget {
  final dynamic profile;
  final bool isUploading;
  final VoidCallback? onTap;

  const ProfileAvatarSection({
    super.key,
    required this.profile,
    required this.isUploading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: isUploading
                    ? Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : profile?.profileImage != null &&
                            profile!.profileImage!.isNotEmpty
                        ? Image.network(
                            profile!.profileImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _InitialsBox(initials: profile?.initials ?? 'U'),
                          )
                        : _InitialsBox(initials: profile?.initials ?? 'U'),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.appPurpleGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appPurpleDark.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    AppIcons.camera,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text('Change Photo', style: AppTextStyles.profileChangePhotoTitle),
        const SizedBox(height: 4),
        Text(
          'Upload a new profile picture.',
          style: AppTextStyles.profileChangePhotoSubtitle,
        ),
      ],
    );
  }
}

class _InitialsBox extends StatelessWidget {
  final String initials;

  const _InitialsBox({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.profileName.copyWith(
            fontSize: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}