// lib/core/widgets/app_bottom_nav.dart
//
// ══════════════════════════════════════════════════════════════
// AppBottomNav — shared glassmorphic bottom nav bar
//
// الـ tabs:
//   0 → Home
//   1 → Analytics
//   2 → (FAB - AI)
//   3 → Workspaces
//   4 → Profile
// ══════════════════════════════════════════════════════════════

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_values.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onHomeTap;
  final VoidCallback? onAnalyticsTap;
  final VoidCallback? onWorkspacesTap;
  final VoidCallback? onProfileTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onHomeTap,
    this.onAnalyticsTap,
    this.onWorkspacesTap,
    this.onProfileTap,
  });

  static Widget fab({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.appPurpleGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.appPurpleDark.withOpacity(0.50),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      notchMargin: 8,
      shape: const CircularNotchedRectangle(),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            color: AppColors.white.withOpacity(0.75),
            child: SafeArea(
              top: false,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.primary.withOpacity(0.12),
                      width: 0.8,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      isSelected: currentIndex == 0,
                      onTap: () {
                        onTap(0);
                        onHomeTap?.call();
                      },
                    ),
                    _NavItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Analytics',
                      isSelected: currentIndex == 1,
                      onTap: () {
                        onTap(1);
                        onAnalyticsTap?.call();
                      },
                    ),
                    // فراغ الـ FAB
                    const Expanded(child: SizedBox()),
                    _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Workspaces',
                      isSelected: currentIndex == 3,
                      onTap: () {
                        onTap(3);
                        onWorkspacesTap?.call();
                      },
                    ),
                    _NavItem(
                      icon: Icons.person_outline_rounded,
                      label: 'Profile',
                      isSelected: currentIndex == 4,
                      onTap: () {
                        onTap(4);
                        onProfileTap?.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppValues.animFast,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppValues.pillRadius),
              ),
              child: Icon(
                icon,
                size: 27,
                color: isSelected ? AppColors.primary : AppColors.roleViewer,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9.5,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : const Color.fromARGB(255, 35, 28, 57),
              ),
            ),
          ],
        ),
      ),
    );
  }
}