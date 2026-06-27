// presentation/screens/permission_screen_widgets/role_selector.dart

import 'package:ajenda_app/features/roles/models/workspce_role.dart';
import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_cubit.dart';
import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

// Role chip metadata
typedef _RoleMeta = ({String label, IconData icon, String subtitle});

const Map<WorkspaceRole, _RoleMeta> _roleMeta = {
  WorkspaceRole.viewer: (
    label: 'Viewer',
    icon: Icons.visibility_outlined,
    subtitle: 'Read only',
  ),
  WorkspaceRole.editor: (
    label: 'Editor',
    icon: Icons.edit_outlined,
    subtitle: 'Can edit content',
  ),
  WorkspaceRole.admin: (
    label: 'Admin',
    icon: Icons.admin_panel_settings_outlined,
    subtitle: 'Full access',
  ),
  WorkspaceRole.custom: (
    label: 'Custom',
    icon: Icons.tune_rounded,
    subtitle: 'Manual setup',
  ),
};

class RoleSelector extends StatelessWidget {
  final PermissionsLoaded state;

  const RoleSelector({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Role',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: WorkspaceRole.values.map((role) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _RoleChip(
                  role: role,
                  isSelected: state.role == role,
                  canUserModify: state.canUserModify,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// Role Chip 
class _RoleChip extends StatelessWidget {
  final WorkspaceRole role;
  final bool isSelected;
  final bool canUserModify;

  const _RoleChip({
    required this.role,
    required this.isSelected,
    required this.canUserModify,
  });

  _RoleMeta get _meta => _roleMeta[role]!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canUserModify
          ? () => context.read<PermissionsCubit>().changeRole(role)
          : null,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppValues.radiusSm),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _meta.icon,
              color: isSelected ? AppColors.white : AppColors.textMuted,
              size: 16,
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _meta.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.textDark,
                  ),
                ),
                Text(
                  _meta.subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isSelected ? Colors.white70 : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}