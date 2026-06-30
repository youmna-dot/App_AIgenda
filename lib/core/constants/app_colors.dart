// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // ── Base ──────────────────────────────────────────────────────
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ── App Purple (main gradient) ────────────────────────────────
  static const Color appPurpleLight = Color(0xFF7A4FFF);
  static const Color appPurpleDark  = Color.fromARGB(255, 27, 12, 68);

  static const LinearGradient appPurpleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [appPurpleLight, appPurpleDark],
  );

  // ── Semantic accents ──────────────────────────────────────────
  static const Color surface      = Color(0xFFF8F7FF);
  static const Color borderLight  = Color(0xFFE8E4FF);
  static const Color accentRed    = Color(0xFFEF4444);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentGreen  = Color(0xFF1D9E75);

  // ── Brand gradient colours ────────────────────────────────────
  static const Color gradientBlue   = Color(0xFF4A90E2);
  static const Color gradientPurple = Color(0xFF6C4AB6);
  static const Color gradientLight  = Color(0xFF9D7BDB);

  // ── Primary (alias for gradientPurple) ────────────────────────
  static const Color primary = gradientPurple;

  // ── Backgrounds ───────────────────────────────────────────────
  static const Color background     = Color(0xFFF7F5FF);
  static const Color cardBackground = Color(0xFFFBFAFF);
  static const Color cardBorder     = Color(0xFFE6E1F2);

  // ── Text ──────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1F1147);
  static const Color textSecondary = Color(0xFF5C4E8C);
  static const Color textMuted     = Color(0xFF9A8CC3);
  static const Color textDark      = Color(0xFF140B3D);
  static const Color textHint      = Color(0xFFB8A9D6);

  // ── Status ────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color error   = Color(0xFFEF4444);
  static const Color warning = Color(0xFFFF9800); // kept consistent with old AppColors
  static const Color grey    = Color(0xFFB0A4C8);

  // ── Misc ──────────────────────────────────────────────────────
  static const Color instructionPink = Color(0xFFE11D8E);

  // ── Gradients ─────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientBlue, gradientPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF4F1FF),
      Color(0xFFF8FBFF),
      Color(0xFFF6F2FF),
    ],
  );

  // ── Workspace / Profile UI colours ───────────────────────────
  static const Color wsHeading   = Color(0xFF1A1035);
  static const Color wsSubtext   = Color(0xFF6B6880);
  static const Color wsFieldBg   = Color(0xFFF8F7FF);
  static const Color wsCancelBg  = Color(0xFFF5F3FF);
  static const Color wsHandleBar = Color(0xFFE0DCF0);
  static const Color roleViewer  = Color(0xFF6B7280);
  static const Color roleCustom  = Color(0xFF7C3AED);

  // ── Action backgrounds ────────────────────────────────────────
  static const Color actionBgBlue   = Color(0xFFE6F4FF);
  static const Color actionBgEdit   = Color(0xFFE8F2FE);
  static const Color actionBgGreen  = Color(0xFFE8FFF0);
  static const Color actionBgRed    = Color(0xFFFEECEC);
  static const Color actionBgOrange = Color(0xFFFEF3CD);

  // ── Owner badge ───────────────────────────────────────────────
  static const Color ownerGold       = Color(0xFFFFD700);
  static const Color ownerOrange     = Color(0xFFFF9500);
  static const Color ownerGoldShadow = Color(0xFFFFB300);

  // ── Members screen ────────────────────────────────────────────
  static const Color membersBackground = Color(0xFFF4F2FA);

  // ── Avatar gradients ──────────────────────────────────────────
  static const Color teal    = Color(0xFF0D9488);
  static const Color skyBlue = Color(0xFF0EA5E9);
  static const Color emerald = Color(0xFF059669);

  // ── Misc UI ───────────────────────────────────────────────────
  static const Color primaryLight = Color(0xFFF0EBFF);
  static const Color dividerLight = Color(0xFFF5F3FF);
}

// import 'package:flutter/material.dart';

// class AppColors {
//   // ── Base ──
//   static const Color white = Colors.white;
//   static const Color black = Colors.black;
//   // Main App Purple
//   static const Color appPurpleLight = Color(0xFF7A4FFF);
//   static const Color appPurpleDark  = Color.fromARGB(255, 27, 12, 68);

//   static const LinearGradient appPurpleGradient = LinearGradient(
//     begin: Alignment.centerLeft,
//     end: Alignment.centerRight,
//     colors: [
//       appPurpleLight,
//       appPurpleDark,
//     ],
//   );

//   static const Color surface = Color(0xFFF8F7FF);  
//   static const Color borderLight = Color(0xFFE8E4FF);
//   static const Color accentRed = Color(0xFFEF4444);
//   static const Color accentOrange = Color(0xFFF59E0B);
//   static const Color accentGreen = Color(0xFF1D9E75);

