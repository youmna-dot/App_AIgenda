import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {

  // ── Splash & Onboarding ──────────────────────────────────
  static final TextStyle splashTitle = GoogleFonts.outfit(
    fontSize: 46,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: 7,
    height: 1,
  );

  static final TextStyle taglineAr = GoogleFonts.cairo(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    height: 1.5,
  );

  static final TextStyle taglineEn = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final TextStyle buttonTextPrimary = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  // ── Auth & Links ─────────────────────────────────────────
  static final TextStyle authLink = GoogleFonts.outfit(
    fontSize: 13,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );

  static final TextStyle hintStyle = GoogleFonts.outfit(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  // ── Logo ─────────────────────────────────────────────────
  static final TextStyle logoText = GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    letterSpacing: 4,
  );

  // ── Auth Titles ──────────────────────────────────────────
  static final TextStyle authTitle = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static final TextStyle authSubtitle = GoogleFonts.outfit(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  static final TextStyle authInstruction = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.instructionPink,
    height: 1.5,
  );

  static final TextStyle authCardTitle = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ── Labels ───────────────────────────────────────────────
  static final TextStyle fieldLabel = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
  );

  // ── Headlines ────────────────────────────────────────────
  static final TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static final TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle titleMedium = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ── Body ─────────────────────────────────────────────────
  static final TextStyle bodyRegular = GoogleFonts.outfit(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static final TextStyle bodyMedium = GoogleFonts.outfit(
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle bodySmall = GoogleFonts.outfit(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  // ── Buttons ──────────────────────────────────────────────
  static final TextStyle buttonText = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  // ── Links ────────────────────────────────────────────────
  static final TextStyle link = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );

  // ── Profile ──────────────────────────────────────────────

  static final TextStyle profileName = GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  /// Job title تحت الاسم   "Senior Product Designer"
  static final TextStyle profileJobTitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.wsSubtext,
  );

  /// الإيميل تحت الـ job title
  static final TextStyle profileEmail = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  /// عنوان section  "Personal Information"
  static final TextStyle profileSectionTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.wsHeading,
  );

  /// label فوق الـ field في كارد الـ personal info  "FIRST NAME"
  static final TextStyle profileInfoLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.8,
  );

  /// قيمة الـ field في كارد الـ personal info  
  static final TextStyle profileInfoValue = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.wsHeading,
  );

  /// قيمة placeholder لما الـ field فاضي 
  static final TextStyle profileInfoPlaceholder = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
  );

  /// رقم الـ stat في كارد الإحصائيات 
  static final TextStyle profileStatCount = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.wsHeading,
  );

  /// label الـ stat  "Tasks"
  static final TextStyle profileStatLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.wsSubtext,
  );

  /// label الـ section في الـ edit screen  e.g. "PERSONAL INFORMATION"
  // static final TextStyle profileEditSectionLabel = GoogleFonts.outfit(
  //   fontSize: 11,
  //   fontWeight: FontWeight.w700,
  //   color: AppColors.textMuted,
  // );

  static final TextStyle profileEditSectionLabel = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.wsHeading,
  );

  /// label فوق الـ input field في الـ edit  "FIRST NAME"
  static final TextStyle profileFieldLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.8,
  );

  /// نص داخل الـ input field
  static final TextStyle profileFieldValue = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.wsHeading,
  );

  /// hint داخل الـ input field
  static final TextStyle profileFieldHint = GoogleFonts.inter(
    fontSize: 14,
    color: AppColors.textHint,
  );

  /// زرار Save Changes
  static final TextStyle profileSaveButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  /// زرار Discard Changes
  static final TextStyle profileDiscardButton = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.wsSubtext,
  );

  /// عنوان الـ logout sheet  "Leaving already?"
  static final TextStyle profileLogoutTitle = GoogleFonts.inter(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.wsHeading,
  );

  /// وصف الـ logout sheet
  static final TextStyle profileLogoutBody = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.wsSubtext,
    height: 1.55,
  );

  /// اسم المستخدم في كارد الـ logout sheet
  static final TextStyle profileLogoutUserName = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.wsHeading,
  );

  /// إيميل المستخدم في كارد الـ logout sheet
  static final TextStyle profileLogoutUserEmail = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.wsSubtext,
  );

  /// زرار Sign Out
  static final TextStyle profileSignOutButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  /// زرار Stay Logged In
  static final TextStyle profileStayButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// label الـ action row   "Edit Profile"
  static final TextStyle profileActionLabel = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.wsHeading,
  );

  /// label الـ action row الـ destructive  "Sign Out"
  static final TextStyle profileActionLabelDestructive = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );

  /// عنوان الـ Edit Profile screen   "Edit Profile"
  static final TextStyle profileScreenTitle = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.wsHeading,
  );

  /// "Change Photo"
  static final TextStyle profileChangePhotoTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.wsHeading,
  );

  /// "Upload a new profile picture."
  static final TextStyle profileChangePhotoSubtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.wsSubtext,
  );
}

