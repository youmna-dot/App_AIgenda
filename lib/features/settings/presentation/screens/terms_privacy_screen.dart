// lib/features/settings/presentation/screens/terms_privacy_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../widgets/last_updated_label.dart';
import '../widgets/legal_section.dart';
import '../widgets/settings_app_bar.dart';
import '../widgets/terms_privacy_tab.dart';

class TermsPrivacyScreen extends StatefulWidget {
  const TermsPrivacyScreen({super.key});

  @override
  State<TermsPrivacyScreen> createState() => _TermsPrivacyScreenState();
}

class _TermsPrivacyScreenState extends State<TermsPrivacyScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SettingsAppBar(
              title: 'Terms & Privacy',
              onBack: () => context.pop(),
            ),
            const Divider(height: 1, color: AppColors.cardBorder),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppValues.horizontalPadding,
                AppValues.paddingMd,
                AppValues.horizontalPadding,
                0,
              ),
              child: Container(
                height: AppValues.tabBarHeight,
                padding: const EdgeInsets.all(AppValues.tabBarInnerPadding),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppValues.radiusMd),
                ),
                child: Row(
                  children: [
                    TermsPrivacyTab(
                      label: 'Terms of Use',
                      isSelected: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                    TermsPrivacyTab(
                      label: 'Privacy Policy',
                      isSelected: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppValues.paddingMd),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppValues.horizontalPadding,
                  vertical: AppValues.paddingSm,
                ),
                child: _selectedTab == 0
                    ? const _TermsContent()
                    : const _PrivacyContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LastUpdatedLabel('January 1, 2026'),
        SizedBox(height: AppValues.paddingMd),
        LegalSection(
          title: '1. Acceptance of Terms',
          body: 'By downloading, installing, or using AIGENDA, you agree to be bound by these Terms of Use. If you do not agree with any part of these terms, you may not use the app.',
        ),
        LegalSection(
          title: '2. Use of the App',
          body: 'AIGENDA is intended for personal and professional productivity use. You agree not to misuse the app, attempt to access unauthorized data, or use the platform for any unlawful purpose.',
        ),
        LegalSection(
          title: '3. Account Responsibility',
          body: 'You are responsible for maintaining the confidentiality of your account credentials. Any activity that occurs under your account is your responsibility. Notify us immediately if you suspect unauthorized access.',
        ),
        LegalSection(
          title: '4. AI Features',
          body: 'AIGENDA includes AI-powered features that process your notes, tasks, and content to provide smart suggestions. These features are designed to assist you and do not replace professional advice.',
        ),
        LegalSection(
          title: '5. Intellectual Property',
          body: 'All content, features, and functionality of AIGENDA — including the design, code, and AI models — are the property of ByteVerse and are protected by applicable intellectual property laws.',
        ),
        LegalSection(
          title: '6. Termination',
          body: 'We reserve the right to suspend or terminate your account if you violate these terms. You may also delete your account at any time through the app settings.',
        ),
        LegalSection(
          title: '7. Changes to Terms',
          body: 'We may update these Terms of Use from time to time. Continued use of the app after changes are made constitutes your acceptance of the revised terms.',
        ),
        LegalSection(
          title: '8. Contact',
          body: 'For questions about these terms, contact us at byteverse7510@gmail.com or through our Facebook page.',
          isLast: true,
        ),
        SizedBox(height: AppValues.paddingXl),
      ],
    );
  }
}

class _PrivacyContent extends StatelessWidget {
  const _PrivacyContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LastUpdatedLabel('January 1, 2026'),
        SizedBox(height: AppValues.paddingMd),
        LegalSection(
          title: '1. Information We Collect',
          body: 'We collect information you provide when creating an account (name, email), content you create within the app (tasks, notes, workspaces), and basic usage data to improve the experience.',
        ),
        LegalSection(
          title: '2. How We Use Your Information',
          body: 'Your data is used to provide and improve the AIGENDA service, personalize your experience, power AI features, and communicate important updates about your account.',
        ),
        LegalSection(
          title: '3. Data Storage & Security',
          body: 'Your data is stored securely on our servers. We use industry-standard encryption and security practices to protect your information from unauthorized access, disclosure, or loss.',
        ),
        LegalSection(
          title: '4. AI & Your Content',
          body: 'Content you create in AIGENDA may be processed by our AI systems to provide smart suggestions and summaries. This processing happens securely and your data is not used to train external AI models.',
        ),
        LegalSection(
          title: '5. Data Sharing',
          body: 'We do not sell your personal data. We may share data with trusted service providers who assist in operating our platform, subject to strict confidentiality agreements.',
        ),
        LegalSection(
          title: '6. Your Rights',
          body: 'You have the right to access, update, or delete your personal data at any time through the app settings. You may also request a copy of your data by contacting us.',
        ),
        LegalSection(
          title: '7. Cookies & Analytics',
          body: 'We may use analytics tools to understand how users interact with the app. This data is collected in aggregate and does not identify you personally.',
        ),
        LegalSection(
          title: '8. Changes to This Policy',
          body: 'We may update this Privacy Policy periodically. We will notify you of significant changes through the app or via email.',
        ),
        LegalSection(
          title: '9. Contact Us',
          body: 'If you have questions about your privacy or this policy, contact us at byteverse7510@gmail.com.',
          isLast: true,
        ),
        SizedBox(height: AppValues.paddingXl),
      ],
    );
  }
}