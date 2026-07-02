// lib/features/workspace/presentation/widgets/workspace_dash_widgets/dash_header.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_values.dart';

class DashHeader extends StatelessWidget {
  final String workspaceName;
  final int numberOfMembers;
  final VoidCallback onBack;
  final VoidCallback onMoreTap;

  const DashHeader({
    super.key,
    required this.workspaceName,
    required this.numberOfMembers,
    required this.onBack,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.horizontalPadding,
        16,
        AppValues.horizontalPadding,
        20,
      ),
      child: Row(
        children: [
          // ── Back button — نفس ستايل MemberHeader / PermissionHeader ──
          GestureDetector(
            onTap: onBack,
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

          // ── Workspace name (centered) ────────────
          Expanded(
            child: Text(
              workspaceName,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ── More (3 dots) — نفس ستايل الدائرة ────
          GestureDetector(
            onTap: onMoreTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}