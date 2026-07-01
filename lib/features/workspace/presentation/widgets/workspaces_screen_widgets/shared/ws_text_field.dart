// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/shared/ws_text_field.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_values.dart';

class WsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color accentColor;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  const WsTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.accentColor,
    this.maxLines = 1,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onSubmitted: onSubmitted,
      style: GoogleFonts.outfit(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(fontSize: 13.5, color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusMd),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusMd),
          borderSide: BorderSide(color: accentColor, width: 1.6),
        ),
      ),
    );
  }
}