import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../data/models/profile_model.dart';

class ProfilePersonalInfoCard extends StatelessWidget {
  final ProfileModel? profile;

  const ProfilePersonalInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.roleViewer.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: AppIcons.person,
            label: 'FIRST NAME',
            value: _valueOrFallback(profile?.firstName),
            isFirst: true,
          ),
          _divider(),
          _InfoRow(
            icon: AppIcons.person,
            label: 'LAST NAME',
            value: _valueOrFallback(profile?.secondName),
          ),
          _divider(),
          _InfoRow(
            icon: AppIcons.work,
            label: 'JOB TITLE',
            value: _valueOrFallback(profile?.jobTitle, fallback: 'Not set yet'),
            isPlaceholder: profile?.jobTitle == null || profile!.jobTitle!.isEmpty,
          ),
          _divider(),
          _InfoRow(
            icon: AppIcons.calendar,
            label: 'DATE OF BIRTH',
            value: profile?.formattedBirthDate.isNotEmpty == true
                ? profile!.formattedBirthDate
                : 'Not set yet',
            isPlaceholder: profile?.formattedBirthDate.isEmpty ?? true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  String _valueOrFallback(String? value, {String fallback = 'Not set'}) =>
      value?.isNotEmpty == true ? value! : fallback;

  Widget _divider() => Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.6),
        indent: 56,
      );
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isPlaceholder;
  final bool isFirst;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isPlaceholder = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: isFirst ? 18 : 14,
        bottom: isLast ? 18 : 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.wsSubtext, size: 25),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.profileInfoLabel),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: isPlaceholder
                      ? AppTextStyles.profileInfoPlaceholder
                      : AppTextStyles.profileInfoValue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}