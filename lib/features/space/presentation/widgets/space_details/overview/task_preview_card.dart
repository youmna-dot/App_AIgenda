// lib/features/space/presentation/widgets/space_details/overview/task_preview_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../task/data/models/task_model.dart';
import '../../../../../task/enums/task_priority.dart';
import '../../../../../task/enums/task_status.dart';

class TaskPreviewCard extends StatelessWidget {
  final TaskModel task;
  final int index; // بتستخدم عشان تلوّن الكارد بالتبادل (lavender/blue)
  final Color accentColor;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;

  const TaskPreviewCard({
    super.key,
    required this.task,
    required this.index,
    required this.accentColor,
    this.onToggle,
    this.onTap,
  });

  static const List<Color> _pastels = [
    AppColors.pastelLavender,
    AppColors.pastelBlue,
  ];

  bool get _isDone => task.status == TaskStatus.done;

  Color get _badgeBg {
    switch (task.priority) {
      case TaskPriority.high:
      case TaskPriority.critical:
        return AppColors.priorityHighBg;
      case TaskPriority.medium:
        return AppColors.priorityMedBg;
      default:
        return AppColors.priorityLowBg;
    }
  }

  Color get _badgeText {
    switch (task.priority) {
      case TaskPriority.high:
      case TaskPriority.critical:
        return AppColors.priorityHighText;
      case TaskPriority.medium:
        return AppColors.priorityMedText;
      default:
        return AppColors.priorityLowText;
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case TaskPriority.high:
      case TaskPriority.critical:
        return 'HIGH';
      case TaskPriority.medium:
        return 'MED';
      default:
        return 'LOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColor =
        _isDone ? AppColors.pastelPeach : _pastels[index % _pastels.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
        padding: const EdgeInsets.all(AppValues.paddingMd),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientColor, AppColors.white],
          ),
          borderRadius: BorderRadius.circular(AppValues.radiusLg + 4),
          border: Border.all(color: accentColor.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isDone ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: _isDone
                        ? accentColor
                        : AppColors.textMuted.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: _isDone
                    ? const Icon(Icons.check_rounded,
                        size: 15, color: AppColors.white)
                    : null,
              ),
            ),
            const SizedBox(width: AppValues.paddingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _isDone
                                ? AppColors.textMuted
                                : AppColors.textDark,
                            decoration: _isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: AppColors.textMuted,
                          ),
                        ),
                      ),
                      if (!_isDone) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _badgeBg,
                            borderRadius:
                                BorderRadius.circular(AppValues.pillRadius),
                          ),
                          child: Text(
                            _priorityLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: _badgeText,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if ((task.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      task.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        color: AppColors.textSecondary,
                        height: 1.4,
                        decoration: _isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}