// import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'app_colors.dart';

// class AppTextStyles {

//   // Splash & Onboarding 
//   static final TextStyle splashTitle = GoogleFonts.outfit(
//     fontSize: 46,
//     fontWeight: FontWeight.w800,
//     color: AppColors.white,
//     letterSpacing: 7,
//     height: 1,
//   );

//   static final TextStyle taglineAr = GoogleFonts.cairo(
//     fontSize: 17,
//     fontWeight: FontWeight.w600,
//     color: AppColors.primary,
//     height: 1.5,
//   );

//   static final TextStyle taglineEn = GoogleFonts.outfit(
//     fontSize: 12,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textSecondary,
//     height: 1.5,
//   );

//   static final TextStyle buttonTextPrimary = GoogleFonts.cairo(
//     fontSize: 20,
//     fontWeight: FontWeight.w700,
//     color: Colors.white,
//   );

//   // Auth & Links 
//   static final TextStyle authLink = GoogleFonts.outfit(
//     fontSize: 13,
//     color: AppColors.primary,
//     fontWeight: FontWeight.w600,
//     decoration: TextDecoration.underline,
//   );

//   static final TextStyle hintStyle = GoogleFonts.outfit(
//     fontSize: 13,
//     color: AppColors.textSecondary,
//   );

//   // Logo 
//   static final TextStyle logoText = GoogleFonts.outfit(
//     fontSize: 36,
//     fontWeight: FontWeight.w800,
//     color: AppColors.primary,
//     letterSpacing: 4,
//   );

//   // Auth Titles 
//   static final TextStyle authTitle = GoogleFonts.outfit(
//     fontSize: 32,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textDark,
//     letterSpacing: 0.3,
//     height: 1.2,
//   );

//   static final TextStyle authSubtitle = GoogleFonts.outfit(
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textMuted,
//     height: 1.5,
//   );

//   static final TextStyle authInstruction = GoogleFonts.outfit(
//     fontSize: 13,
//     fontWeight: FontWeight.w400,
//     color: AppColors.instructionPink,
//     height: 1.5,
//   );

//   static final TextStyle authCardTitle = GoogleFonts.outfit(
//     fontSize: 20,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//   );

//   //  Labels 
//   static final TextStyle fieldLabel = GoogleFonts.outfit(
//     fontSize: 13,
//     fontWeight: FontWeight.w500,
//     color: AppColors.textHint,
//   );

//   // Headlines 
//   static final TextStyle headlineLarge = GoogleFonts.outfit(
//     fontSize: 32,
//     fontWeight: FontWeight.w700,
//     color: AppColors.textPrimary,
//     letterSpacing: 0.3,
//   );

//   static final TextStyle headlineMedium = GoogleFonts.outfit(
//     fontSize: 24,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//   );

//   static final TextStyle titleMedium = GoogleFonts.outfit(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//   );

//   // Body
//   static final TextStyle bodyRegular = GoogleFonts.outfit(
//     fontSize: 15,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textSecondary,
//     height: 1.5,
//   );

//   static final TextStyle bodyMedium = GoogleFonts.outfit(
//     fontSize: 13.5,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textSecondary,
//   );

//   static final TextStyle bodySmall = GoogleFonts.outfit(
//     fontSize: 13,
//     fontWeight: FontWeight.w400,
//     color: AppColors.textMuted,
//     height: 1.5,
//   );

//   // Buttons
//   static final TextStyle buttonText = GoogleFonts.outfit(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     color: AppColors.white,
//     letterSpacing: 0.3,
//   );

//   // Links 
//   static final TextStyle link = GoogleFonts.outfit(
//     fontSize: 13,
//     fontWeight: FontWeight.w600,
//     color: AppColors.primary,
//     decoration: TextDecoration.underline,
//     decorationColor: AppColors.primary,
//   );
// }