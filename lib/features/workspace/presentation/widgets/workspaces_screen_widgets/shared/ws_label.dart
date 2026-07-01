// lib/features/workspace/presentation/widgets/workspaces_screen_widgets/shared/ws_label.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/constants/app_colors.dart';

class WsLabel extends StatelessWidget {
  final String text;
  const WsLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
        letterSpacing: -0.1,
      ),
    );
  }
}