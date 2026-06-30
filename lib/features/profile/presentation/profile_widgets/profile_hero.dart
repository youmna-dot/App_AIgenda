// lib/features/profile/presentation/profile_widgets/profile_hero.dart

import 'package:flutter/material.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ProfileHero extends StatelessWidget {
  final dynamic profile;

  const ProfileHero({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final jobTitle = profile?.jobTitle;
    return Column(
      children: [
        Text(
          profile?.fullName ?? 'Your Name',
          style: AppTextStyles.profileName,
        ),
        if (jobTitle != null && jobTitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(jobTitle, style: AppTextStyles.profileJobTitle),
        ],
        const SizedBox(height: 4),
        Text(profile?.email ?? '', style: AppTextStyles.profileEmail),
      ],
    );
  }
}