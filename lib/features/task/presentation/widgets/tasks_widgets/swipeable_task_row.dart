// lib/features/workspace/presentation/widgets/space_details/shared/swipeable_task_row.dart
//
// Task row بـ swipe actions — مطابق للـ HTML design:
//   • Swipe LEFT  → Edit (purple) + Delete (red)
//   • Swipe RIGHT → Done (green)
//   • Long press  → Context menu (TODO: Phase 2)
//
// Usage في tasks_list_view.dart:
//   SwipeableTaskRow(
//     task: task,
//     accentColor: _color,
//     onDone:   () => cubit.updateTaskStatus(...),
//     onEdit:   () => openEditSheet(task),
//     onDelete: () => showDeleteConfirmSheet(...),
//   )

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';

    import '../../../data/models/task_model.dart';
import '../../../enums/task_priority.dart';

// ─────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────
const double _kActionWidth  = 56.0;   // عرض كل action button
const double _kLeftReveal   = _kActionWidth * 2; // Edit + Delete
const double _kRightReveal  = _kActionWidth;     // Done فقط
const double _kSwipeThresh  = 40.0;   // الـ drag الأدنى لتفعيل الـ swipe

// ─────────────────────────────────────────────────────────────
class SwipeableTaskRow extends StatefulWidget {
  final TaskModel task;
  final Color accentColor;
  final VoidCallback? onDone;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;   // فتح task detail

