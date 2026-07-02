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
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
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
          Divider(height: 1, color: AppColors.cardBorder),
          ...permissions.map(
            (permission) => PermissionRow(
              permission: permission,
              isSelected: selectedPermissions.contains(permission),
              canUserModify: canUserModify,
              accentColor: color,
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
          const SizedBox(width: 14),
          Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.paddingXs,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppValues.radiusXs),
            ),
            child: Text(
              '$selectedCount/$totalCount',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Group Icon Container — نفس نمط avatar بتاع MemberCard (gradient container 16 radius)
class _GroupIconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _GroupIconContainer({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppValues.memberAvatarSize,
      height: AppValues.memberAvatarSize,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: AppValues.iconSizeMd),
    );
  }
}