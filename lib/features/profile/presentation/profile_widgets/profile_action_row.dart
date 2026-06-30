// lib/features/profile/presentation/profile_widgets/profile_action_row.dart

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ProfileActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const ProfileActionRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: isDestructive
                    ? AppTextStyles.profileActionLabelDestructive
                    : AppTextStyles.profileActionLabel,
              ),
            ),
            Icon(
              AppIcons.forward,
              size: 14,
              color: isDestructive ? AppColors.error : AppColors.wsSubtext,
            ),
          ],
        ),
      ),
    );
  }
}