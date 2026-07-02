// lib/features/task/presentation/utils/task_ui_mapper.dart
//
// Central place for every UI <-> backend mapping decision for the Task
// screens. Read this file first if something on screen doesn't match the
// original mockups pixel-for-pixel — it's almost certainly explained here.
//
// ── Pure naming/label differences (mapped, not dropped) ────────────────
//   • Priority: the mockups show "Urgent" as the top chip. The backend enum
//     `TaskPriority` has no "urgent" value — its highest level is
//     `TaskPriority.critical`. We display it as "Urgent" but store/read it
//     as `critical`. `TaskPriority.none` is never offered as a choice
//     (it's a backend-only fallback for unset/legacy data).
//   • Status: the mockup tabs are "All / In Progress / To Do / Completed".
//     The backend enum `TaskStatus` is todo / inProgress / done / cancelled.
//     "Completed" (UI) == `TaskStatus.done` (backend). `cancelled` has no
//     dedicated tab (not in the mockups) but still renders correctly
//     wherever a task with that status shows up (e.g. under "All").
//
// ── Things the backend genuinely has no field for at all ───────────────
// (not a naming issue — there's nothing to map to). These are handled
// UI-only in the screens themselves, never sent to the API:
//   • The "Reviewing" status pill shown on one mockup card — dropped
//     entirely, no equivalent `TaskStatus` value exists.
//   • "Start Date" on Create/Edit Task — `TaskModel` only has `dueDate`.
//   • Category chips (Marketing Ops / Development / Design) — `TaskModel`
//     has no category/tag field.
//   • Task attachments — no attachment endpoint/model exists in the
//     provided logic files.
//   • Member "role" labels like Lead/Dev/Manager — `MemberModel` has no
//     job-title field, only `isOwner`. We show "Owner"/"Member" instead of
//     inventing titles.

import 'package:flutter/material.dart';
import '../../enums/task_priority.dart';
import '../../enums/task_status.dart';

class TaskUiMapper {
  TaskUiMapper._();

  // ── Priority ─────────────────────────────────────────────────────────

  /// Priority options actually offered in the Create/Edit Task UI.
  /// `TaskPriority.none` is intentionally excluded.
  static const List<TaskPriority> selectablePriorities = [
    TaskPriority.low,
    TaskPriority.medium,
    TaskPriority.high,
    TaskPriority.critical,
  ];

  static String priorityLabel(TaskPriority p) => switch (p) {
        TaskPriority.none => 'None',
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.critical => 'Urgent', // backend label: "Critical"
      };

  static String priorityShortLabel(TaskPriority p) =>
      priorityLabel(p).toUpperCase();

  static Color priorityColor(TaskPriority p) => switch (p) {
        TaskPriority.none => const Color(0xFF9CA3AF),
        TaskPriority.low => const Color(0xFF10B981),
        TaskPriority.medium => const Color(0xFFF59E0B),
        TaskPriority.high => const Color(0xFFEF4444),
        TaskPriority.critical => const Color(0xFFDC2626),
      };

  // ── Status ───────────────────────────────────────────────────────────

  static String statusLabel(TaskStatus s) => switch (s) {
        TaskStatus.todo => 'To Do',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.done => 'Completed',
        TaskStatus.cancelled => 'Cancelled',
      };

  static Color statusColor(TaskStatus s) => switch (s) {
        TaskStatus.todo => const Color(0xFFF59E0B),
        TaskStatus.inProgress => const Color(0xFF3B82F6),
        TaskStatus.done => const Color(0xFF10B981),
        TaskStatus.cancelled => const Color(0xFF9CA3AF),
      };

  static Color statusBgColor(TaskStatus s) =>
      statusColor(s).withOpacity(0.12);

  static const Color brandPurple = Color(0xFF6C3CE9);
  static const Color screenBg = Color(0xFFF5F5FA);
}
