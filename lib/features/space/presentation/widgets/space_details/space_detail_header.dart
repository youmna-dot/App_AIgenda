// lib/features/space/presentation/widgets/space_details/space_detail_header.dart
//
// REDESIGN — مطابق للصورة:
//  • Header: back + space name (center) + settings icon
//  • Stats row: 3 cards (Notes | Team | Done%)
//  • كل الأرقام real data من TaskState + NoteState
//  • لا يوجد stats ثابتة

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/core_widgets/custom_back_button.dart';

class SpaceDetailHeader extends StatelessWidget {
  final String spaceName;
  final String spaceDescription;
  final String spaceIcon;
  final Color color;

  // ✅ Real data — computed from TaskCubit + NoteCubit in screen
  final int completionPct;   // 0–100, computed: doneCount/taskCount*100
  final int taskCount;       // ✅ from TaskState
  final int doneCount;       // ✅ from TaskState
  final int overdueCount;    // ✅ from TaskState (tasks past dueDate)
  final int noteCount;       // ✅ from NoteState
  final int pinnedNoteCount; // ✅ from NoteState
  final int teamCount;       // ✅ from workspace.numberOfMembers (passed from parent)
  final String? nextDueLabel;
  final String? nextDueDaysLabel;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSettingsTap;

  const SpaceDetailHeader({
    super.key,
    required this.spaceName,
    required this.spaceDescription,
    required this.spaceIcon,
    required this.color,
    required this.completionPct,
    required this.taskCount,
    required this.doneCount,
    this.overdueCount = 0,
    required this.noteCount,
    this.pinnedNoteCount = 0,
    this.teamCount = 0,
    this.nextDueLabel,
    this.nextDueDaysLabel,
    this.onEdit,
    this.onDelete,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopRow(context),
          const SizedBox(height: 12),
          _buildStatsCards(),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── Top row: back + name + settings ───────────────────────
  Widget _buildTopRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppValues.horizontalPadding, 14,
          AppValues.horizontalPadding, 0),
      child: Row(
        children: [
          // Back button
          CustomBackButton(
            iconColor: AppColors.textDark,
            backgroundColor: Colors.transparent,
          ),
          // Space name — centered
          Expanded(
            child: Text(
              spaceName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Settings / more
          GestureDetector(
            onTap: onSettingsTap ?? () => _showActionsSheet(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.settings_outlined,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats cards row: Notes | Team | Done% ─────────────────
  // ✅ كل الأرقام real — noteCount, teamCount, completionPct
  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.horizontalPadding),
      child: Row(
        children: [
          // Notes card
          _StatCard(
            icon: Icons.sticky_note_2_outlined,
            label: 'NOTES',
            value: '$noteCount',
            color: color,
          ),
          const SizedBox(width: 10),
          // Team card
          _StatCard(
            icon: Icons.people_outline_rounded,
            label: 'TEAM',
            value: '$teamCount',
            color: color,
          ),
          const SizedBox(width: 10),
          // Done% card
          _StatCard(
            icon: Icons.bar_chart_rounded,
            label: 'DONE',
            value: '$completionPct%',
            color: color,
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  void _showActionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SpaceSettingsSheet(
        spaceName: spaceName,
        color: color,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isHighlighted;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          // Highlighted card بيكون أفتح من لون الـ space
          color: isHighlighted
              ? color.withOpacity(0.08)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppValues.radiusLg),
          border: Border.all(
            color: color.withOpacity(0.15),
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color.withOpacity(0.7)),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isHighlighted ? color : AppColors.textDark,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Settings / Actions Sheet ──────────────────────────────────
class _SpaceSettingsSheet extends StatelessWidget {
  final String spaceName;
  final Color color;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _SpaceSettingsSheet({
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
          const SizedBox(height: 16),
          Text(
            spaceName,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          if (onEdit != null)
            _SettingsAction(
              icon: Icons.edit_outlined,
              label: 'Edit Space',
              sub: 'Change name, icon or color',
              color: AppColors.gradientBlue,
              onTap: () {
                Navigator.pop(context);
                onEdit!();
              },
            ),
          if (onDelete != null)
            _SettingsAction(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Space',
              sub: 'This cannot be undone',
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

class _SettingsAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;

  const _SettingsAction({
    required this.icon,
    required this.label,
    required this.sub,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color)),
                  Text(sub,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted.withOpacity(0.4), size: 18),
          ],
        ),
      ),
    );
  }
}