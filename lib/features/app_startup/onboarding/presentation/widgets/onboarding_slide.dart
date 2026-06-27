// lib/features/app_startup/onboarding/presentation/widgets/onboarding_slide.dart
 
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../data/models/onboarding_model.dart';
 
class OnboardingSlide extends StatelessWidget {
  final OnboardingModel dataModel;
 
  const OnboardingSlide({super.key, required this.dataModel});
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
 
    return Column(
      children: [
        // ── Illustration — no horizontal padding so it can breathe ─
        SizedBox(
          height: size.height * 0.52,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Image.asset(
              dataModel.image,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
 
        const SizedBox(height: 20),
 
        // ── Title + description ────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              Text(
                dataModel.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                  height: 1.25,
                ),
              ),
 
              const SizedBox(height: 12),
 
              Text(
                dataModel.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize:18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appPurpleLight,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../../../../core/constants/app_text_styles.dart';
// import '../../data/models/onboarding_model.dart';

// class OnboardingSlide extends StatefulWidget {
//   final OnboardingModel dataModel;

//   const OnboardingSlide({super.key, required this.dataModel});

//   @override
//   State<OnboardingSlide> createState() => _OnboardingSlideState();
// }

// class _OnboardingSlideState extends State<OnboardingSlide>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           FadeTransition(
//             opacity: _fadeAnimation,
//             child: ScaleTransition(
//               scale: _fadeAnimation,
//               child: Image.asset(
//                 widget.dataModel.image,
//                 height: MediaQuery.of(context).size.height * 0.35,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           const SizedBox(height: 48),

//           SlideTransition(
//             position: _slideAnimation,
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: Column(
//                 children: [
//                   Text(
//                     widget.dataModel.title,
//                     textAlign: TextAlign.center,
//                     style: AppTextStyles.headlineMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     widget.dataModel.description,
//                     textAlign: TextAlign.center,
//                     style: AppTextStyles.bodyRegular,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
