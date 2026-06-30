// lib/features/settings/presentation/screens/about_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../widgets/card_section_label.dart';
import '../widgets/info_card.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/social_tile.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SettingsAppBar(title: 'About AIGENDA', onBack: () => context.pop()),
            const Divider(height: 1, color: AppColors.cardBorder),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.horizontalPadding,
                  vertical: AppValues.paddingXl,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: AppValues.paddingMd),
                    Text(
                      'AIGENDA',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.wsHeading,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Organize your mind, not just your tasks',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.wsSubtext,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // About card
                    InfoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CardSectionLabel('ABOUT'),
                          const SizedBox(height: 10),
                          Text(
                            'AIGENDA is an AI-powered productivity app designed to help you organize your workspaces, tasks, notes, and ideas — all in one place.\n\n'
                            'Built with a focus on clarity and efficiency, AIGENDA combines smart AI assistance with a clean, intuitive interface to help you stay on top of everything that matters.',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.wsHeading,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppValues.paddingMd),

                    // Team card
                    InfoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CardSectionLabel('BUILT BY'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: AppColors.appPurpleGradient,
                                  borderRadius: BorderRadius.circular(
                                    AppValues.radiusSm,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.code_rounded,
                                  color: AppColors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: AppValues.paddingSm),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ByteVerse',
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.wsHeading,
                                    ),
                                  ),
                                  Text(
                                    'Mansoura University 2026',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.wsSubtext,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppValues.paddingMd),

                    // Social links card
                    InfoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CardSectionLabel('FIND US'),
                          const SizedBox(height: 10),
                          SocialTile(
                            icon: Icons.facebook_rounded,
                            iconColor: const Color(0xFF1877F2),
                            iconBg: const Color(0xFFE7F0FF),
                            label: 'Facebook',
                            subtitle: 'ByteVerse',
                            onTap: () => _launchUrl(
                              'https://www.facebook.com/ByteVerse7510',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    Text(
                      '© 2026 AIGENDA · ByteVerse. All rights reserved.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.wsSubtext,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppValues.paddingMd),
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