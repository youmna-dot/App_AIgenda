// lib/features/home/presentation/widgets/home_recent_notes_section.dart
//
// Horizontal scrollable recent notes on the home screen.
// 🟡 Uses passed-in mock/real list — wire to NoteCubit when needed.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';

class HomeNotePreview {
  final String title;
  final String preview;
  final Color color;
  final String timeAgo;

  const HomeNotePreview({
    required this.title,
    required this.preview,
    required this.color,
    required this.timeAgo,
  });
}

class HomeRecentNotesSection extends StatelessWidget {
  final List<HomeNotePreview> notes;
  final VoidCallback? onViewAll;

  const HomeRecentNotesSection({
    super.key,
    required this.notes,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppValues.horizontalPadding),
          child: Row(
            children: [
              Text(
                'Recent Notes',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'View all notes',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Horizontal scroll ───────────────────────────
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.horizontalPadding),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => _NoteCard(note: notes[i]),
          ),
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  final HomeNotePreview note;
  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: note.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        border: Border.all(
          color: note.color.withOpacity(0.20),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Text(
              note.preview,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                color: AppColors.textMuted,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note.timeAgo,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: note.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}