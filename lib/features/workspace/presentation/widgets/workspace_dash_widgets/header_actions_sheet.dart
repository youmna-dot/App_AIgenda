// lib/features/workspace/presentation/widgets/workspace_dash_widgets/header_actions_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class HeaderActionsSheet extends StatelessWidget {
  final String workspaceName;
  final bool isOwner;
  final bool canManageMembers;
  final VoidCallback onManageMembers;
  final VoidCallback onDelete;
  final VoidCallback onLeave;

  const HeaderActionsSheet({
    super.key,
    required this.workspaceName,
    required this.isOwner,
    required this.canManageMembers,
    required this.onManageMembers,
    required this.onDelete,
    required this.onLeave,
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
          const SizedBox(height: 16),
          Text(
            workspaceName,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.primary.withOpacity(0.08)),
          const SizedBox(height: 8),

          // Manage Members
          if (canManageMembers)
            _SheetActionRow(
              icon: Icons.people_outline_rounded,
              iconColor: AppColors.success,
              label: 'Manage Members',
              sub: 'View and invite team members',
              onTap: () {
                Navigator.pop(context);
                onManageMembers();
              },
            ),

          // Delete (owner only)
          if (isOwner)
            _SheetActionRow(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              label: 'Delete Workspace',
              sub: 'Permanently remove this workspace',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),

          // Leave (member only)
          if (!isOwner)
            _SheetActionRow(
              icon: Icons.logout_rounded,
              iconColor: AppColors.warning,
              label: 'Leave Workspace',
              sub: 'You will lose access',
              onTap: () {
                Navigator.pop(context);
                onLeave();
              },
            ),
        ],
      ),
    );
  }
}

// ── Private action row ────────────────────────────────────────
class _SheetActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sub;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SheetActionRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sub,
    required this.onTap,
    this.isDestructive = false,
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
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 19),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDestructive
                          ? AppColors.error
                          : AppColors.textDark,
                    ),
                  ),
                  Text(
                    sub,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
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