// lib/features/workspace/presentation/widgets/space_details/widgets/analytics/priority_chip.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';

class PriorityChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final int total;

  const PriorityChip({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0 : ((count / total) * 100).toInt();
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppValues.paddingLg - 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(AppValues.radiusLg + 2),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppValues.radiusXs),
              ),
              child: Icon(Icons.flag_rounded, color: color, size: AppValues.iconSize - 5),
            ),
            const SizedBox(height: AppValues.paddingSm - 2),
            Text('$count',
              style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w800, color: color,
              ),
            ),
            Text(label,
              style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
            ),
            Text('$pct%',
              style: GoogleFonts.poppins(
                fontSize: 10, color: color.withOpacity(0.7), fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}