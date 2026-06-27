// lib/features/workspace/presentation/widgets/workspace_dash_widgets/space_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../space/data/models/space_model.dart';
import 'space_actions_sheet.dart';

class SpaceCard extends StatelessWidget {
  final SpaceModel space;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SpaceCard({
    super.key,
    required this.space,
    required this.color,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final completion = space.completionRate.clamp(0.0, 1.0);
    final pct = (completion * 100).toInt();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(AppValues.radiusXl),
          border: Border.all(
            color: color.withOpacity(0.20),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row ──────────────────────────────
            Row(
              children: [
                // Space icon
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      space.display,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name + tasks done/total
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        space.name,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${space.totalTasks} Tasks · ${space.completedTasks} Done',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // More button (edit / delete)
                if (onEdit != null || onDelete != null)
                  GestureDetector(
                    onTap: () => _showActions(context),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Completion progress ───────────────────
            Row(
              children: [
                Text(
                  'Completion',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  '$pct%',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: completion,
                backgroundColor: color.withOpacity(0.15),
                color: color,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SpaceActionsSheet(
        spaceName: space.name,
        color: color,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}