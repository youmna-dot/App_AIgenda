// lib/features/app_startup/onboarding/presentation/screens/onboarding_screen.dart
 
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../config/routes/route_names.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_button.dart';
import '../../data/models/onboarding_data.dart';
 
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
 
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
 
class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _pages = OnboardingData.list;
 
  void _goNext() {
    if (_currentPage == _pages.length - 1) {
      context.go(RouteNames.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;
 
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => OnboardingSlide(dataModel: _pages[i]),
              ),
            ),
 
            // ── Bottom section ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dots indicator
                  OnboardingIndicator(
                    currentIndex: _currentPage,
                    length: _pages.length,
                  ),
 
                  const SizedBox(height: 28),
 
                  // next / Get Started button
                  OnboardingButton(
                    text: isLast ? AppStrings.getStarted : AppStrings.next,
                    onPressed: _goNext,
                  ),
 
                  const SizedBox(height: 16),
 
                  // SKIP
                  GestureDetector(
                    onTap: () => context.go(RouteNames.login),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        AppStrings.skip,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}