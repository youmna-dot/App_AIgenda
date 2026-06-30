import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';

/// Row واحد داخل الـ ProfileMenuCard
/// بيعرض icon + title + subtitle اختياري + trailing widget
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? titleSuffix;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.titleSuffix,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            _IconBox(icon: icon, isDestructive: isDestructive),
            const SizedBox(width: 14),
            Expanded(child: _TitleColumn(title: title, titleSuffix: titleSuffix, subtitle: subtitle)),
            trailing ?? _DefaultTrailing(isDestructive: isDestructive),
          ],
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final bool isDestructive;

  const _IconBox({required this.icon, required this.isDestructive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDestructive
              ? [AppColors.error.withOpacity(0.15), AppColors.error.withOpacity(0.08)]
              : [AppColors.gradientBlue.withOpacity(0.15), AppColors.gradientPurple.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.primary,
        size: 20,
      ),
    );
  }
}

class _TitleColumn extends StatelessWidget {
  final String title;
  final String? titleSuffix;
  final String? subtitle;

  const _TitleColumn({required this.title, this.titleSuffix, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppTextStyles.profileActionLabel),
            if (titleSuffix != null)
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                child: Text(titleSuffix!, style: AppTextStyles.profileActionLabel),
              ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.bodySmall),
        ],
      ],
    );
  }
}

class _DefaultTrailing extends StatelessWidget {
  final bool isDestructive;

  const _DefaultTrailing({required this.isDestructive});

  @override
  Widget build(BuildContext context) {
    if (isDestructive) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(AppIcons.powerSettings, color: AppColors.error, size: 18),
      );
    }
    return Icon(AppIcons.forward, size: 14, color: AppColors.textMuted);
  }
}