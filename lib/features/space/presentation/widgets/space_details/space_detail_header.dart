// lib/features/space/presentation/widgets/space_details/space_detail_header.dart
//
// REDESIGN — Space Overview header
//  • Top row: back button دائري + اسم الـ space (center) + settings دائري
//    (نفس ستايل DashHeader / _EditProfileAppBar: primary.withOpacity(0.14) دائرة)
//  • Stats row: 3 cards (Notes | Team | Done%) مع blobs زخرفية خلفهم
//  • كل الأرقام real data — جايه من TaskState + NoteState + workspace member count

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_values.dart';

class SpaceDetailHeader extends StatelessWidget {
  final String spaceName;
  final String spaceDescription;
  final String spaceIcon;
  final Color color;

  // ✅ Real data — computed from TaskCubit + NoteCubit in screen
  final int completionPct;   // 0–100, computed: doneCount/taskCount*100
  final int taskCount;
  final int doneCount;
  final int overdueCount;
  final int noteCount;
  final int pinnedNoteCount;
  final int teamCount;       // ✅ لازم تتبعت من الشاشة اللي فاتحة الـ space (workspace member count)
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
      color: AppColors.background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTopRow(context),
          const SizedBox(height: 18),
          _buildStatsCards(),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  // ── Top row: back دائري + name + more (3 dots) دائري ───────────
  Widget _buildTopRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppValues.horizontalPadding, 14,
          AppValues.horizontalPadding, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.back,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Text(
              spaceName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: onSettingsTap ?? () => _showActionsSheet(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                // 3 نقط أفقية — شكل مختلف عن more_vert_rounded المستخدمة في DashHeader
                Icons.more_horiz_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats cards row + decorative blobs ─────────────────────────
  Widget _buildStatsCards() {
    return SizedBox(
      height: 128,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // blobs زخرفية خلف الكروت — زي الصورة
          Positioned(
            top: -10,
            left: -28,
            child: _blob(size: AppValues.blobHeaderLg, color: AppColors.blobPurple),
          ),
          Positioned(
            top: 8,
            right: 36,
            child: _blob(size: AppValues.blobHeaderSm, color: AppColors.blobBlue),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.horizontalPadding),
            child: Row(
              children: [
                _StatCard(
                  icon: Icons.sticky_note_2_outlined,
                  label: 'NOTES',
                  value: '$noteCount',
                  color: color,
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.people_outline_rounded,
                  label: 'TEAM',
                  value: '$teamCount',
                  color: color,
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.bar_chart_rounded,
                  label: 'DONE',
                  value: '$completionPct%',
                  color: AppColors.gradientBlue,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blob({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.35),
        borderRadius: BorderRadius.circular(size * 0.4),
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.roleViewer.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppValues.radiusLg + 4),
          border: Border.all(color: color.withOpacity(0.14), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color.withOpacity(0.75)),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark.withOpacity(0.7),
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 25,
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