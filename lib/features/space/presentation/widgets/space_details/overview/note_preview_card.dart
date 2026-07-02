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

  // ✅ ارتفاع ثابت لكل الكارد (مش بس للوصف) — العنوان + السطرين + الـ padding.
  // ده اللي بيضمن إن كل كاردز النوت تطلع بنفس الطول بالظبط أيًا كان طول
  // العنوان أو الوصف. لو عايزة تكبري/تصغري الكارد، غيري الرقم ده بس.
  static const double _cardHeight = 100;

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
        height: _cardHeight, // ← الفيكس: ارتفاع صريح لكل الكارد
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
        padding: const EdgeInsets.all(AppValues.paddingMd),
        decoration: BoxDecoration(
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
          mainAxisAlignment: MainAxisAlignment.start,
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
            // ✅ Expanded بدل SizedBox بارتفاع تقريبي — بياخد باقي المساحة
            // المتاحة جوه الكارد المُثبّت، فمفيش أي احتمال يفيض أو يقصر.
            Expanded(
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