// presentation/screens/member_screen_widgets/invite_fab.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';

class InviteFab extends StatelessWidget {
  final VoidCallback onTap;

  const InviteFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppValues.inviteFabHeight,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          gradient: AppColors.appPurpleGradient,
          borderRadius: BorderRadius.circular(AppValues.pillRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.appPurpleDark.withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.person_add_rounded,
                color: AppColors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Invite Member',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}