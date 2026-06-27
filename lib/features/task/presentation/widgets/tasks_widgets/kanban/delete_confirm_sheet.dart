// lib/features/workspace/presentation/widgets/space_details/shared/delete_confirm_sheet.dart
//
// Bottom sheet تأكيد الحذف — يتكال من:
//   • swipeable_task_row.dart    → deleteType: DeleteType.task
//   • notes_tab.dart             → deleteType: DeleteType.note
//   • space_detail_header.dart   → deleteType: DeleteType.space
//
// Usage:
//   showDeleteConfirmSheet(
//     context: context,
//     type: DeleteType.task,
//     itemName: task.title,
//     onConfirm: () => cubit.deleteTask(...),
//   );

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';

// ─────────────────────────────────────────────────────────────
// DeleteType enum
// ─────────────────────────────────────────────────────────────
enum DeleteType { task, note, space }

extension DeleteTypeX on DeleteType {
  String get title {
    switch (this) {
      case DeleteType.task:  return 'Delete Task?';
      case DeleteType.note:  return 'Delete Note?';
      case DeleteType.space: return 'Delete Space?';
    }
  }

  String get subtitle {
    switch (this) {
      case DeleteType.task:
        return 'This task and all its subtasks will be permanently removed.';
      case DeleteType.note:
        return 'This note will be permanently deleted.';
      case DeleteType.space:
        return 'All tasks and notes inside this space will be permanently deleted.';
    }
  }

  IconData get icon {
    switch (this) {
      case DeleteType.task:  return Icons.check_box_outlined;
      case DeleteType.note:  return Icons.sticky_note_2_outlined;
      case DeleteType.space: return Icons.layers_outlined;
    }
  }

  // للـ space تكون الرسالة أشد تحذيراً
  bool get isDestructive => this == DeleteType.space;
}

// ─────────────────────────────────────────────────────────────
// Helper function — استخدميها مباشرة
// ─────────────────────────────────────────────────────────────
Future<void> showDeleteConfirmSheet({
  required BuildContext context,
  required DeleteType type,
  String? itemName,           // اسم الـ item اللي بيتحذف (اختياري)
  required VoidCallback onConfirm,
  Color? accentColor,         // لون الـ space (اختياري — للـ theming)
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _DeleteConfirmSheet(
      type: type,
      itemName: itemName,
      onConfirm: onConfirm,
      accentColor: accentColor,
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// Sheet Widget
// ─────────────────────────────────────────────────────────────
class _DeleteConfirmSheet extends StatefulWidget {
  final DeleteType type;
  final String? itemName;
  final VoidCallback onConfirm;
  final Color? accentColor;

  const _DeleteConfirmSheet({
    required this.type,
    this.itemName,
    required this.onConfirm,
    this.accentColor,
  });

  @override
  State<_DeleteConfirmSheet> createState() => _DeleteConfirmSheetState();
}

class _DeleteConfirmSheetState extends State<_DeleteConfirmSheet> {
  bool _isDeleting = false;

  Future<void> _handleConfirm() async {
    setState(() => _isDeleting = true);
    try {
      widget.onConfirm();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSpace = widget.type.isDestructive;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: AppColors.wsHandleBar,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon circle
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.type.icon, color: AppColors.error, size: 24),
          ),
          const SizedBox(height: 14),

          // Title
          Text(
            widget.type.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),

          // Item name (lو موجود)
          if (widget.itemName != null && widget.itemName!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${widget.itemName}"',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Subtitle
          Text(
            widget.type.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textMuted,
              height: 1.5,
            ),
          ),

          // Extra warning للـ space
          if (isSpace) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 15),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This cannot be undone. All data will be lost.',
                      style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 22),

          // Buttons row
          Row(
            children: [
              // Cancel
              Expanded(
                child: GestureDetector(
                  onTap: _isDeleting ? null : () => Navigator.pop(context),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppValues.radiusSm),
                      border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Delete
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _isDeleting ? null : _handleConfirm,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 46,
                    decoration: BoxDecoration(
                      color: _isDeleting
                          ? AppColors.error.withOpacity(0.5)
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(AppValues.radiusSm),
                      boxShadow: _isDeleting
                          ? []
                          : [BoxShadow(color: AppColors.error.withOpacity(0.30), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Center(
                      child: _isDeleting
                          ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.white),
                      )
                          : Text(
                        widget.type.isDestructive ? 'Delete Space' : 'Delete',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}