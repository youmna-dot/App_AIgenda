// lib/features/settings/presentation/screens/password_security_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_icons.dart';
import '../../../../../core/constants/app_values.dart';
import '../widgets/settings_app_bar.dart';

class PasswordSecurityScreen extends StatelessWidget {
  const PasswordSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            // Title says "Settings" (breadcrumb behaviour — matches original)
            SettingsAppBar(title: 'Settings', onBack: () => context.pop()),
            const Divider(height: 1, color: AppColors.cardBorder),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.horizontalPadding,
                  vertical: AppValues.paddingXl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title block ──
                    Text(
                      'Password & Security',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.wsHeading,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage your account credentials and security preferences.',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: AppColors.wsSubtext,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── Options card ──
                    _SecurityOptionsCard(
                      items: [
                        _SecurityItem(
                          icon: AppIcons.email,
                          iconBgColor: const Color(0xFFDCE8FF),
                          iconColor: const Color(0xFF3B5BDB),
                          title: 'Change Email',
                          subtitle: 'Update your account email',
                          onTap: () => context.push(RouteNames.changeEmail),
                        ),
                        _SecurityItem(
                          icon: AppIcons.lockFilled,
                          iconBgColor: const Color(0xFFFFEBD6),
                          iconColor: const Color(0xFFE8820C),
                          title: 'Change Password',
                          subtitle: 'Update your password securely',
                          onTap: () => context.push(RouteNames.changePassword),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── Info banner ──
                    const _AccountProtectionBanner(),
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
// Options Card
// ─────────────────────────────────────────────
class _SecurityOptionsCard extends StatelessWidget {
  final List<_SecurityItem> items;

  const _SecurityOptionsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SecurityTile(item: items[i]),
            if (i < items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.primary.withOpacity(0.06),
                indent: 72,
              ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Data class
// ─────────────────────────────────────────────
class _SecurityItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

// ─────────────────────────────────────────────
// Tile
// ─────────────────────────────────────────────
class _SecurityTile extends StatelessWidget {
  final _SecurityItem item;

  const _SecurityTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: AppValues.paddingMd,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: item.iconBgColor,
                borderRadius: BorderRadius.circular(AppValues.radiusMd),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 22),
            ),
            const SizedBox(width: AppValues.paddingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.wsHeading,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: AppColors.wsSubtext,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.wsSubtext,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Protection Banner
// ─────────────────────────────────────────────
class _AccountProtectionBanner extends StatelessWidget {
  const _AccountProtectionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppValues.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppValues.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'ACCOUNT PROTECTION',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'We recommend using a strong, unique password and updating it regularly to keep your account data safe from unauthorized access.',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.wsHeading,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}