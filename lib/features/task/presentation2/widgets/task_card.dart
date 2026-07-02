// lib/features/task/presentation/widgets/task_card.dart

import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
import '../../enums/task_status.dart';
import '../utils/task_ui_mapper.dart';
import 'member_avatar.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;

  const TaskCard({super.key, required this.task, required this.onTap});

  /// We only ever show a percentage we can actually back with real data:
  ///   • subtasks exist        -> completed / total
  ///   • status == done        -> 100%
  ///   • status == todo        -> 0%
  ///   • otherwise (inProgress/cancelled, no subtasks) -> unknown, so the
  ///     progress bar is simply not drawn instead of showing a fabricated
  ///     number (the backend gives us nothing to compute it from).
  double? get _progress {
    if (task.subTasks.isNotEmpty) {
      final done = task.subTasks.where((s) => s.isCompleted).length;
      return done / task.subTasks.length;
    }
    if (task.status == TaskStatus.done) return 1.0;
    if (task.status == TaskStatus.todo) return 0.0;
    return null;
  }

  bool get _isDone => task.status == TaskStatus.done;

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    final statusColor = TaskUiMapper.statusColor(task.status);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: statusColor, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration:
                          _isDone ? TextDecoration.lineThrough : null,
                      color: _isDone ? Colors.grey : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: TaskUiMapper.priorityColor(task.priority)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    TaskUiMapper.priorityShortLabel(task.priority),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: TaskUiMapper.priorityColor(task.priority),
                    ),
                  ),
                ),
              ],
            ),
            if ((task.description ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 10),
            if (progress != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFEDEDF5),
                  valueColor: AlwaysStoppedAnimation(statusColor),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (task.assignees.isNotEmpty)
                  MemberAvatar(label: task.assignees.first, radius: 13)
                else
                  const SizedBox(width: 26, height: 26),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    task.dueDate == null
                        ? (_isDone ? 'Completed' : 'No due date')
                        : '${_isDone ? 'Completed' : 'Due'} ${_formatDate(task.dueDate!)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: TaskUiMapper.statusBgColor(task.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    TaskUiMapper.statusLabel(task.status),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: TaskUiMapper.statusColor(task.status),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}
