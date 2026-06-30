import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class SettingsSection extends StatelessWidget {
  final String label;
  final List<Widget> tiles;
  final Color? cardColor;

  const SettingsSection({
    super.key,
    required this.label,
    required this.tiles,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Label ──
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: AppValues.paddingXs,
          ),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
              letterSpacing: 1.0,
            ),
          ),
        ),

        // ── Card ──
        Container(
          decoration: BoxDecoration(
            color: cardColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(AppValues.radiusXl),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < tiles.length; i++) ...[
                tiles[i],
                if (i < tiles.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.primary.withOpacity(0.06),
                    indent: 56,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}