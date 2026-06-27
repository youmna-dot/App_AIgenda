// lib/features/workspace/presentation/widgets/space_details/widgets/analytics/section_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppValues.iconSize - 4, color: AppColors.primary),
        const SizedBox(width: AppValues.paddingXs),
        Text(title,
          style: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}