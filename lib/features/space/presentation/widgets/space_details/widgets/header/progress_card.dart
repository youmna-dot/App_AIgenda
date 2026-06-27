// lib/features/workspace/presentation/widgets/space_details/widgets/header/progress_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';

class ProgressCard extends StatelessWidget {
  final double completion;
  final Color color;

  const ProgressCard({
    super.key,
    required this.completion,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.05), Colors.white],
        ),
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppValues.paddingSm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppValues.radiusSm),
                      border: Border.all(color: color.withOpacity(0.15)),
                    ),
                    child: Icon(Icons.pie_chart_rounded, size: 18, color: color),
                  ),
                  Text(
                    '${(completion * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppValues.paddingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: completion,
                backgroundColor: color.withOpacity(0.12),
                color: color,
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Overall completion',
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}