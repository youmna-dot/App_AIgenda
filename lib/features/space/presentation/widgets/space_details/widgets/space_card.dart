// // lib/features/workspace/presentation/widgets/workspace_dash_widgets/space_card.dart

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../../../core/constants/app_colors.dart';
// import '../../../../../../core/constants/app_values.dart';
// import '../../../../../../core/constants/app_widget_styles.dart';
// import '../../../../data/models/space_model.dart';
// import '../../../../../workspace/presentation/widgets/workspace_dash_widgets/circular_progress_painter.dart';
// import 'space_stat.dart';
// import '../space_actions_sheet.dart';

// class SpaceCard extends StatelessWidget {
//   final SpaceModel space;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//   final VoidCallback? onTap;

//   // [FIX] color بييجي من برا (محلود من SharedPreferences في _DashboardBody)
//   // مش من space.color اللي دايماً hash-based ومش بيتغير
//   final Color spaceColor;

//   const SpaceCard({
//     super.key,
//     required this.space,
//     required this.spaceColor,
//     required this.onEdit,
//     required this.onDelete,
//     this.onTap,
//   });

//   double get _completionRate =>
//       space.totalTasks == 0 ? 0.0 : space.completedTasks / space.totalTasks;

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(AppValues.radiusCard),
//         topRight: Radius.circular(AppValues.radiusLg),
//         bottomLeft: Radius.circular(AppValues.radiusLg),
//         bottomRight: Radius.circular(AppValues.radiusCard),
//       ),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
//         child: GestureDetector(
//           onTap: onTap,
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: AppWidgetStyles.glassCard(
//               radius: AppValues.radiusCard,
//             ).copyWith(
//               boxShadow: [
//                 BoxShadow(
//                   color: spaceColor.withOpacity(0.22),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // Icon
//                 Container(
//                   width: 52,
//                   height: 52,
//                   decoration: BoxDecoration(
//                     color: spaceColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(AppValues.radiusLg),
//                     border: Border.all(color: spaceColor.withOpacity(0.2)),
//                   ),
//                   child: Center(
//                     child: Text(
//                       space.display,
//                       style: const TextStyle(fontSize: 26),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 // Info
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         space.name,
//                         style: GoogleFonts.poppins(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textDark,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       if ((space.description ?? '').isNotEmpty) ...[
//                         const SizedBox(height: 2),
//                         Text(
//                           space.description ?? '',
//                           style: GoogleFonts.poppins(
//                             fontSize: 11,
//                             color: AppColors.primary,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ],
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           SpaceStat(
//                             icon: Icons.task_alt_rounded,
//                             value: '${space.totalTasks}',
//                             label: 'tasks',
//                             color: spaceColor,
//                           ),
//                           const SizedBox(width: 8),
//                           SpaceStat(
//                             icon: Icons.note_outlined,
//                             value: '0',
//                             label: 'notes',
//                             color: spaceColor,
//                           ),
//                           const Spacer(), // ✅ بيدفع الـ badge ليمين بدل ما يطلع برة
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: !space.isPublic
//                                   ? AppColors.grey.withOpacity(0.15)
//                                   : AppColors.success.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   !space.isPublic
//                                       ? Icons.lock_outline_rounded
//                                       : Icons.public_rounded,
//                                   size: 9,
//                                   color: !space.isPublic
//                                       ? AppColors.textSecondary
//                                       : AppColors.success,
//                                 ),
//                                 const SizedBox(width: 3),
//                                 Text(
//                                   !space.isPublic ? 'Private' : 'Public',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w600,
//                                     color: !space.isPublic
//                                         ? AppColors.textSecondary
//                                         : AppColors.success,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // Right: Progress + Menu
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       width: 54,
//                       height: 54,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           CustomPaint(
//                             size: const Size(54, 54),
//                             painter: CircularProgressPainter(
//                               progress: _completionRate,
//                               color: spaceColor,
//                               strokeWidth: 5,
//                             ),
//                           ),
//                           Text(
//                             '${(_completionRate * 100).toInt()}%',
//                             style: GoogleFonts.poppins(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                               color: spaceColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     GestureDetector(
//                       onTap: () => _showActions(context),
//                       child: Container(
//                         width: 30,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: spaceColor.withOpacity(0.08),
//                           borderRadius:
//                           BorderRadius.circular(AppValues.radiusSm - 4),
//                           border: Border.all(
//                               color: spaceColor.withOpacity(0.15)),
//                         ),
//                         child: Icon(
//                           Icons.more_horiz_rounded,
//                           color: spaceColor,
//                           size: 16,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showActions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (_) => SpaceActionsSheet(
//         space: space,
//         onEdit: onEdit,
//         onDelete: onDelete,
//       ),
//     );
//   }
// }