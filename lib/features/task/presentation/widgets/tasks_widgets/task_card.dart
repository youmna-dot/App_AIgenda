// lib/features/task/presentation/widgets/tasks_widgets/task_card.dart
//
// REDESIGN — مطابق لـ .bc style في الـ HTML
//
// التغييرات:
//   • شكل أبسط: bg = var(--bg) مش white، border خفيف
//   • priority badge + due date فقط في الـ meta row
//   • مفيش top color strip (اتشالت)
//   • subtasks progress في السطر الثالث
//   • opacity 0.6 لو done

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../data/models/task_model.dart';
import '../../../enums/task_priority.dart';
import '../../../enums/task_status.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final Color accentColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final ValueChanged<int>? onStatusChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.accentColor,
    this.onTap,
    this.onDelete,
    this.onStatusChanged,
  });

  // ── Priority helpers ──────────────────────────────────────
  Color get _priorityColor {
    switch (task.priority) {
      case TaskPriority.critical:
      case TaskPriority.high:   return AppColors.error;
      case TaskPriority.medium: return AppColors.warning;
      case TaskPriority.low:    return AppColors.success;
      default:                  return AppColors.textMuted;
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case TaskPriority.critical: return 'Critical';
      case TaskPriority.high:     return 'High';
      case TaskPriority.medium:   return 'Medium';
      case TaskPriority.low:      return 'Low';
      default:                    return '';
    }
  }

  bool get _isCompleted => task.status == TaskStatus.done;

  bool get _isOverdue =>
      task.dueDate != null &&
          task.dueDate!.isBefore(DateTime.now()) &&
          !_isCompleted;

  @override
  Widget build(BuildContext context) {
    final completedSubs = task.subTasks.where((s) => s.isCompleted).length;
    final hasSubs       = task.subTasks.isNotEmpty;
    final hasDue        = task.dueDate != null;

    return Opacity(
      // ✅ Done tasks بتبقى أفتح — مطابق للـ HTML opacity .55
      opacity: _isCompleted ? 0.55 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            // ✅ .bc { background: var(--bg) } — مش white
            color: AppColors.background,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.primary.withOpacity(0.07), width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row ──────────────────────────────────
              Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () => onStatusChanged?.call(
                      _isCompleted ? TaskStatus.todo.index : TaskStatus.done.index,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 14, height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCompleted ? AppColors.success : Colors.transparent,
                        border: Border.all(
                          color: _isCompleted
                              ? AppColors.success
                              : AppColors.textMuted.withOpacity(0.35),
                          width: 1.3,
                        ),
                      ),
                      child: _isCompleted
                          ? const Icon(Icons.check_rounded, size: 9, color: AppColors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: _isCompleted ? AppColors.textMuted : AppColors.textDark,
                        decoration: _isCompleted ? TextDecoration.lineThrough : null,
                        decorationColor: AppColors.textMuted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Delete X (اختياري — لو onDelete موجود)
                  if (onDelete != null && !_isCompleted)
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(
                        Icons.close_rounded,
                        size: 12,
                        color: AppColors.textMuted.withOpacity(0.4),
                      ),
                    ),
                ],
              ),

              // ── Meta row ───────────────────────────────────
              if (_priorityLabel.isNotEmpty || hasDue || hasSubs) ...[
                const SizedBox(height: 5),
                Wrap(
                  spacing: 4,
                  runSpacing: 3,
                  children: [
                    // Priority badge
                    if (_priorityLabel.isNotEmpty)
                      _Badge(
                        label: _priorityLabel,
                        color: _priorityColor,
                        bg: _priorityColor.withOpacity(0.12),
                      ),

                    // Due date
                    if (hasDue)
                      _Badge(
                        label: _isOverdue
                            ? '⏰ Overdue'
                            : '📅 ${task.dueDate!.day}/${task.dueDate!.month}',
                        color: _isOverdue ? AppColors.error : AppColors.textMuted,
                        bg: _isOverdue
                            ? AppColors.error.withOpacity(0.08)
                            : AppColors.background,
                      ),

                    // Subtasks progress
                    if (hasSubs)
                      _Badge(
                        label: '$completedSubs/${task.subTasks.length}',
                        color: accentColor,
                        bg: accentColor.withOpacity(0.08),
                        icon: Icons.checklist_rounded,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Badge widget ──────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final IconData? icon;

  const _Badge({
    required this.label,
    required this.color,
    required this.bg,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 9, color: color),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}