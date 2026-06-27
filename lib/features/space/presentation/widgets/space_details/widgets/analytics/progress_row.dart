// lib/features/workspace/presentation/widgets/space_details/widgets/analytics/progress_row.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';

class ProgressRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const ProgressRow({
    super.key,
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : value / total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
              style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500,
              ),
            ),
            Text('$value',
              style: GoogleFonts.poppins(
                fontSize: 11, fontWeight: FontWeight.w700, color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct, minHeight: 5,
            backgroundColor: color.withOpacity(0.1),
            color: color,
          ),
        ),
      ],
    );
  }
}