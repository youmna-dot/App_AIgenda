// lib/features/workspace/presentation/widgets/space_details/widgets/kanban/empty_tasks.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_values.dart';
import '../../../../../../../core/constants/app_widget_styles.dart';

class EmptyTasks extends StatelessWidget {
  final Color accentColor;
  final VoidCallback? onAddTask;

  const EmptyTasks({super.key, required this.accentColor, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [accentColor, accentColor.withOpacity(0.7)]),
                borderRadius: BorderRadius.circular(AppValues.radiusCard),
                boxShadow: AppWidgetStyles.glow(accentColor, opacity: 0.30, blur: 20),
              ),
              child: const Icon(Icons.task_alt_rounded, color: AppColors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'No Tasks Yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by creating your first task\nto track your progress.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            if (onAddTask != null)
              GestureDetector(
                onTap: onAddTask,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  decoration: AppWidgetStyles.ctaButton(accentColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Add First Task',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}