import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class ProfileStatsCard extends StatelessWidget {
  final int workspacesCount;
  final int spacesCount;
  final int tasksCount;
  final int notesCount;

  const ProfileStatsCard({
    super.key,
    required this.workspacesCount,
    required this.spacesCount,
    required this.tasksCount,
    required this.notesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.roleViewer.withOpacity(0.10),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatItem(icon: Icons.folder_copy_outlined, count: workspacesCount, label: 'Workspaces'),
              const SizedBox(width: 13),
              _StatItem(icon: Icons.workspaces_outlined, count: spacesCount, label: 'Spaces'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _StatItem(icon: Icons.check_circle_outline_rounded, count: tasksCount, label: 'Tasks'),
              const SizedBox(width: 13),
              _StatItem(icon: Icons.description_outlined, count: notesCount, label: 'Notes'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;

  const _StatItem({required this.icon, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 25),
          ),
          const SizedBox(height: 10),
          Text('$count', style: AppTextStyles.profileStatCount),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.profileStatLabel),
        ],
      ),
    );
  }
}