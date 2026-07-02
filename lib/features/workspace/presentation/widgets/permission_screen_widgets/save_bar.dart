// presentation/widgets/permission_screen_widgets/save_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

/// Pure widget — لا يعرف عن أي Cubit.
/// الـ PermissionsScreen هي اللي بتمرر القيم والـ callback.
class SaveBar extends StatelessWidget {
  final bool isLoading;
  final bool canModify;
  final VoidCallback? onSave;

  const SaveBar({
    super.key,
    required this.isLoading,
    required this.canModify,
    this.onSave,
  });

  bool get _isDisabled => isLoading || !canModify;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppValues.paddingLg,
        12,
        AppValues.paddingLg,
        AppValues.paddingMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.appPurpleDark.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: _isDisabled ? null : onSave,
        child: AnimatedContainer(
          duration: AppValues.animFast,
          height: AppValues.inviteFabHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: _isDisabled
                ? const LinearGradient(colors: [AppColors.grey, AppColors.grey])
                : AppColors.appPurpleGradient,
            borderRadius: BorderRadius.circular(AppValues.pillRadius),
            boxShadow: _isDisabled
                ? []
                : [
              BoxShadow(
                color: AppColors.appPurpleDark.withOpacity(0.30),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : Text(
              'Update Permissions',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}