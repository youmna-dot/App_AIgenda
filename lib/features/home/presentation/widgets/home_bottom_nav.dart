// // lib/features/home/presentation/widgets/home_bottom_nav.dart

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/constants/app_colors.dart';

// class HomeBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;
//   final VoidCallback? onAiTap;
//   final VoidCallback? onWorkspacesTap;
//   final VoidCallback? onProfileTap;
//   final VoidCallback? onAnalyticsTap;

//   const HomeBottomNav({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//     this.onAiTap,
//     this.onWorkspacesTap,
//     this.onProfileTap,
//     this.onAnalyticsTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.transparent,
//       elevation: 0,
//       padding: EdgeInsets.zero,
//       notchMargin: 8,
//       shape: const CircularNotchedRectangle(),
//       child: ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
//           child: Container(
//             height: 64,
//             decoration: BoxDecoration(
//               // زجاجي بدل أبيض ثابت
//               color: AppColors.white.withOpacity(0.72),
//               border: Border(
//                 top: BorderSide(
//                   color: AppColors.primary.withOpacity(0.13),
//                   width: 0.8,
//                 ),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.primary.withOpacity(0.07),
//                   blurRadius: 20,
//                   offset: const Offset(0, -4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 _NavItem(
//                   icon: Icons.home_rounded,
//                   label: 'Home',
//                   isSelected: currentIndex == 0,
//                   onTap: () => onTap(0),
//                 ),
//                 _NavItem(
//                   icon: Icons.bar_chart_rounded,
//                   label: 'Analytics',
//                   isSelected: currentIndex == 1,
//                   onTap: () {
//                     onTap(1);
//                     onAnalyticsTap?.call();
//                   },
//                 ),
//                 // فراغ الـ FAB
//                 const Expanded(child: SizedBox()),
//                 _NavItem(
//                   icon: Icons.layers_outlined,
//                   label: 'Workspaces',
//                   isSelected: currentIndex == 2,
//                   onTap: () {
//                     onTap(2);
//                     onWorkspacesTap?.call();
//                   },
//                 ),
//                 _NavItem(
//                   icon: Icons.person_outline_rounded,
//                   label: 'Profile',
//                   isSelected: currentIndex == 3,
//                   onTap: () {
//                     onTap(3);
//                     onProfileTap?.call();
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _NavItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const _NavItem({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         behavior: HitTestBehavior.opaque,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 220),
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? AppColors.primary.withOpacity(0.13)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: Icon(
//                 icon,
//                 size: 21,
//                 color: isSelected
//                     ? AppColors.primary
//                     : AppColors.textMuted.withOpacity(0.75),
//               ),
//             ),
//             const SizedBox(height: 2),
//             AnimatedDefaultTextStyle(
//               duration: const Duration(milliseconds: 220),
//               style: GoogleFonts.poppins(
//                 fontSize: 10,
//                 fontWeight:
//                     isSelected ? FontWeight.w700 : FontWeight.w400,
//                 color: isSelected
//                     ? AppColors.primary
//                     : AppColors.textMuted.withOpacity(0.75),
//               ),
//               child: Text(label),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }