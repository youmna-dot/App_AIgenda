// // lib/features/workspace/presentation/widgets/workspaces_screen_widgets/ws_header.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../../../core/constants/app_colors.dart';
// import '../../../../../core/constants/app_values.dart';

// class WsHeader extends StatelessWidget {
//   const WsHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(
//         AppValues.paddingLg,
//         AppValues.paddingLg,
//         AppValues.paddingLg,
//         AppValues.paddingXs,
//       ),
//       child: Row(
//         children: [
//           _WsBackButton(onTap: () => context.pop()),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Workspaces',
//                   style: GoogleFonts.poppins(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textDark,
//                   ),
//                 ),
//                 Text(
//                   'Your projects & teams',
//                   style: GoogleFonts.poppins(
//                     fontSize: 12,
//                     color: AppColors.textMuted,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _WsBackButton extends StatelessWidget {
//   final VoidCallback onTap;
//   const _WsBackButton({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(AppValues.radiusSm),
//           border: Border.all(color: AppColors.cardBorder),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primary.withOpacity(0.07),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: const Icon(
//           Icons.arrow_back_ios_new_rounded,
//           color: AppColors.primary,
//           size: 18,
//         ),
//       ),
//     );
//   }
// }