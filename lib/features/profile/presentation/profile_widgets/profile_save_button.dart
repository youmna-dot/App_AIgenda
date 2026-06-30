// lib/features/profile/presentation/profile_widgets/profile_save_button.dart

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';

class ProfileSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const ProfileSaveButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: isLoading
              ? LinearGradient(colors: [
                  AppColors.appPurpleLight.withOpacity(0.5),
                  AppColors.appPurpleDark.withOpacity(0.5),
                ])
              : AppColors.appPurpleGradient,
          borderRadius: BorderRadius.circular(AppValues.pillRadius),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.appPurpleDark.withOpacity(0.30),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text('Save Changes', style: AppTextStyles.profileSaveButton),
        ),
      ),
    );
  }
}