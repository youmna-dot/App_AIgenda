// lib/core/widgets/primary_button.dart
//
// ══════════════════════════════════════════════════════════════
// PrimaryButton — الزرار الرئيسي للأبلكيشن كله
// gradient: appPurpleGradient | shape: pill | scale animation
// ══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final Widget? trailingWidget;
  final Widget? leadingWidget;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 54,
    this.trailingWidget,
    this.leadingWidget,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _press.forward(),
      onTapUp: (_) {
        _press.reverse();
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => _press.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isLoading
                ? LinearGradient(
                    colors: [
                      AppColors.appPurpleLight.withOpacity(0.5),
                      AppColors.appPurpleDark.withOpacity(0.5),
                    ],
                  )
                : AppColors.appPurpleGradient,
            borderRadius: BorderRadius.circular(AppValues.pillRadius),
            boxShadow: widget.isLoading
                ? []
                : [
                    BoxShadow(
                      color: AppColors.appPurpleDark.withOpacity(0.30),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.leadingWidget != null) ...[
                      widget.leadingWidget!,
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.text,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (widget.trailingWidget != null) ...[
                      const SizedBox(width: 10),
                      widget.trailingWidget!,
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}