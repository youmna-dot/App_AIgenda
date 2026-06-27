// lib/features/Note/presentation/widgets/note_viewer_sheet.dart
//
// Read-only viewer for a NoteModel.
// Shows full content; has an "Edit" button that opens the edit sheet.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../data/models/note_model.dart';

class NoteViewerSheet extends StatelessWidget {
  final NoteModel note;
  final Color accentColor;
  final VoidCallback onEdit;

  const NoteViewerSheet({
    super.key,
    required this.note,
    required this.accentColor,
    required this.onEdit,
  });

  Color _typeColor() {
    switch (note.type) {
      case 'Voice':    return AppColors.error;
      case 'Image':    return const Color(0xFF0984E3);
      case 'HandDraw': return AppColors.warning;
      default:         return accentColor;
    }
  }

  IconData _typeIcon() {
    switch (note.type) {
      case 'Voice':    return Icons.mic_rounded;
      case 'Image':    return Icons.image_rounded;
      case 'HandDraw': return Icons.draw_rounded;
      default:         return Icons.sticky_note_2_outlined;
    }
  }

  String _typeName() {
    switch (note.type) {
      case 'Voice':    return 'Voice Note';
      case 'Image':    return 'Image Note';
      case 'HandDraw': return 'Drawing';
      default:         return 'Text Note';
    }
  }

  String _dateLabel(DateTime? d) {
    if (d == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────────────────────────────
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0DCF0),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 14),

          // ── Accent top strip ──────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Scrollable content ────────────────────────────
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row: type badge + pin indicator
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_typeIcon(), color: color, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              _typeName(),
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: color),
                            ),
                          ],
                        ),
                      ),
                      if (note.isPinned) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.push_pin_rounded,
                            color: AppColors.warning, size: 14),
                      ],
                      const Spacer(),
                      Text(
                        _dateLabel(note.updatedAt ?? note.createdAt),
                        style: GoogleFonts.poppins(
                            fontSize: 9, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    note.title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Content area per type
                  _buildContent(color),

                  const SizedBox(height: 28),

                  // Edit button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onEdit();
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                              color: color.withOpacity(0.30),
                              blurRadius: 14,
                              offset: const Offset(0, 5))
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.edit_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Edit Note',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Color color) {
    switch (note.type) {
      case 'Voice':
        return _VoiceViewer(color: color);
      case 'Image':
        return _ImageViewer();
      case 'HandDraw':
        return _DrawViewer(color: color);
      default:
      // Text note
        final body = note.plainText ?? '';
        if (body.isEmpty) {
          return Text(
            'No content.',
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic),
          );
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F7FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E4FF)),
          ),
          child: Text(
            body,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textDark,
              height: 1.6,
            ),
          ),
        );
    }
  }
}

// ── Voice viewer (placeholder until real audio support) ──────
class _VoiceViewer extends StatelessWidget {
  final Color color;
  const _VoiceViewer({required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [
      14.0, 22.0, 16.0, 30.0, 12.0, 26.0, 18.0, 32.0,
      14.0, 20.0, 10.0, 28.0, 16.0, 24.0, 12.0
    ];
    return Container(
      height: 80,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.mic_rounded, color: color, size: 22),
          const SizedBox(width: 12),
          ...heights.map((h) => Container(
            width: 3,
            height: h,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.6),
              borderRadius: BorderRadius.circular(2),
            ),
          )),
          const SizedBox(width: 8),
          Text(
            'Voice playback\ncoming soon',
            style: GoogleFonts.poppins(
                fontSize: 9, color: color.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Image viewer placeholder ─────────────────────────────────
class _ImageViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F4FD), Color(0xFFC8E6F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🖼️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'Image support coming soon',
            style: GoogleFonts.poppins(
                fontSize: 11, color: const Color(0xFF4A90E2)),
          ),
        ],
      ),
    );
  }
}

// ── Drawing viewer placeholder ───────────────────────────────
class _DrawViewer extends StatelessWidget {
  final Color color;
  const _DrawViewer({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✏️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'Drawing canvas coming soon',
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.warning),
          ),
        ],
      ),
    );
  }
}