  const SwipeableTaskRow({
    super.key,
    required this.task,
    required this.accentColor,
    this.onDone,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  State<SwipeableTaskRow> createState() => _SwipeableTaskRowState();
}

class _SwipeableTaskRowState extends State<SwipeableTaskRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _offsetAnim;

  double _dragOffset = 0;
  bool _swiped = false; // true = left actions visible
  bool _swipedRight = false; // true = right (done) visible

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _offsetAnim = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() {
      _dragOffset = (_dragOffset + d.delta.dx).clamp(-_kLeftReveal, _kRightReveal);
    });
  }

  void _onDragEnd(DragEndDetails d) {
    if (_dragOffset < -_kSwipeThresh) {
      // فتح الـ left actions
      _animateTo(-_kLeftReveal);
      setState(() { _swiped = true; _swipedRight = false; });
      HapticFeedback.lightImpact();
    } else if (_dragOffset > _kSwipeThresh) {
      // فتح الـ right (done)
      _animateTo(_kRightReveal);
      setState(() { _swipedRight = true; _swiped = false; });
      HapticFeedback.lightImpact();
    } else {
      _close();
    }
  }

  void _animateTo(double target) {
    _offsetAnim = Tween<double>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward(from: 0);
    setState(() => _dragOffset = target);
  }

  void _close() {
    _animateTo(0);
    setState(() { _swiped = false; _swipedRight = false; });
  }

  // ── Priority helpers ──────────────────────────────────────
  Color _priorityColor(TaskPriority p) {
    switch (p) {
      case TaskPriority.critical: return AppColors.error;
      case TaskPriority.high:     return AppColors.error;
      case TaskPriority.medium:   return AppColors.warning;
      case TaskPriority.low:      return AppColors.success;
      case TaskPriority.none:     return AppColors.textMuted;
    }
  }

  Color _priorityBg(TaskPriority p) => _priorityColor(p).withOpacity(0.12);

  String _priorityLabel(TaskPriority p) {
    switch (p) {
      case TaskPriority.critical: return 'Critical';
      case TaskPriority.high:     return 'High';
      case TaskPriority.medium:   return 'Medium';
      case TaskPriority.low:      return 'Low';
      case TaskPriority.none:     return '';
    }
  }

  bool get _isDone => widget.task.status.index == 2; // TaskStatus.done

  // ── Due date helpers ──────────────────────────────────────
  bool get _isOverdue {
    if (widget.task.dueDate == null || _isDone) return false;
    return widget.task.dueDate!.isBefore(DateTime.now());
  }

  String _dueDateLabel() {
    if (widget.task.dueDate == null) return '';
    final d = widget.task.dueDate!;
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnim,
      builder: (_, __) {
        final offset = _ctrl.isAnimating ? _offsetAnim.value : _dragOffset;

        return SizedBox(
          height: 56,
          child: Stack(
            children: [
              // ── RIGHT action: Done ──────────────────────────
              Positioned(
                top: 0, bottom: 0, left: 0,
                width: _kActionWidth,
                child: _ActionButton(
                  label: '✓ Done',
                  color: AppColors.success,
                  bg: AppColors.success.withOpacity(0.12),
                  onTap: () {
                    _close();
                    widget.onDone?.call();
                  },
                ),
              ),

              // ── LEFT actions: Edit + Delete ─────────────────
              Positioned(
                top: 0, bottom: 0, right: 0,
                width: _kLeftReveal,
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: '✏ Edit',
                        color: widget.accentColor,
                        bg: widget.accentColor.withOpacity(0.12),
                        onTap: () {
                          _close();
                          widget.onEdit?.call();
                        },
                      ),
                    ),
                    Expanded(
                      child: _ActionButton(
                        label: '🗑 Del',
                        color: AppColors.error,
                        bg: AppColors.error.withOpacity(0.10),
                        onTap: () {
                          _close();
                          widget.onDelete?.call();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ── Draggable task row ──────────────────────────
              Positioned.fill(
                child: GestureDetector(
                  onHorizontalDragUpdate: _onDragUpdate,
                  onHorizontalDragEnd: _onDragEnd,
                  onTap: _swiped || _swipedRight
                      ? _close
                      : widget.onTap,
                  child: Transform.translate(
                    offset: Offset(offset, 0),
                    child: _TaskRowCard(
                      task: widget.task,
                      isDone: _isDone,
                      isOverdue: _isOverdue,
                      priorityColor: _priorityColor(widget.task.priority),
                      priorityBg: _priorityBg(widget.task.priority),
                      priorityLabel: _priorityLabel(widget.task.priority),
                      dueLabel: _dueDateLabel(),
                      accentColor: widget.accentColor,
                      onCheckTap: widget.onDone,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Task Row Card — الـ UI الرئيسي للـ row
// ─────────────────────────────────────────────────────────────
class _TaskRowCard extends StatelessWidget {
  final TaskModel task;
  final bool isDone;
  final bool isOverdue;
  final Color priorityColor;
  final Color priorityBg;
  final String priorityLabel;
  final String dueLabel;
  final Color accentColor;
  final VoidCallback? onCheckTap;

  const _TaskRowCard({
    required this.task,
    required this.isDone,
    required this.isOverdue,
    required this.priorityColor,
    required this.priorityBg,
    required this.priorityLabel,
    required this.dueLabel,
    required this.accentColor,
    this.onCheckTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withOpacity(0.08), width: 0.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Priority accent stripe
          Container(
            width: 3,
            decoration: BoxDecoration(
              color: isDone ? AppColors.success : priorityColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Checkbox
          GestureDetector(
            onTap: onCheckTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color: isDone ? AppColors.success : AppColors.textMuted.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded, size: 11, color: AppColors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 9),

          // Info
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  task.title,
                  style: GoogleFonts.poppins(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDone ? AppColors.textMuted : AppColors.textDark,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                // Meta row: priority + due date
                Row(
                  children: [
                    if (priorityLabel.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: priorityBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          priorityLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 8, fontWeight: FontWeight.w700, color: priorityColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    if (dueLabel.isNotEmpty)
                      Text(
                        isOverdue ? '⏰ Overdue' : '📅 $dueLabel',
                        style: GoogleFonts.poppins(
                          fontSize: 8.5,
                          color: isOverdue ? AppColors.error : AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Action Button (behind the row)
// ─────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: bg,
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }
}