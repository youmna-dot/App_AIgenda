import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;
  final bool showLabel;

  const PriorityIndicator({
    super.key,
    required this.priority,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppColors.priorities[priority]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            theme.icon,
            size: 16,
            color: theme.color,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              theme.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
