// lib/features/profile/presentation/profile_widgets/profile_top_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => context.push(RouteNames.settings),
            child: const Icon(
              AppIcons.settings,
              color: AppColors.wsSubtext,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}