// lib/features/Note/presentation/widgets/create_note_sheet.dart
//
// FIXES:
//  1. Added HandDraw option to the type selector row (2x2 grid layout)
//  2. Color selection is now wired: _colorIdx passed as noteColor int via onCreated
//     Signature change: onCreated now receives a 4th param `int colorIndex`
//     (0-5) → callers should pass it to createNoteAndReturn / backend if supported
//  3. HandDraw type shows a real finger-drawing canvas (hand_draw_canvas.dart)
//  4. Voice/Image show proper placeholder UIs
//  5. Color palette now sourced from NoteColorService — single source of truth
//     shared with NotePreviewCard, so the saved color always matches the picker.

import 'package:ajenda_app/features/space/presentation/utils/note_color_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../data/models/note_model.dart';
import 'hand_draw_canvas.dart'; // NEW

class CreateNoteSheet extends StatefulWidget {
  final Color accentColor;

  /// title, plainText, type ('Text'|'Voice'|'Image'|'HandDraw'), colorIndex (0-5)
  final void Function(
      String title,
      String plainText,
      String type,
      int colorIndex,   // FIX 3: wired color
      ) onCreated;

  const CreateNoteSheet({
    super.key,
    required this.accentColor,
    required this.onCreated,
  });

  @override
  State<CreateNoteSheet> createState() => _CreateNoteSheetState();
}

class _CreateNoteSheetState extends State<CreateNoteSheet> {
  final _titleCtrl   = TextEditingController();
  final _contentCtrl = TextEditingController();
  NoteType _selectedType = NoteType.text;

  // Single source of truth shared with NoteColorService, so the palette
  // shown here always matches the one used to persist/render note colors.
  static final List<Color> _noteColors = NoteColorService.palette;
  int _colorIdx = 0;

  // HandDraw strokes captured from the canvas
  List<List<Offset>> _drawStrokes = [];

  Color get _accent => widget.accentColor;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  String get _typeApiValue {
    switch (_selectedType) {
      case NoteType.text:     return 'Text';
      case NoteType.voice:    return 'Voice';
      case NoteType.image:    return 'Image';
      case NoteType.handDraw: return 'HandDraw';
    }
  }

  void _create() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    widget.onCreated(
      title,
      _contentCtrl.text.trim(),
      _typeApiValue,
      _colorIdx,  // FIX: pass selected color index
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
            // ── Handle ──────────────────────────────────────
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFE0DCF0),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),

            // ── Header ──────────────────────────────────────
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.note_add_rounded, color: _accent, size: 20),
                ),
                const SizedBox(width: 11),
                Text('Create Note',
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1035))),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),

            // ── Note Type — 2×2 grid to fit HandDraw ────────
            _SLabel('Note Type'),
            const SizedBox(height: 10),
            _buildTypeGrid(),
            const SizedBox(height: 18),

            // ── Note Color ───────────────────────────────────
            _SLabel('Note Color'),
            const SizedBox(height: 8),
            _buildColorPicker(),
            const SizedBox(height: 18),

            // ── Title ────────────────────────────────────────
            _SLabel('Note Title *'),
            const SizedBox(height: 6),
            TextField(
              controller: _titleCtrl,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF1A1035)),
              decoration: _inputDecoration('Give your note a title...'),
            ),
            const SizedBox(height: 14),

            // ── Type-specific content area ───────────────────
            _buildContentArea(),

            const SizedBox(height: 26),

            // ── Action buttons ───────────────────────────────
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
                        border: Border.all(color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _create,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                              color: _accent.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Center(
                        child: Text('Create Note',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
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

  // ── Type selector: 2×2 grid so HandDraw fits ──────────────
  Widget _buildTypeGrid() {
    final types = [
      (NoteType.text,     'Text',  Icons.text_fields_rounded),
      (NoteType.voice,    'Voice', Icons.mic_rounded),
      (NoteType.image,    'Image', Icons.image_rounded),
      (NoteType.handDraw, 'Draw',  Icons.draw_rounded),  // FIX: added
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.85,
      children: types.map((item) {
        final isSelected = _selectedType == item.$1;
        return GestureDetector(
          onTap: () => setState(() => _selectedType = item.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected
                  ? _accent.withOpacity(0.1)
                  : const Color(0xFFF8F7FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _accent : const Color(0xFFE8E4FF),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.$3,
                    color: isSelected ? _accent : AppColors.textMuted,
                    size: 20),
                const SizedBox(height: 4),
                Text(item.$2,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? _accent
                            : AppColors.textSecondary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Color picker row ─────────────────────────────────────
  Widget _buildColorPicker() {
    return Row(
      children: List.generate(_noteColors.length, (i) {
        final isSelected = _colorIdx == i;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () => setState(() => _colorIdx = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: _noteColors[i],
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.white, width: 2.5)
                    : null,
                boxShadow: isSelected
                    ? [BoxShadow(
                    color: _noteColors[i].withOpacity(0.5),
                    blurRadius: 8)]
                    : [],
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                  color: Colors.white, size: 14)
                  : null,
            ),
          ),
        );
      }),
    );
  }

  // ── Content area changes by type ─────────────────────────
  Widget _buildContentArea() {
    switch (_selectedType) {
      case NoteType.text:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SLabel('Content'),
            const SizedBox(height: 6),
            TextField(
              controller: _contentCtrl,
              maxLines: 5,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: const Color(0xFF1A1035)),
              decoration: _inputDecoration('Write your note here...'),
            ),
          ],
        );

      case NoteType.voice:
        return _PlaceholderBox(
          icon: Icons.mic_rounded,
          message: 'Voice recording — coming soon',
          color: _accent,
        );

      case NoteType.image:
        return _PlaceholderBox(
          icon: Icons.add_photo_alternate_rounded,
          message: 'Tap to add image — coming soon',
          color: _accent,
          dashed: true,
        );

      case NoteType.handDraw:
      // FIX: real drawing canvas
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SLabel('Drawing Canvas'),
                GestureDetector(
                  onTap: () => setState(() => _drawStrokes = []),
                  child: Text('Clear',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.error,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            HandDrawCanvas(
              height: 200,
              strokeColor: _accent,
              onStrokesChanged: (strokes) =>
                  setState(() => _drawStrokes = strokes),
            ),
          ],
        );
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
          fontSize: 13, color: AppColors.textHint),
      filled: true,
      fillColor: const Color(0xFFF8F7FF),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Color(0xFFE8E4FF))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: _accent, width: 1.5)),
    );
  }
}

// ── Shared placeholder widget ─────────────────────────────────
class _PlaceholderBox extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  final bool dashed;

  const _PlaceholderBox({
    required this.icon,
    required this.message,
    required this.color,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(message,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────
class _SLabel extends StatelessWidget {
  final String text;
  const _SLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1035)));
}