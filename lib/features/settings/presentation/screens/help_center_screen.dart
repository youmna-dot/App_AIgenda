// lib/features/settings/presentation/screens/help_center_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../widgets/settings_app_bar.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static const _faqs = [
    (
      q: 'What is AIGENDA?',
      a: 'AIGENDA is an AI-powered productivity app that helps you organize your workspaces, tasks, notes, and ideas — all in one place.',
    ),
    (
      q: 'How do I create a workspace?',
      a: 'Go to the Workspaces tab and tap the "+" button. Give your workspace a name, choose an icon, and invite your team members.',
    ),
    (
      q: 'Can I invite teammates to my workspace?',
      a: 'Yes! Open any workspace, go to Members, and tap "Invite". You can assign roles like Viewer, Editor, or Admin.',
    ),
    (
      q: 'How do I change my email or password?',
      a: 'Go to Profile → Settings → Password & Security to change your password, or tap "Change Email" to update your email address.',
    ),
    (
      q: 'What happens to my data if I sign out?',
      a: 'Your data stays safely synced to the cloud. You can sign back in anytime and everything will be right where you left it.',
    ),
    (
      q: 'How does the AI assistant work?',
      a: 'The AI assistant can summarize notes, create tasks from your ideas, and help you connect information across your workspaces. Just tap the AI button to get started.',
    ),
    (
      q: 'Is AIGENDA free to use?',
      a: 'Yes! AIGENDA is free forever. No credit card required.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SettingsAppBar(title: 'Help Center', onBack: () => context.pop()),
            const Divider(height: 1, color: AppColors.cardBorder),

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
                    // ── Header ──
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.help_outline_rounded,
                              color: AppColors.primary,
                              size: 36,
                            ),
                          ),
                          const SizedBox(height: AppValues.paddingSm),
                          Text(
                            'How can we help?',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.wsHeading,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find answers to common questions below.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.wsSubtext,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── FAQ section ──
                    _SectionLabel('FREQUENTLY ASKED QUESTIONS'),
                    const SizedBox(height: AppValues.paddingSm),
                    _listCard(
                      children: List.generate(_faqs.length, (i) {
                        final faq = _faqs[i];
                        return Column(
                          children: [
                            _FaqTile(question: faq.q, answer: faq.a),
                            if (i < _faqs.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.dividerLight,
                                indent: 16,
                                endIndent: 16,
                              ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(height: AppValues.paddingXl),

                    // ── Contact section ──
                    _SectionLabel('STILL NEED HELP?'),
                    const SizedBox(height: AppValues.paddingSm),
                    _listCard(
                      children: [
                        _ContactTile(
                          icon: Icons.email_outlined,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.primary.withOpacity(0.08),
                          label: 'Email Support',
                          subtitle: 'byteverse7510@gmail.com',
                          onTap: () => _launchUrl('mailto:byteverse7510@gmail.com'),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.dividerLight,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _ContactTile(
                          icon: Icons.facebook_rounded,
                          iconColor: const Color(0xFF1877F2),
                          iconBg: const Color(0xFFE7F0FF),
                          label: 'Facebook Page',
                          subtitle: 'ByteVerse',
                          onTap: () => _launchUrl('https://www.facebook.com/ByteVerse7510'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppValues.paddingXl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// White card wrapper with shadow — shared between FAQ and Contact lists.
  Widget _listCard({required List<Widget> children}) {
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
      child: Column(children: children),
    );
  }
}

// ── Section label ───────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 1.0,
      ),
    );
  }
}

// ── FAQ Tile (expandable) ───────────────────────────────────────
class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: AppValues.paddingSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.wsHeading,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: AppValues.animFast,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: AppValues.animFast,
              curve: Curves.easeInOut,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.answer,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.wsSubtext,
                          height: 1.6,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Contact Tile ────────────────────────────────────────────────
class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.paddingMd,
          vertical: AppValues.paddingSm + 2,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppValues.radiusSm),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppValues.paddingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.wsHeading,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
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