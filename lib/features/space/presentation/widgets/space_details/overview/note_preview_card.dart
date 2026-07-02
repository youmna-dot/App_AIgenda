// lib/features/space/presentation/widgets/space_details/overview/note_preview_card.dart

import 'package:ajenda_app/features/space/presentation/utils/note_color_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_values.dart';
import '../../../../../Note/data/models/note_model.dart';
import '../../../../../../core/constants/app_colors.dart';

class NotePreviewCard extends StatefulWidget {
  final NoteModel note;

  /// لون احتياطي (لون الـ Space) بيتستخدم لحد ما لون النوت المحفوظ يتحمّل.
  final Color accentColor;
  final VoidCallback? onTap;

  const NotePreviewCard({
    super.key,
    required this.note,
    required this.accentColor,
    this.onTap,
  });

  @override
  State<NotePreviewCard> createState() => _NotePreviewCardState();
}

class _NotePreviewCardState extends State<NotePreviewCard> {
  late Color _noteColor;

  // ارتفاع ثابت لمنطقة الوصف (بيساوي تقريبًا سطرين نص بحجم 12.5 و line-height 1.4).
  // ده اللي بيخلي كل الكاردز نفس الطول بالظبط سواء فيها وصف طويل أو مفيهاش وصف خالص.
  // لو عاوزة تكبري/تصغري المساحة دي، غيري الرقم ده بس.
  static const double _descriptionSlotHeight = 35;

  @override
  void initState() {
    super.initState();
    _noteColor = widget.accentColor;
    _loadColor();
  }

  @override
  void didUpdateWidget(covariant NotePreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.note.id != widget.note.id) _loadColor();
  }

  Future<void> _loadColor() async {
    final c = await NoteColorService.load(widget.note.id);
    if (mounted) setState(() => _noteColor = c);
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.note;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
        padding: const EdgeInsets.all(AppValues.paddingMd),
        decoration: BoxDecoration(
          // نفس تدريجة الألوان القديمة (diagonal 0.18 → 0.06)
          // بس دلوقتي بلون النوت المختار مش لون التاسك بس
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _noteColor.withOpacity(0.18),
              _noteColor.withOpacity(0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(AppValues.radiusLg + 4),
          border: Border.all(color: _noteColor.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            // مساحة ثابتة دايمًا (سطرين) — سواء فيها نص أو فاضية،
            // عشان كل الكاردز تطلع بنفس الطول بالظبط.
            SizedBox(
              height: _descriptionSlotHeight,
              child: Text(
                note.previewText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}