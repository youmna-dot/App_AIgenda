import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class SettingsBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isPrimary;

  const SettingsBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingSm,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isPrimary
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(AppValues.pillRadius),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor ??
              (isPrimary ? AppColors.white : AppColors.primary),
        ),
      ),
    );
  }
}