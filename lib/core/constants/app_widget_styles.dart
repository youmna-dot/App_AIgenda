import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_values.dart';

class AppWidgetStyles {
  // Cards
  static BoxDecoration glassCard({double? radius}) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.white.withOpacity(0.55),
        AppColors.white.withOpacity(0.35),
      ],
    ),
    borderRadius: BorderRadius.circular(radius ?? AppValues.radiusCard),
    border: Border.all(color: AppColors.white.withOpacity(0.6), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.08),
        blurRadius: 32,
        offset: const Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration regularCard = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Gradient Button
  static BoxDecoration gradientButton = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    boxShadow: [
      BoxShadow(
        color: AppColors.gradientPurple.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  );

  //  Outline Button
  static BoxDecoration outlineButton = BoxDecoration(
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    gradient: LinearGradient(
      colors: [
        AppColors.gradientBlue.withOpacity(0.12),
        AppColors.gradientPurple.withOpacity(0.12),
      ],
    ),
    border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5),
  );

  // Social Button
  static BoxDecoration socialButton = BoxDecoration(
    borderRadius: BorderRadius.circular(AppValues.radiusLg),
    color: AppColors.white.withOpacity(0.1),
    border: Border.all(color: AppColors.white.withOpacity(0.15)),
  );

  //  Icon Container
  static BoxDecoration iconContainer = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(AppValues.radiusIcon),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
  static List<BoxShadow> glow(
      Color color, {
        double opacity = 0.35,
        double blur = 18,
      }) =>
      [
        // Primary glow (colored)
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: blur,
          spreadRadius: 0,
          offset: const Offset(0, 6),
        ),
        // Base subtle shadow (neutral, depth)
        BoxShadow(
          color: color.withOpacity(0.10),
          blurRadius: blur / 3,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  // Pill Tab Bar Container
  static BoxDecoration pillTabContainer(Color accentColor) => BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(AppValues.pillRadius),
    border: Border.all(
      color: accentColor.withOpacity(0.06),
      width: 1.0,
    ),
    boxShadow: [
      // Accent-tinted glow (gives it personality)
      BoxShadow(
        color: accentColor.withOpacity(0.08),
        blurRadius: 20,
        spreadRadius: 0,
        offset: const Offset(0, 6),
      ),
      // Neutral base shadow (depth)
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        spreadRadius: 0,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Pill Tab Active Indicator
  static BoxDecoration pillTabIndicator(Color color) => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        color,
        Color.lerp(color, AppColors.gradientBlue, 0.25) ?? color,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(AppValues.pillRadius),
    boxShadow: glow(color, opacity: 0.30, blur: 12),
  );


  // CTA Button (Add Task / Add Note)

  static BoxDecoration ctaButton(Color accentColor) => BoxDecoration(
    gradient: LinearGradient(
      colors: [
        accentColor,
        Color.lerp(accentColor, AppColors.gradientBlue, 0.18) ?? accentColor,
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(AppValues.pillRadius),
    boxShadow: glow(accentColor, opacity: 0.38, blur: 20),
  );
}