//   // ── Brand Gradient ──
//   static const Color gradientBlue   = Color(0xFF4A90E2); // أنقى
//   static const Color gradientPurple = Color(0xFF6C4AB6); // أقل حِدّة
//   static const Color gradientLight  = Color(0xFF9D7BDB); // أفتح ومتوازن

//   // ── Primary (alias للـ gradientPurple) ──
//   static const Color primary = gradientPurple;

//   // ── Backgrounds ──
//   static const Color background     = Color(0xFFF7F5FF); // أهدى للعين
//   static const Color cardBackground = Color(0xFFFBFAFF); // أبيض مكسور نظيف
//   static const Color cardBorder     = Color(0xFFE6E1F2); // subtle border

//   // ── Text ──
//   static const Color textPrimary   = Color(0xFF1F1147); // contrast عالي
//   static const Color textSecondary = Color(0xFF5C4E8C);
//   static const Color textMuted     = Color(0xFF9A8CC3);
//   static const Color textDark      = Color(0xFF140B3D); // أغمق فعليًا
//   static const Color textHint      = Color(0xFFB8A9D6);

//   // ── Status ──
//   static const Color success = Color(0xFF22C55E); // modern green
//   static const Color error   = Color(0xFFEF4444); // أوضح
//   static const Color warning = Color(0xFFF59E0B); // متوازن
//   static const Color grey    = Color(0xFFB0A4C8); // neutral حقيقي

//   // ── Social / Accent ──
//   static const Color instructionPink = Color(0xFFE11D8E); // خليها Accent

//   // ── Gradient Helper ──
//   static const LinearGradient primaryGradient = LinearGradient(
//     colors: [gradientBlue, gradientPurple],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   static const LinearGradient backgroundGradient = LinearGradient(
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//     colors: [
//       Color(0xFFF4F1FF),
//       Color(0xFFF8FBFF),
//       Color(0xFFF6F2FF),
//     ],
//   );
//   static const Color wsHeading = Color(0xFF1A1035);
//   static const Color wsSubtext = Color(0xFF6B6880);
//   static const Color wsFieldBg = Color(0xFFF8F7FF);
//   static const Color wsCancelBg = Color(0xFFF5F3FF);
//   static const Color wsHandleBar = Color(0xFFE0DCF0);
//   static const Color roleViewer = Color(0xFF6B7280);
//   static const Color _roleEditorAlias = gradientBlue;
//   static const Color _roleAdminAlias = accentGreen;
//   static const Color roleCustom = Color(0xFF7C3AED);
//   static const Color actionBgBlue   = Color(0xFFE6F4FF);
//   static const Color actionBgEdit   = Color(0xFFE8F2FE);
//   static const Color actionBgGreen  = Color(0xFFE8FFF0);
//   static const Color actionBgRed    = Color(0xFFFEECEC);
//   static const Color actionBgOrange = Color(0xFFFEF3CD);

//   //owner badge gradient
//   static const Color ownerGold       = Color(0xFFFFD700);
//   static const Color ownerOrange     = Color(0xFFFF9500);
//   static const Color ownerGoldShadow = Color(0xFFFFB300);

//   //members screen background
//   static const Color membersBackground = Color(0xFFF4F2FA);

//   //Avatar gradients
//   static const Color teal    = Color(0xFF0D9488);
//   static const Color skyBlue = Color(0xFF0EA5E9);
//   static const Color emerald = Color(0xFF059669);

//   // Viewer banner background
//   static const Color primaryLight = Color(0xFFF0EBFF);

//   // Divider inside permission group cards
//   static const Color dividerLight = Color(0xFFF5F3FF);



// }



/*
class AppColors {
  // ── Base ──
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // ── Brand Gradient ──
  static const Color gradientBlue   = Color(0xFF4A90D9);
  static const Color gradientPurple = Color(0xFF7B5EA7);
  static const Color gradientLight  = Color(0xFF9B6FD4);

  // ── Primary (alias للـ gradientPurple) ──
  static const Color primary = Color(0xFF7B5EA7);

  // ── Backgrounds ──
  static const Color background     = Color(0xFFF5F0FF);
  static const Color cardBackground = Color(0xFFF8F5FF);
  static const Color cardBorder     = Color(0xFFE9E3F5);

  // ── Text ──
  static const Color textPrimary   = Color(0xFF3D2B6B);
  static const Color textSecondary = Color(0xFF6B5A9E);
  static const Color textMuted     = Color(0xFF9E86C8);
  static const Color textDark      = Color(0xFF2D1B5E);
  static const Color textHint      = Color(0xFFB8A6D9);

  // ── Status ──
  static const Color success = Color(0xFF4CAF50);
  static const Color error   = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color grey    = Color(0xFF9E86C8);

  // ── Social ──
  static const Color instructionPink = Color(0xFFE11D8E);

  // ── Gradient Helper ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientBlue, gradientPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF0EBFF),
      Color(0xFFE8F0FF),
      Color(0xFFF5EEFF),
    ],
  );
}*/

