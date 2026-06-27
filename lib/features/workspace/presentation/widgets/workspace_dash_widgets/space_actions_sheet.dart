// lib/features/workspace/presentation/widgets/workspace_dash_widgets/space_actions_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class SpaceActionsSheet extends StatelessWidget {
  final String spaceName;
  final Color color;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SpaceActionsSheet({
    super.key,
    required this.spaceName,
    required this.color,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            spaceName,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          if (onEdit != null)
            _ActionRow(
              icon: Icons.edit_outlined,
              label: 'Edit Space',
              color: AppColors.gradientBlue,
              onTap: () {
                Navigator.pop(context);
                onEdit!();
              },
            ),
          if (onDelete != null)
            _ActionRow(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Space',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                onDelete!();
              },
            ),
        ],
      ),
    );
  }
}

// ── Private action row ────────────────────────────────────────
class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 19),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted.withOpacity(0.4),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}