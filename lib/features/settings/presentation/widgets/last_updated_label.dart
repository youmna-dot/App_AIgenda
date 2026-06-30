// lib/features/settings/presentation/widgets/last_updated_label.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class LastUpdatedLabel extends StatelessWidget {
  final String date;

  const LastUpdatedLabel(this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingMd,
        vertical: AppValues.paddingSm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppValues.radiusSm),
      ),
      child: Text(
        'Last updated: $date',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.wsSubtext,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}