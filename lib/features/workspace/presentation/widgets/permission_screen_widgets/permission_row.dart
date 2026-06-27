// presentation/screens/permission_screen_widgets/permission_row.dart

import 'package:ajenda_app/features/workspace/logic/permission_cubit/permission_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

// Action label + icon map 
typedef _ActionMeta = ({String label, IconData icon});

const Map<String, _ActionMeta> _actionMeta = {
  'add':    (label: 'Create', icon: Icons.add_circle_outline_rounded),
  'read':   (label: 'View',   icon: Icons.visibility_outlined),
  'update': (label: 'Edit',   icon: Icons.edit_outlined),
  'delete': (label: 'Delete', icon: Icons.delete_outline_rounded),
};

class PermissionRow extends StatelessWidget {
  final String permission;
  final bool isSelected;
  final bool canUserModify;

  const PermissionRow({
    super.key,
    required this.permission,
    required this.isSelected,
    required this.canUserModify,
  });

  String get _action => permission.split(':')[1];

  _ActionMeta get _meta =>
      _actionMeta[_action] ??
      (label: _action.toUpperCase(), icon: Icons.check_circle_outline_rounded);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canUserModify
          ? () => context.read<PermissionsCubit>().togglePermission(permission)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              _meta.icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _meta.label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.textDark : AppColors.textSecondary,
                ),
              ),
            ),
            _AnimatedCheckbox(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

// Animated Checkbox 
class _AnimatedCheckbox extends StatelessWidget {
  final bool isSelected;

  const _AnimatedCheckbox({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppValues.animFast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppValues.radiusXs),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.cardBorder,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
          : null,
    );
  }
}