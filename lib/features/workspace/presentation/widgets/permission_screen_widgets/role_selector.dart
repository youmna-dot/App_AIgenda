// presentation/screens/permission_screen_widgets/role_selector.dart

import 'package:ajenda_app/features/roles/models/workspce_role.dart';
import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_cubit.dart';
import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

// Role card metadata — لون مخصص لكل role زي ألوان الجروبات في PermissionGroupCard
typedef _RoleMeta = ({String label, IconData icon, String subtitle, Color color});

const Map<WorkspaceRole, _RoleMeta> _roleMeta = {
  WorkspaceRole.viewer: (
    label: 'Viewer',
    icon: Icons.visibility_outlined,
    subtitle: 'Read only',
    color: AppColors.roleViewer,
  ),
  WorkspaceRole.editor: (
    label: 'Editor',
    icon: Icons.edit_outlined,
    subtitle: 'Can edit ',
    color: AppColors.gradientBlue,
  ),
  WorkspaceRole.admin: (
    label: 'Admin',
    icon: Icons.admin_panel_settings_outlined,
    subtitle: 'Full access',
    color: AppColors.accentGreen,
  ),
  WorkspaceRole.custom: (
    label: 'Custom',
    icon: Icons.tune_rounded,
    subtitle: 'Manual setup',
    color: AppColors.roleCustom,
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Apply a preset or customize below.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: WorkspaceRole.values.map((role) {
            final isLast = role == WorkspaceRole.values.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 10),
                child: _RoleCard(
                  role: role,
                  isSelected: state.role == role,
                  canUserModify: state.canUserModify,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── Role Card ─────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final WorkspaceRole role;
  final bool isSelected;
  final bool canUserModify;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.canUserModify,
  });

  _RoleMeta get _meta => _roleMeta[role]!;

  @override
  Widget build(BuildContext context) {
    final color = _meta.color;

    return GestureDetector(
      onTap: canUserModify
          ? () => context.read<PermissionsCubit>().changeRole(role)
          : null,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.10) : AppColors.white,
          borderRadius: BorderRadius.circular(AppValues.radiusMd),
          border: Border.all(
            color: isSelected ? color : AppColors.cardBorder,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                _meta.icon,
                color: isSelected ? AppColors.white : color,
                size: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _meta.label,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              _meta.subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}