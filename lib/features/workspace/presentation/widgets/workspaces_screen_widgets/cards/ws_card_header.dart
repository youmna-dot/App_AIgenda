// // lib/features/workspace/presentation/widgets/workspaces_screen_widgets/cards/ws_card_header.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../../../core/constants/app_colors.dart';
// import '../../../../../../core/constants/app_values.dart';

// class WsCardHeader extends StatelessWidget {
//   final Color color;
//   final String emoji;
//   final bool isOwner;
//   final VoidCallback onMoreTap;

//   const WsCardHeader({
//     super.key,
//     required this.color,
//     required this.emoji,
//     required this.isOwner,
//     required this.onMoreTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 55,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Stack(
//         children: [
//           Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
//           Positioned(
//             top: 8,
//             right: 8,
//             child: GestureDetector(
//               onTap: onMoreTap,
//               behavior: HitTestBehavior.opaque,
//               child: Container(
//                 width: 28,
//                 height: 28,
//                 decoration: BoxDecoration(
//                   color: AppColors.white.withOpacity(0.9),
//                   borderRadius: BorderRadius.circular(AppValues.paddingXs),
//                 ),
//                 child: Icon(Icons.more_horiz_rounded, color: color, size: 16),
//               ),
//             ),
//           ),
//           if (isOwner)
//             Positioned(
//               top: 8,
//               left: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   'Owner',
//                   style: GoogleFonts.poppins(
//                     fontSize: 9,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }