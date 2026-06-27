
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_values.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutline = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // لو isLoading بـ true، نمنع الضغط عن طريق تمرير null
      onTap: (isLoading || onPressed == null) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: width ?? double.infinity,
        height: AppValues.buttonHeight,
        decoration: _buildDecoration(),
        alignment: Alignment.center,
        child: isLoading
            ? _buildLoadingIndicator()
            : Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // لو Outline نخلي النص باللون الأساسي، لو Filled نخليه أبيض
            color: isOutline ? AppColors.primary : AppColors.white,
          ),
        ),
      ),
    );
  }

  // ميثود مساعدة لتنظيم الكود (Decoration)
  BoxDecoration _buildDecoration() {
    if (isOutline) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.radiusLg),
        color: AppColors.white, // خلفية بيضاء للـ Outline
        border: Border.all(color: AppColors.primary, width: 1.5),
      );
    }

    return BoxDecoration(
      gradient: isLoading ? null : AppColors.primaryGradient,
      color: isLoading ? AppColors.grey : null, // لون باهت أثناء التحميل
      borderRadius: BorderRadius.circular(AppValues.radiusLg),
      boxShadow: isLoading ? [] : [
        BoxShadow(
          color: AppColors.gradientPurple.withOpacity(0.3),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ويدجت التحميل
  Widget _buildLoadingIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
      ),
    );
  }
}




enum AppButtonType { primary, secondary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final AppButtonType type;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.icon,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final bg = switch (type) {
      AppButtonType.primary   => AppColors.primary,
      AppButtonType.secondary => Colors.transparent,
      AppButtonType.danger    => AppColors.error,
    };
    final fg = switch (type) {
      AppButtonType.secondary => AppColors.textSecondary,
      _                       => Colors.white,
    };
    final border = type == AppButtonType.secondary
        ? Border.all(color: AppColors.cardBorder)
        : null;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: (isLoading || onTap == null)
              ? AppColors.grey
              : bg,
          borderRadius: BorderRadius.circular(14),
          border: border,
          boxShadow: (type == AppButtonType.primary && !isLoading)
              ? [BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6))]
              : null,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
              width: 22, height: 22,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: Colors.white))
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: fg, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}