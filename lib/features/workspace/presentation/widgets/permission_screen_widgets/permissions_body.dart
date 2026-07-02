// presentation/screens/permission_screen_widgets/permissions_body.dart

import 'package:ajenda_app/features/roles/models/workspce_role.dart';
import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_state.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_permissions.dart';
import '../../../../../core/constants/app_values.dart';
import 'permission_group_card.dart';
import 'role_selector.dart';
import 'viewer_info_banner.dart';

// Group configuration
typedef _GroupConfig = ({String name, IconData icon, Color color, List<String> permissions});

const List<_GroupConfig> _groups = [
  (
    name: 'Spaces',
    icon: Icons.folder_outlined,
    color: AppColors.gradientBlue,
    permissions: [], // populated at runtime via AppPermissions filter
  ),
  (
    name: 'Tasks',
    icon: Icons.task_alt_rounded,
    color: AppColors.accentGreen,
    permissions: [],
  ),
  (
    name: 'Notes',
    icon: Icons.note_outlined,
    color: AppColors.accentOrange,
    permissions: [],
  ),
];

class PermissionsBody extends StatelessWidget {
  final PermissionsLoaded state;

  const PermissionsBody({super.key, required this.state});

  List<_GroupConfig> get _resolvedGroups => [
        (
          name: 'Spaces',
          icon: Icons.folder_outlined,
          color: AppColors.gradientBlue,
          permissions: AppPermissions.adminPermissions
              .where((p) => p.startsWith('spaces'))
              .toList(),
        ),
        (
          name: 'Tasks',
          icon: Icons.task_alt_rounded,
          color: AppColors.accentGreen,
          permissions: AppPermissions.adminPermissions
              .where((p) => p.startsWith('tasks'))
              .toList(),
        ),
        (
          name: 'Notes',
          icon: Icons.note_outlined,
          color: AppColors.accentOrange,
          permissions: AppPermissions.adminPermissions
              .where((p) => p.startsWith('notes'))
              .toList(),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppValues.paddingLg,
        0,
        AppValues.paddingLg,
        AppValues.paddingLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoleSelector(state: state),
          const SizedBox(height: 20),
          if (state.role == WorkspaceRole.viewer) ...[
            const ViewerInfoBanner(),
            const SizedBox(height: 20),
          ],
          ..._resolvedGroups.map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PermissionGroupCard(
                name: group.name,
                icon: group.icon,
                color: group.color,
                permissions: group.permissions,
                selectedPermissions: state.selectedPermissions,
                canUserModify: state.canUserModify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}