// lib/features/Note/presentation/widgets/edit_note_sheet.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/note_model.dart';

class EditNoteSheet extends StatefulWidget {
  final NoteModel note;
  final Color accentColor;

  /// بيرجع (title, plainText, type, isPinned)
  final void Function(
      String title,
      String plainText,
      String type,
      bool isPinned,
      ) onSaved;

  const EditNoteSheet({
    super.key,
    required this.note,
    required this.accentColor,
    required this.onSaved,
  });

  @override
  State<EditNoteSheet> createState() => _EditNoteSheetState();
}

class _EditNoteSheetState extends State<EditNoteSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late bool _isPinned;

  Color get _accent => widget.accentColor;

  @override
  void initState() {
    super.initState();
    _titleCtrl   = TextEditingController(text: widget.note.title);
    _contentCtrl = TextEditingController(text: widget.note.plainText ?? '');
    _isPinned    = widget.note.isPinned;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    widget.onSaved(
      title,
      _contentCtrl.text.trim(),
      widget.note.type, // type مش بيتغير في الـ edit
      _isPinned,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0DCF0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.edit_note_rounded,
                      color: _accent, size: 20),
                ),
                const SizedBox(width: 11),
                Text(
                  'Edit Note',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1035),
                  ),
                ),
                const Spacer(),
                // Pin toggle
                GestureDetector(
                  onTap: () => setState(() => _isPinned = !_isPinned),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isPinned
                          ? AppColors.warning.withOpacity(0.12)
                          : const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isPinned
                            ? AppColors.warning
                            : const Color(0xFFE8E4FF),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isPinned
                              ? Icons.push_pin_rounded
                              : Icons.push_pin_outlined,
                          size: 13,
                          color: _isPinned
                              ? AppColors.warning
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isPinned ? 'Pinned' : 'Pin',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _isPinned
                                ? AppColors.warning
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),

            // Type badge (read-only)
            _TypeLabel(type: widget.note.type, accent: _accent),
            const SizedBox(height: 16),

            // Title
            _SLabel('Note Title *'),
            const SizedBox(height: 6),
            TextField(
              controller: _titleCtrl,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF1A1035)),
              decoration: _fieldDecoration(
                  hint: 'Note title...', accent: _accent),
            ),
            const SizedBox(height: 14),

            // Content — Text only
            if (widget.note.type == 'Text') ...[
              _SLabel('Content'),
              const SizedBox(height: 6),
              TextField(
                controller: _contentCtrl,
                maxLines: 6,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: const Color(0xFF1A1035)),
                decoration: _fieldDecoration(
                    hint: 'Write your note here...', accent: _accent),
              ),
            ],

            const SizedBox(height: 26),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _save,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Save Changes',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required Color accent,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
      GoogleFonts.poppins(fontSize: 13, color: AppColors.textHint),
      filled: true,
      fillColor: const Color(0xFFF8F7FF),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide:
          const BorderSide(color: Color(0xFFE8E4FF))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: accent, width: 1.5)),
    );
  }
}

// ── Type label (read-only badge) ──────────────────────────────
class _TypeLabel extends StatelessWidget {
  final String type;
  final Color accent;
  const _TypeLabel({required this.type, required this.accent});

  IconData _icon() {
    switch (type) {
      case 'Voice':    return Icons.mic_rounded;
      case 'Image':    return Icons.image_rounded;
      case 'HandDraw': return Icons.draw_outlined;
      default:         return Icons.text_fields_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_icon(), size: 14, color: accent),
        const SizedBox(width: 5),
        Text(
          type,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: accent,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '· read-only type',
          style: GoogleFonts.poppins(
              fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1A1035),
    ),
  );
}