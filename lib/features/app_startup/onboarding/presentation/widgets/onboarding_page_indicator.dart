// lib/features/app_startup/onboarding/presentation/widgets/onboarding_page_indicator.dart
 
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
 
class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;
 
  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 28 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.appPurpleLight : AppColors.textHint,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../../../../core/constants/app_colors.dart';

// class OnboardingIndicator extends StatelessWidget {
//   final int currentIndex;
//   final int length;

//   const OnboardingIndicator({
//     super.key,
//     required this.currentIndex,
//     required this.length,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(
//         length,
//         (index) => AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           margin: const EdgeInsets.symmetric(horizontal: 4.0),
//           height: 8,
//           width: currentIndex == index ? 24 : 8,
//           decoration: BoxDecoration(
//             color: currentIndex == index
//                 ? AppColors.primary
//                 : AppColors.textHint,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ),
//       ),
//     );
//   }
// }
