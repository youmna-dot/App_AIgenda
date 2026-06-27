// presentation/screens/permission_screen_widgets/permission_group_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import 'permission_row.dart';

class PermissionGroupCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final List<String> permissions;
  final List<String> selectedPermissions;
  final bool canUserModify;

  const PermissionGroupCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.permissions,
    required this.selectedPermissions,
    required this.canUserModify,
  });

  int get _selectedCount =>
      permissions.where((p) => selectedPermissions.contains(p)).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _GroupHeader(
            name: name,
            icon: icon,
            color: color,
            selectedCount: _selectedCount,
            totalCount: permissions.length,
          ),
         
          const Divider(height: 1, color: Color(0xFFF5F3FF)),
          ...permissions.map(
            (permission) => PermissionRow(
              permission: permission,
              isSelected: selectedPermissions.contains(permission),
              canUserModify: canUserModify,
            ),
          ),
        ],
      ),
    );
  }
}

// Group Header 
class _GroupHeader extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int selectedCount;
  final int totalCount;

  const _GroupHeader({
    required this.name,
    required this.icon,
    required this.color,
    required this.selectedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppValues.paddingMd),
      child: Row(
        children: [
          _GroupIconContainer(icon: icon, color: color),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          Text(
            '$selectedCount/$totalCount',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// Group Icon Container 
class _GroupIconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _GroupIconContainer({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}