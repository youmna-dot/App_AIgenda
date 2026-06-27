// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/ws_member.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../roles/models/workspce_role.dart';
import '../../../../roles/utils/role_permissions_mapper.dart';

class WsMemberEntry {
  final String email;
  final WorkspaceRole role;

  const WsMemberEntry({required this.email, required this.role});

  List<String> get permissions => RolePermissionsMapper.map(role);

  String get roleLabel {
    switch (role) {
      case WorkspaceRole.viewer: return 'Viewer';
      case WorkspaceRole.editor: return 'Editor';
      case WorkspaceRole.admin: return 'Admin';
      case WorkspaceRole.custom: return 'Custom';
    }
  }

  Color get roleColor {
    switch (role) {
      case WorkspaceRole.viewer: return AppColors.textSecondary;
      case WorkspaceRole.editor: return AppColors.gradientBlue;
      case WorkspaceRole.admin: return AppColors.success;
      case WorkspaceRole.custom: return AppColors.warning;
    }
  }
}

class WsMemberChip extends StatelessWidget {
  final WsMemberEntry member;
  final Color accentColor;
  final VoidCallback onRemove;

  const WsMemberChip({
    super.key,
    required this.member,
    required this.accentColor,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: accentColor,
            child: Text(
              member.email.isNotEmpty ? member.email[0].toUpperCase() : '?',
              style: GoogleFonts.poppins(
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            member.email,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: accentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: member.roleColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              member.roleLabel,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: member.roleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 12, color: accentColor),
          ),
        ],
      ),
    );
  }
}