// lib/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/settings_appearance_toggle.dart';
import '../widgets/settings_badge.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_tile.dart';

// ─────────────────────────────────────────────
// Language Enum
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

  String get storageKey => switch (this) {
        AppLanguage.english => 'english',
        AppLanguage.arabic => 'arabic',
      };

  static AppLanguage fromStorageKey(String key) =>
      key == 'arabic' ? AppLanguage.arabic : AppLanguage.english;
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLightMode        = true;
  bool _pushNotifications  = true;
  bool _emailNotifications = false;
  bool _smartReminders     = true;
  bool _aiTaskGeneration   = true;
  AppLanguage _language    = AppLanguage.english;

  static const _kLanguageKey = 'app_language';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs  = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kLanguageKey) ?? 'english';
    if (mounted) {
      setState(() => _language = AppLanguageExt.fromStorageKey(stored));
    }
  }

  Future<void> _saveLanguage(AppLanguage lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguageKey, lang.storageKey);
  }

  Future<void> _openLanguageSheet() async {
    final result = await showModalBottomSheet<AppLanguage>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguageBottomSheet(current: _language),
    );
    if (result != null && result != _language) {
      setState(() => _language = result);
      await _saveLanguage(result);
    }
  }

  Widget _buildSwitch(bool value, ValueChanged<bool> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.white,
      activeTrackColor: AppColors.primary,
      inactiveThumbColor: AppColors.white,
      inactiveTrackColor: AppColors.cardBorder,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SettingsAppBar(title: 'Settings', onBack: () => context.pop()),
            const Divider(height: 1, color: AppColors.cardBorder),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.horizontalPadding,
                  vertical: AppValues.paddingLg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── GENERAL ──────────────────────────────
                    SettingsSection(
                      label: 'General',
                      tiles: [
                        SettingsTile(
                          icon: AppIcons.language,
                          iconBgColor: const Color(0xFFE8F4FF),
                          iconColor: const Color(0xFF3B82F6),
                          title: 'Language',
                          subtitle: _language.displayName,
                          onTap: _openLanguageSheet,
                        ),
                        SettingsTile(
                          icon: AppIcons.brightness,
                          iconBgColor: const Color(0xFFF0EBFF),
                          iconColor: AppColors.primary,
                          title: 'Appearance',
                          showChevron: false,
                          trailing: AppearanceToggle(
                            isLight: _isLightMode,
                            onChanged: (v) => setState(() => _isLightMode = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── NOTIFICATIONS ─────────────────────────
                    SettingsSection(
                      label: 'Notifications',
                      tiles: [
                        SettingsTile(
                          icon: AppIcons.notifications,
                          iconBgColor: const Color(0xFFFFF3E8),
                          iconColor: AppColors.ownerOrange,
                          title: 'Push Notifications',
                          showChevron: false,
                          trailing: _buildSwitch(
                            _pushNotifications,
                            (v) => setState(() => _pushNotifications = v),
                          ),
                        ),
                        SettingsTile(
                          icon: AppIcons.email,
                          iconBgColor: const Color(0xFFFFF3E8),
                          iconColor: AppColors.ownerOrange,
                          title: 'Email Notifications',
                          showChevron: false,
                          trailing: _buildSwitch(
                            _emailNotifications,
                            (v) => setState(() => _emailNotifications = v),
                          ),
                        ),
                        SettingsTile(
                          icon: AppIcons.calendar,
                          iconBgColor: const Color(0xFFFFF3E8),
                          iconColor: AppColors.ownerOrange,
                          title: 'Smart Reminders',
                          showChevron: false,
                          trailing: _buildSwitch(
                            _smartReminders,
                            (v) => setState(() => _smartReminders = v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── ACCOUNT & SECURITY ────────────────────
                    SettingsSection(
                      label: 'Account & Security',
                      tiles: [
                        SettingsTile(
                          icon: AppIcons.lockFilled,
                          iconBgColor: const Color(0xFFF0EBFF),
                          iconColor: AppColors.primary,
                          title: 'Password & Security',
                          subtitle: 'Last updated 3 months ago',
                          onTap: () => context.push(RouteNames.passwordSecurity),
                        ),
                        SettingsTile(
                          icon: Icons.devices_rounded,
                          iconBgColor: const Color(0xFFF0EBFF),
                          iconColor: AppColors.primary,
                          title: 'Active Devices',
                          showChevron: false,
                          trailing: const SettingsBadge(
                            label: '2 Active',
                            isPrimary: true,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── AI PREFERENCES ────────────────────────
                    SettingsSection(
                      label: 'AI Preferences',
                      cardColor: const Color(0xFFEDE8FA),
                      tiles: [
                        SettingsTile(
                          icon: Icons.auto_awesome_rounded,
                          iconBgColor: AppColors.primary.withOpacity(0.15),
                          iconColor: AppColors.primary,
                          title: 'AI Task Generation',
                          showChevron: false,
                          trailing: _buildSwitch(
                            _aiTaskGeneration,
                            (v) => setState(() => _aiTaskGeneration = v),
                          ),
                        ),
                        SettingsTile(
                          icon: Icons.psychology_rounded,
                          iconBgColor: AppColors.accentGreen.withOpacity(0.15),
                          iconColor: AppColors.accentGreen,
                          title: 'Default Assistant',
                          showChevron: false,
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── SUPPORT ───────────────────────────────
                    SettingsSection(
                      label: '',
                      tiles: [
                        SettingsTile(
                          icon: Icons.help_outline_rounded,
                          iconBgColor: const Color(0xFFE8F4FF),
                          iconColor: const Color(0xFF3B82F6),
                          title: 'Help Center',
                          onTap: () => context.push(RouteNames.helpCenter),
                        ),
                        SettingsTile(
                          icon: Icons.description_outlined,
                          iconBgColor: const Color(0xFFF0EBFF),
                          iconColor: AppColors.primary,
                          title: 'Terms & Privacy',
                          onTap: () => context.push(RouteNames.termsPrivacy),
                        ),
                        SettingsTile(
                          icon: Icons.info_outline_rounded,
                          iconBgColor: const Color(0xFFFFF3E8),
                          iconColor: const Color(0xFFF97316),
                          title: 'About AIGENDA',
                          onTap: () => context.push(RouteNames.about),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── Footer ────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Version 2.4.1-Platinum',
                            style: GoogleFonts.outfit(
                                fontSize: 12, color: AppColors.wsSubtext),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '© 2026 AIGENDA ByteVerse.',
                            style: GoogleFonts.outfit(
                                fontSize: 12, color: AppColors.wsSubtext),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppValues.paddingLg),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Language Bottom Sheet
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
            style: GoogleFonts.outfit(fontSize: 14, color: AppColors.wsSubtext),
          ),
          const SizedBox(height: AppValues.paddingXl),

          // ── Options ──
          ...AppLanguage.values.map(
            (lang) => _LanguageOption(
              language: lang,
              isSelected: _selected == lang,
              onTap: () => setState(() => _selected = lang),
            ),
          ),

          const SizedBox(height: AppValues.paddingXl),
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
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
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
                      color: language == AppLanguage.english
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
                  ? const Icon(Icons.check_rounded,
                      color: AppColors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}