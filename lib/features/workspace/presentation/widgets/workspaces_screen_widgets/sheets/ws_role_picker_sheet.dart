// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/sheets/ws_role_picker_sheet.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../roles/models/workspce_role.dart';
import '../shared/ws_handle.dart';

class WsRolePickerSheet extends StatelessWidget {
  final Color accent;
  const WsRolePickerSheet({super.key, required this.accent});

  static const _roles = [
    (WorkspaceRole.viewer, 'Viewer', Icons.visibility_outlined,
        'Read only — can view content', AppColors.primary),
    (WorkspaceRole.editor, 'Editor', Icons.edit_outlined,
        'Can create & edit content', AppColors.gradientBlue),
    (WorkspaceRole.admin, 'Admin', Icons.admin_panel_settings_outlined,
        'Full access, including delete', AppColors.success),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
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
          Text(
            'Select Member Role',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose the permission level for this member.',
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 20),
          ..._roles.map(
            (r) => GestureDetector(
              onTap: () => Navigator.pop(context, r.$1),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: r.$5.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppValues.radiusSm + 1),
                      ),
                      child: Icon(r.$3, color: r.$5, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.$2,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            r.$4,
                            style: GoogleFonts.poppins(
                              fontSize: 11.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted.withOpacity(0.5),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}