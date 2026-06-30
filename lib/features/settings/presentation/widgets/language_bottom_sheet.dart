// lib/features/settings/presentation/widgets/language_bottom_sheet.dart
//
// ══════════════════════════════════════════════════════════════
// LanguageBottomSheet — Language selector matching the mockup
// يُستدعى من SettingsScreen عند الضغط على Language tile
// ══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/widgets/primary_button.dart';

// ─────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────
enum AppLanguage { english, arabic }

extension AppLanguageExt on AppLanguage {
  String get displayName => switch (this) {
        AppLanguage.english => 'English',
        AppLanguage.arabic => 'العربية',
      };

  String get subtitle => switch (this) {
        AppLanguage.english => 'Recommended',
        AppLanguage.arabic => 'واجهة عربية بالكامل',
      };

  bool get isRecommended => this == AppLanguage.english;
}

// ─────────────────────────────────────────────
// Show helper
// ─────────────────────────────────────────────
Future<AppLanguage?> showLanguageBottomSheet(
  BuildContext context, {
  required AppLanguage current,
}) {
  return showModalBottomSheet<AppLanguage>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _LanguageBottomSheet(current: current),
  );
}

// ─────────────────────────────────────────────
// Sheet Widget
// ─────────────────────────────────────────────
class _LanguageBottomSheet extends StatefulWidget {
  final AppLanguage current;

  const _LanguageBottomSheet({required this.current});

  @override
  State<_LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<_LanguageBottomSheet> {
  late AppLanguage _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppValues.radiusCard),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppValues.horizontalPadding,
        AppValues.paddingSm,
        AppValues.horizontalPadding,
        AppValues.paddingXl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle bar ──
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppValues.paddingLg),
              decoration: BoxDecoration(
                color: AppColors.wsHandleBar,
                borderRadius: BorderRadius.circular(AppValues.pillRadius),
              ),
            ),
          ),

          // ── Header ──
          Row(
            children: [
              const Text('🌐', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AppValues.paddingSm),
              Text(
                'Language',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.wsHeading,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choose your preferred application language.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.wsSubtext,
            ),
          ),
          const SizedBox(height: AppValues.paddingXl),

          // ── Language options ──
          ...AppLanguage.values.map(
            (lang) => _LanguageOption(
              language: lang,
              isSelected: _selected == lang,
              onTap: () => setState(() => _selected = lang),
            ),
          ),

          const SizedBox(height: AppValues.paddingXl),

          // ── Apply button ──
          PrimaryButton(
            text: 'Apply Language',
            onPressed: () => Navigator.of(context).pop(_selected),
          ),

          const SizedBox(height: AppValues.paddingSm),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Language Option Card
// ─────────────────────────────────────────────
class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppValues.animFast,
        margin: const EdgeInsets.only(bottom: AppValues.paddingSm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: AppValues.paddingMd,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.white,
          borderRadius: BorderRadius.circular(AppValues.radiusLg),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.cardBorder,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // ── Text column ──
            Expanded(
              child: Column(
                crossAxisAlignment: language == AppLanguage.arabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    language.displayName,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.wsHeading,
                    ),
                    textDirection: language == AppLanguage.arabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    language.subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: language.isRecommended
                          ? AppColors.primary
                          : AppColors.wsSubtext,
                    ),
                    textDirection: language == AppLanguage.arabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppValues.paddingSm),

            // ── Radio indicator ──
            AnimatedContainer(
              duration: AppValues.animFast,
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.cardBorder,
                  width: 1.8,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}