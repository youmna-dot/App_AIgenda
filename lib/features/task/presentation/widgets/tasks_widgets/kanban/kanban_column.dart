// lib/features/task/presentation/widgets/tasks_widgets/kanban/kanban_column.dart
//
// REDESIGN — مطابق لـ .bcol + .bc + .bc-add في الـ HTML
//
// التغييرات:
//   • .bcol: white bg + border + rounded
//   • .bc: background = var(--bg) (AppColors.background) مش white
//   • .bc-add: dashed border زي الـ HTML

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';
import '../../../../data/models/task_model.dart';
import '../task_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<TaskModel> tasks;
  final Color accentColor;
  final VoidCallback? onAddTap;
  final void Function(TaskModel, int) onStatusChanged;
  final ValueChanged<TaskModel> onDelete;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.tasks,
    required this.accentColor,
    required this.onAddTap,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ✅ .bcol — white bg + border
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.09), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Column header (.bcol-hdr) ──────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: color.withOpacity(0.12), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // dot
                Container(
                  width: 7, height: 7,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                // name
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                // count badge (.bcol-cnt)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Column body (.bcol-body) ───────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Task cards
                  ...tasks.map((t) => TaskCard(
                    task: t,
                    accentColor: color,
                    onStatusChanged: (status) => onStatusChanged(t, status),
                    onDelete: () => onDelete(t),
                  )),

                  const SizedBox(height: 2),

                  // Add task dashed (.bc-add)
                  if (onAddTap != null)
                    GestureDetector(
                      onTap: onAddTap,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: color.withOpacity(0.22),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded, size: 12, color: color),
                            const SizedBox(width: 4),
                            Text(
                              'Add task',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}