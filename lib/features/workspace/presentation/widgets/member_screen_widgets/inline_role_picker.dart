// presentation/screens/member_screen_widgets/inline_role_picker.dart

import 'package:ajenda_app/features/roles/models/workspce_role.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class InlineRolePicker extends StatelessWidget {
  final WorkspaceRole selected;
  final ValueChanged<WorkspaceRole> onChanged;

  const InlineRolePicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _roles = [
    (WorkspaceRole.viewer, 'Viewer', Icons.visibility_outlined, AppColors.roleViewer),
    (WorkspaceRole.editor, 'Editor', Icons.edit_outlined, AppColors.gradientBlue),
    (WorkspaceRole.admin, 'Admin', Icons.admin_panel_settings_outlined, AppColors.accentGreen),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_roles.length, (i) {
        final (role, label, icon, color) = _roles[i];
        final isLast = i == _roles.length - 1;
        final isSelected = selected == role;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : AppValues.paddingXs),
            child: GestureDetector(
              onTap: () => onChanged(role),
              child: AnimatedContainer(
                duration: AppValues.animFast,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppValues.radiusSm),
                  border: Border.all(
                    color: isSelected ? color : AppColors.borderLight,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? color : AppColors.textMuted,
                      size: AppValues.iconSizeMd,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? color : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}