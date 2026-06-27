// lib/features/task/presentation/widgets/tasks_widgets/kanban/kanban_board.dart
//
// REDESIGN — مطابق لـ board-view في الـ HTML
//
// التغييرات:
//   • "Swipe columns left/right to navigate" hint في الأعلى
//   • أزلنا الـ CTA button الكبير (موجود في space_detail_screen كـ FAB)
//   • board-cols: horizontal scroll + 3 columns
//   • كل column = KanbanColumn (المعدل)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';
import '../create_task_sheet.dart';
import '../../../../data/models/task_model.dart';
import '../../../../enums/task_priority.dart';
import '../../../../enums/task_status.dart';
import 'empty_tasks.dart';
import 'kanban_column.dart';

class KanbanBoard extends StatelessWidget {
  final List<TaskModel> tasks;
  final Color accentColor;
  final int workspaceId;
  final String spaceId;
  final VoidCallback? onAddTask;
  final void Function(
      String title,
      String description,
      TaskPriority priority,
      DateTime? dueDate,
      List<String> subtasks,
      ) onTaskAdded;
  final void Function(TaskModel task, int status) onStatusChanged;
  final ValueChanged<TaskModel> onDelete;

  const KanbanBoard({
    super.key,
    required this.tasks,
    required this.accentColor,
    required this.workspaceId,
    required this.spaceId,
    required this.onAddTask,
    required this.onTaskAdded,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyTasks(accentColor: accentColor, onAddTask: onAddTask);
    }

    final todo       = tasks.where((t) => t.status == TaskStatus.todo).toList();
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    final done       = tasks.where((t) => t.status == TaskStatus.done).toList();

    return Column(
      children: [
        // ── Swipe hint (.board-view hint) ──────────────────────
        // ✅ مطابق للـ HTML: "Swipe columns left/right to navigate"
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swap_horiz_rounded, size: 12, color: AppColors.textMuted.withOpacity(0.6)),
              const SizedBox(width: 4),
              Text(
                'Swipe columns left/right to navigate',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: AppColors.textMuted.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),

        // ── Board columns (horizontal scroll) ──────────────────
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 210,
                  child: KanbanColumn(
                    title: 'To Do',
                    icon: Icons.radio_button_unchecked_rounded,
                    color: AppColors.error,
                    tasks: todo,
                    accentColor: accentColor,
                    onAddTap: onAddTask != null
                        ? () => _openCreateWithStatus(context, TaskStatus.todo)
                        : null,
                    onStatusChanged: onStatusChanged,
                    onDelete: onDelete,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 210,
                  child: KanbanColumn(
                    title: 'In Progress',
                    icon: Icons.timelapse_rounded,
                    color: AppColors.warning,
                    tasks: inProgress,
                    accentColor: accentColor,
                    onAddTap: onAddTask != null
                        ? () => _openCreateWithStatus(context, TaskStatus.inProgress)
                        : null,
                    onStatusChanged: onStatusChanged,
                    onDelete: onDelete,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 210,
                  child: KanbanColumn(
                    title: 'Done',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    tasks: done,
                    accentColor: accentColor,
                    onAddTap: null, // Done column — مفيش add
                    onStatusChanged: onStatusChanged,
                    onDelete: onDelete,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openCreateWithStatus(BuildContext context, TaskStatus status) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => CreateTaskSheet(
        accentColor: accentColor,
        initialStatus: status,
        onCreated: onTaskAdded,
      ),
    );
  }
}