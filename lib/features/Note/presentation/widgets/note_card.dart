// lib/features/note/presentation/widgets/note_card.dart
//
// ✅ مصلح — بيستخدم NoteModel الحقيقي من features/note/data/models/note_model.dart
//
// التغييرات:
//   • note.content → note.previewText  (getter موجود في NoteModel)
//   • note.color   → _typeColor(note.type)  (NoteModel مفيش فيه color field)
//   • note.type    → String ('Text' | 'Voice' | 'Image' | 'HandDraw')
//   • note.createdAt → DateTime? (nullable)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  // ✅ لون بناءً على الـ type String (مش enum)
  Color _typeColor() {
    switch (note.type) {
      case 'Voice':    return AppColors.error;
      case 'Image':    return const Color(0xFF0984E3);
      case 'HandDraw': return AppColors.warning;
      default:         return AppColors.primary; // Text
    }
  }

  IconData _typeIcon() {
    switch (note.type) {
      case 'Voice':    return Icons.mic_rounded;
      case 'Image':    return Icons.image_rounded;
      case 'HandDraw': return Icons.draw_outlined;
      default:         return Icons.text_fields_rounded; // Text
    }
  }

  String _typeLabel() {
    switch (note.type) {
      case 'Voice':    return 'Voice';
      case 'Image':    return 'Image';
      case 'HandDraw': return 'Draw';
      default:         return 'Text';
    }
  }

  String _dateLabel() {
    final d = note.createdAt;
    if (d == null) return '';
    return '${d.day}/${d.month}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor();
    // ✅ note.previewText — getter في NoteModel يرجع أول محتوى متاح
    final preview = note.previewText;

    return Container(
      padding: const EdgeInsets.all(AppValues.paddingLg - 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppValues.radiusLg + 2),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppValues.radiusXs),
                ),
                child: Icon(_typeIcon(), color: color, size: 16),
              ),
              const Spacer(),
              Text(
                _dateLabel(),
                style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: AppValues.paddingSm),

          // ✅ note.title
          Text(
            note.title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // ✅ note.previewText بدل note.content
          if (preview.isNotEmpty) ...[
            const SizedBox(height: AppValues.paddingXs),
            Text(
              preview,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const Spacer(),

          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.paddingXs - 1, vertical: 3,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppValues.radiusXs),
            ),
            child: Text(
              _typeLabel(),
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}