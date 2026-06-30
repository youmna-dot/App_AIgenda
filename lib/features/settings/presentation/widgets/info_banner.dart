// lib/features/settings/presentation/widgets/info_banner.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class InfoBanner extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? iconColor;

  const InfoBanner({
    super.key,
    required this.text,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMd,
        vertical: AppValues.paddingMd,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFDCEEFF),
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: iconColor ?? const Color(0xFF3B82F6),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: AppColors.wsHeading,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}