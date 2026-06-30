// lib/features/settings/presentation/widgets/settings_app_bar.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_values.dart';

/// Shared app bar used across all Settings sub-screens.
///
/// Usage:
/// ```dart
/// SettingsAppBar(title: 'Change Password', onBack: () => context.pop())
/// ```
class SettingsAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const SettingsAppBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.paddingLg,
        vertical: AppValues.paddingSm,
      ),
      child: Row(
        children: [
          // ── Back button ──
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.back,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                size: 20,
              ),
            ),
          ),

          // ── Title ──
          Expanded(
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          // ── Spacer (balances the back button) ──
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}