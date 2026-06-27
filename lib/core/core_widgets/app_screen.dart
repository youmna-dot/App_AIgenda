import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? fab;
  final List<Widget>? actions;
  final bool showBack;
  final Widget? bottomBar;

  const AppScreen({
    super.key,
    required this.title,
    this.subtitle,
    required this.body,
    this.fab,
    this.actions,
    this.showBack = true,
    this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: bottomBar,
      floatingActionButton: fab,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(
              title: title,
              subtitle: subtitle,
              showBack: showBack,
              actions: actions,
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final List<Widget>? actions;

  const _AppBar({
    required this.title,
    this.subtitle,
    required this.showBack,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          if (showBack) ...[
            GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.primary, size: 17),
              ),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        letterSpacing: -0.3)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}