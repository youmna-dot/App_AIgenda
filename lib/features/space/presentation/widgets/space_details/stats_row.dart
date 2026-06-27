// lib/features/workspace/presentation/widgets/space_details/stats_row.dart
//
// Stats row في header الـ Space Detail — actionable info فقط:
//   [43% Done] [2 Overdue ⚠] [May 5 nearest] [4 Notes]
//
// ✅ كل الأرقام بتيجي من TaskState + NoteState الحقيقيين
//
// Usage في space_detail_screen.dart:
//   StatsRow(
//     tasks: state.data.items,      // List<TaskModel>
//     noteCount: notesState is NotesSuccess ? notesState.data.totalCount : 0,
//     pinnedNoteCount: ...,
//     accentColor: _color,
//   )

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../task/data/models/task_model.dart';

// ─────────────────────────────────────────────────────────────
class StatsRow extends StatelessWidget {
  /// List<TaskModel> من TaskState — الحسابات كلها تتعمل جوا الـ widget
  final List<dynamic> tasks;   // dynamic لتجنب import مشاكل — بيـ cast جوا

  /// عدد الـ notes من NoteState
  final int noteCount;

  /// عدد الـ pinned notes (اختياري)
  final int pinnedNoteCount;

  /// لون الـ space للـ theming
  final Color accentColor;

  const StatsRow({
    super.key,
    required this.tasks,
    required this.noteCount,
    this.pinnedNoteCount = 0,
    required this.accentColor,
  });

  // ── Computed stats ────────────────────────────────────────
  int get _total => tasks.length;

  int get _done {
    // TaskStatus.done = index 2
    return tasks.where((t) {
      try { return (t.status as dynamic).index == 2; } catch (_) { return false; }
    }).length;
  }

  int get _overdue {
    final now = DateTime.now();
    return tasks.where((t) {
      try {
        final due = (t as dynamic).dueDate as DateTime?;
        final statusIdx = (t.status as dynamic).index as int;
        return due != null && due.isBefore(now) && statusIdx != 2;
      } catch (_) { return false; }
    }).length;
  }

  double get _completionRate => _total == 0 ? 0 : _done / _total;

  /// أقرب due date من الـ tasks المفتوحة
  DateTime? get _nearestDue {
    final now = DateTime.now();
    DateTime? nearest;
    for (final t in tasks) {
      try {
        final due = (t as dynamic).dueDate as DateTime?;
        final statusIdx = (t.status as dynamic).index as int;
        if (due != null && due.isAfter(now) && statusIdx != 2) {
          if (nearest == null || due.isBefore(nearest)) nearest = due;
        }
      } catch (_) {}
    }
    return nearest;
  }

  String _formatDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }

  String _daysUntil(DateTime d) {
    final diff = d.difference(DateTime.now()).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return '1 day';
    return '$diff days';
  }

  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final pct = (_completionRate * 100).round();
    final nearest = _nearestDue;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: accentColor.withOpacity(0.10), width: 0.5),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // ── 1. Completion % ──────────────────────────────
            Expanded(
              child: _StatCell(
                value: '$pct%',
                valueColor: accentColor,
                label: 'Completion',
                badge: '$_done/$_total done',
                badgeBg: accentColor.withOpacity(0.08),
                badgeColor: accentColor,
              ),
            ),
            _divider,

            // ── 2. Overdue ───────────────────────────────────
            Expanded(
              child: _StatCell(
                value: '$_overdue',
                valueColor: _overdue > 0 ? AppColors.error : AppColors.success,
                label: 'Overdue',
                badge: _overdue > 0 ? '⚠ urgent' : '✓ on track',
                badgeBg: _overdue > 0
                    ? AppColors.error.withOpacity(0.08)
                    : AppColors.success.withOpacity(0.08),
                badgeColor: _overdue > 0 ? AppColors.error : AppColors.success,
              ),
            ),
            _divider,

            // ── 3. Nearest due ───────────────────────────────
            Expanded(
              child: nearest != null
                  ? _StatCell(
                value: _formatDate(nearest),
                valueColor: AppColors.warning,
                label: 'Nearest due',
                badge: _daysUntil(nearest),
                badgeBg: AppColors.warning.withOpacity(0.10),
                badgeColor: const Color(0xFF9A6700),
              )
                  : _StatCell(
                value: '–',
                valueColor: AppColors.textMuted,
                label: 'Nearest due',
                badge: 'none',
                badgeBg: AppColors.background,
                badgeColor: AppColors.textMuted,
              ),
            ),
            _divider,

            // ── 4. Notes ─────────────────────────────────────
            Expanded(
              child: _StatCell(
                value: '$noteCount',
                valueColor: AppColors.textMuted,
                label: 'Notes',
                badge: pinnedNoteCount > 0 ? '$pinnedNoteCount pinned' : 'no pinned',
                badgeBg: AppColors.background,
                badgeColor: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _divider => VerticalDivider(
    width: 0.5, thickness: 0.5,
    color: AppColors.primary.withOpacity(0.08),
    indent: 8, endIndent: 8,
  );
}

// ─────────────────────────────────────────────────────────────
// Stat Cell
// ─────────────────────────────────────────────────────────────
class _StatCell extends StatelessWidget {
  final String value;
  final Color valueColor;
  final String label;
  final String badge;
  final Color badgeBg;
  final Color badgeColor;

  const _StatCell({
    required this.value,
    required this.valueColor,
    required this.label,
    required this.badge,
    required this.badgeBg,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Value (number / percentage / date)
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 8, color: AppColors.textMuted),
          ),
          const SizedBox(height: 3),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: GoogleFonts.poppins(
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}