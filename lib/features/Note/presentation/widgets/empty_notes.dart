// lib/features/workspace/presentation/widgets/space_details/widgets/notes/empty_notes.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/constants/app_widget_styles.dart';

class EmptyNotes extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onAddNote;

  const EmptyNotes({super.key, required this.accentColor, required this.onAddNote});

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
              child: const Icon(Icons.note_rounded, color: AppColors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notes Yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture your ideas, write text notes,\nrecord voice, or add images.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onAddNote,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: AppWidgetStyles.ctaButton(accentColor),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.note_add_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Add First Note',
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