// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/sheets/ws_actions_sheet.dart
//
// FIX 10: isCurrentUserOwner: true كانت hardcoded في navigate لـ members
//          اتبدلت بـ isOwner اللي بييجي من الـ constructor

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../config/routes/route_names.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../../core/theme/app_icons.dart';
import '../../../../../workspace/data/models/workspace_model.dart';
import '../shared/ws_handle.dart';
import '../shared/ws_action_row.dart';

class WsActionsSheet extends StatelessWidget {
  final WorkspaceModel workspace;
  final Color color;
  final bool isOwner;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onLeaveTap;

  const WsActionsSheet({
    super.key,
    required this.workspace,
    required this.color,
    required this.isOwner,
    this.onEditTap,
    this.onDeleteTap,
    this.onLeaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = AppIcons.displayFromCode(workspace.iconCode);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppValues.paddingXl,
        AppValues.paddingMd,
        AppValues.paddingXl,
        36,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const WsHandle(),
          const SizedBox(height: 16),
          _buildWorkspaceInfo(emoji),
          const SizedBox(height: 16),
          Divider(height: 1, color: color.withOpacity(0.12)),
          const SizedBox(height: 8),
          if (isOwner) ..._ownerActions(context),
          if (!isOwner) ..._memberActions(context),
        ],
      ),
    );
  }

  Widget _buildWorkspaceInfo(String emoji) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workspace.name,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              if (workspace.description.isNotEmpty)
                Text(
                  workspace.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOwner
                ? color.withOpacity(0.12)
                : AppColors.primary.withOpacity(0.08),
            borderRadius:
            BorderRadius.circular(AppValues.paddingXs),
          ),
          child: Text(
            isOwner ? 'Owner' : 'Member',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isOwner ? color : AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _ownerActions(BuildContext context) => [
    WsActionRow(
      icon: Icons.edit_outlined,
      iconColor: AppColors.gradientBlue,
      iconBg: AppColors.gradientBlue.withOpacity(0.1),
      label: 'Edit Workspace',
      sub: 'Change name, icon or color',
      onTap: () {
        Navigator.of(context).pop();
        onEditTap?.call();
      },
    ),
    WsActionRow(
      icon: Icons.people_outline_rounded,
      iconColor: AppColors.success,
      iconBg: AppColors.success.withOpacity(0.1),
      label: 'Manage Members',
      sub: 'View and invite team',
      onTap: () {
        Navigator.of(context).pop();
        context.push(RouteNames.members, extra: {
          'workspaceId': workspace.id,
          'workspaceName': workspace.name,
          // [FIX] كانت true hardcoded — دلوقتي بنستخدم isOwner
          'isCurrentUserOwner': isOwner,
        });
      },
    ),
    WsActionRow(
      icon: Icons.delete_outline_rounded,
      iconColor: AppColors.error,
      iconBg: AppColors.error.withOpacity(0.1),
      label: 'Delete Workspace',
      sub: 'Cannot be undone',
      isDestructive: true,
      onTap: () {
        Navigator.of(context).pop();
        onDeleteTap?.call();
      },
    ),
  ];

  List<Widget> _memberActions(BuildContext context) => [
    WsActionRow(
      icon: Icons.people_outline_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primary.withOpacity(0.08),
      label: 'View Members',
      sub: "See who's in this workspace",
      onTap: () {
        Navigator.of(context).pop();
        context.push(RouteNames.members, extra: {
          'workspaceId': workspace.id,
          'workspaceName': workspace.name,
          // [FIX] member مش owner — false صح هنا
          'isCurrentUserOwner': false,
        });
      },
    ),
    WsActionRow(
      icon: Icons.logout_rounded,
      iconColor: AppColors.warning,
      iconBg: AppColors.warning.withOpacity(0.1),
      label: 'Leave Workspace',
      sub: 'You will lose access',
      onTap: () {
        Navigator.of(context).pop();
        onLeaveTap?.call();
      },
    ),
  ];
}